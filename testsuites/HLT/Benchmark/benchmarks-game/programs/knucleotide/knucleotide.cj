/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping %f -o %output
// Throughput-oriented variant. It breaks one Benchmarks Game rule: stdin is streamed in large batches and parsed
// in parallel instead of line by line. Counting is identical to the strict version: per reading frame into library
// HashMaps grown from their default size, with 2-bit codes packed 32 per UInt64 and frames split across cores.
// Line breaks are '\n' or '\r\n'; a lone '\r' is not treated as a line break.
import std.collection.*
import std.convert.*
import std.process.*
import std.runtime.*
import std.sort.*

// 2-bit code = (ascii >> 1) & 3, case-insensitive: A=0 C=1 T=2 G=3
let toChar: Array<Rune> = [r'A', r'C', r'T', r'G']
let fragmentLengths: Array<Int64> = [1, 2, 3, 4, 6, 12, 18]
let fragments: Array<String> = ["GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"]
let threadNum: Int64 = getProcessorCount()

// Mutable count: a hit costs one hash lookup and no allocation, matching fastutil addTo in the Java program.
class Counter {
    var n: Int64
    init(n: Int64) {
        this.n = n
    }
}

// Sequence ">THREE" as 2-bit codes packed 32 per UInt64, first code in the most significant bits.
// One zero word of padding at the end so a key can always read words[w + 1].
class Sequence {
    let words: Array<UInt64>
    let size: Int64
    init(words: Array<UInt64>, size: Int64) {
        this.words = words
        this.size = size
    }

    // Key of the k codes starting at position p (k <= 32).
    func key(p: Int64, k: Int64): UInt64 {
        let w = p >> 5
        let s = UInt64((p & 31) * 2)
        // (x >> 1) >> (63 - s) == x >> (64 - s) for s > 0, and 0 for s == 0 (avoids an out-of-range shift)
        let bits = (words[w] << s) | ((words[w + 1] >> 1) >> (63 - s))
        return bits >> UInt64(64 - 2 * k)
    }
}

// Raw input is processed in batches that reuse one buffer, so its size does not depend on the input size.
let BATCH: Int64 = 1 << 25 // 32 MiB

// Parser states, carried across batches.
let SEEK: Int64 = 0 // looking for a '>' at the start of a line
let MATCH: Int64 = 1 // comparing a header with ">THREE"
let HEADER: Int64 = 2 // skipping the rest of the ">THREE" header line
let BODY: Int64 = 3 // inside the ">THREE" sequence
let DONE: Int64 = 4 // the next header was reached

// Positions in batch[0, len) of every '>' that starts a line, found in parallel.
// prevByte is the byte just before this batch ('\n' for the start of the input).
func headerStarts(batch: Array<UInt8>, len: Int64, prevByte: UInt8): ArrayList<Int64> {
    let parts = ArrayList<Future<ArrayList<Int64>>>()
    for (t in 0..threadNum) {
        let lo = len * t / threadNum
        let hi = len * (t + 1) / threadNum
        parts.add(spawn {
            let found = ArrayList<Int64>()
            for (i in lo..hi) {
                if (batch[i] == 62) { // '>'
                    let before = if (i == 0) { prevByte } else { batch[i - 1] }
                    if (before == 10) {
                        found.add(i)
                    }
                }
            }
            found
        })
    }
    let all = ArrayList<Int64>()
    for (p in parts) {
        all.add(all: p.get())
    }
    return all
}

// Pack the bases of batch[lo, hi) as codes first, first + 1, ... Whole words inside the slice are written directly;
// the partial words at either end are returned as (word, bits) fragments for the caller to OR in after all slices.
func packSlice(batch: Array<UInt8>, lo: Int64, hi: Int64, words: Array<UInt64>, first: Int64): ArrayList<(Int64, UInt64)> {
    let partials = ArrayList<(Int64, UInt64)>()
    var g = first
    var cur: UInt64 = 0
    for (i in lo..hi) {
        let b = batch[i]
        if (b == 10 || b == 13) { // skip '\n' and '\r'
            continue
        }
        cur = (cur << 2) | UInt64((b >> 1) & 3)
        g++
        if ((g & 31) == 0) {
            let w = (g >> 5) - 1
            if (w * 32 >= first) {
                words[w] = cur
            } else {
                partials.add((w, cur)) // the word started in an earlier slice
            }
            cur = 0
        }
    }
    if ((g & 31) != 0) {
        partials.add((g >> 5, cur << UInt64(2 * (32 - (g & 31))))) // the word continues in a later slice
    }
    return partials
}

// Append the bases of batch[lo, hi) to the packed words in parallel: count the bases of each slice, then pack each
// slice at the offset given by the prefix sum. Returns the (possibly grown) words and the new number of codes.
func packBody(batch: Array<UInt8>, lo: Int64, hi: Int64, words: Array<UInt64>, codes: Int64): (Array<UInt64>, Int64) {
    let n = hi - lo
    let counts = ArrayList<Future<Int64>>()
    for (t in 0..threadNum) {
        let sl = lo + n * t / threadNum
        let sh = lo + n * (t + 1) / threadNum
        counts.add(spawn {
            var c = 0
            for (i in sl..sh) {
                let b = batch[i]
                if (b != 10 && b != 13) {
                    c++
                }
            }
            c
        })
    }
    let offsets = Array<Int64>(threadNum + 1, repeat: 0)
    for (t in 0..threadNum) {
        offsets[t + 1] = offsets[t] + counts[t].get()
    }
    let total = codes + offsets[threadNum]
    let need = total / 32 + 2 // the last partial word plus one zero padding word
    let ws = if (need > words.size) {
        let bigger = Array<UInt64>(max(words.size * 2, need), repeat: 0)
        words.copyTo(bigger, 0, 0, words.size)
        bigger
    } else {
        words
    }
    let parts = ArrayList<Future<ArrayList<(Int64, UInt64)>>>()
    for (t in 0..threadNum) {
        let sl = lo + n * t / threadNum
        let sh = lo + n * (t + 1) / threadNum
        let first = codes + offsets[t]
        parts.add(spawn { packSlice(batch, sl, sh, ws, first) })
    }
    for (p in parts) {
        for ((w, bits) in p.get()) {
            ws[w] = ws[w] | bits
        }
    }
    return (ws, total)
}

// Stream stdin and keep only the ">THREE" sequence, packed. Reading stops at the next header, like the Java program.
func readSequence(): Sequence {
    // Process.current.stdIn is deprecated, but std.env.getStdIn() reads through getchar() per byte.
    let input = Process.current.stdIn
    let batch = Array<UInt8>(BATCH, repeat: 0)
    let three: Array<UInt8> = ">THREE".toArray()
    var words = Array<UInt64>(1 << 16, repeat: 0)
    var codes = 0
    var state = SEEK
    var matched = 0
    var prevByte: UInt8 = 10
    while (state != DONE) {
        var len = 0
        while (len < BATCH) {
            let n = input.read(batch[len..BATCH])
            if (n <= 0) {
                break
            }
            len += n
        }
        if (len == 0) {
            break
        }
        let heads = headerStarts(batch, len, prevByte)
        var h = 0 // first header position not before pos
        var pos = 0
        while (pos < len && state != DONE) {
            while (h < heads.size && heads[h] < pos) {
                h++
            }
            if (state == SEEK) {
                if (h == heads.size) {
                    pos = len
                } else {
                    pos = heads[h]
                    matched = 0
                    state = MATCH
                }
            } else if (state == MATCH) { // may continue from the previous batch
                while (pos < len && matched < three.size && batch[pos] == three[matched]) {
                    pos++
                    matched++
                }
                if (matched == three.size) {
                    state = HEADER
                } else if (pos < len) {
                    state = SEEK
                }
            } else if (state == HEADER) {
                while (pos < len && batch[pos] != 10) {
                    pos++
                }
                if (pos < len) {
                    pos++
                    state = BODY
                }
            } else { // BODY
                let end = if (h < heads.size) { heads[h] } else { len }
                (words, codes) = packBody(batch, pos, end, words, codes)
                pos = end
                if (h < heads.size) {
                    state = DONE
                }
            }
        }
        prevByte = batch[len - 1]
        if (len < BATCH) { // end of input
            break
        }
    }
    return Sequence(words, codes)
}

// Count k-nucleotides of one reading frame, frame positions [from, to): offset + i * k.
func countFrame(seq: Sequence, k: Int64, offset: Int64, from: Int64, to: Int64): HashMap<UInt64, Counter> {
    let map = HashMap<UInt64, Counter>()
    var p = offset + from * k
    for (_ in from..to) {
        let key = seq.key(p, k)
        match (map.get(key)) {
            case Some(c) => c.n++
            case None => map.add(key, Counter(1))
        }
        p += k
    }
    return map
}

// One task per (reading frame, slice). Frames of short fragments are sliced so every k keeps all cores busy;
// k = 1 would otherwise be a single 125M-update task on the critical path.
func spawnFrames(seq: Sequence, k: Int64): ArrayList<Future<HashMap<UInt64, Counter>>> {
    let tasks = ArrayList<Future<HashMap<UInt64, Counter>>>()
    let slices = max(1, threadNum / k)
    let lastStart = seq.size - k
    for (offset in 0..k) {
        if (offset > lastStart) {
            break
        }
        let frameSize = (lastStart - offset) / k + 1 // positions offset, offset + k, ... <= lastStart
        for (s in 0..slices) {
            let from = frameSize * s / slices
            let to = frameSize * (s + 1) / slices
            if (from < to) {
                tasks.add(spawn { countFrame(seq, k, offset, from, to) })
            }
        }
    }
    return tasks
}

func keyToString(key: UInt64, k: Int64): String {
    let sb = StringBuilder()
    var shift = (k - 1) * 2
    while (shift >= 0) {
        sb.append(toChar[Int64((key >> UInt64(shift)) & 3)])
        shift -= 2
    }
    return sb.toString()
}

func stringToKey(s: String): UInt64 {
    var key: UInt64 = 0
    for (c in s.toArray()) {
        key = (key << 2) | UInt64((c >> 1) & 3)
    }
    return key
}

func writeFrequencies(seqSize: Int64, k: Int64, tasks: ArrayList<Future<HashMap<UInt64, Counter>>>): Unit {
    let total = HashMap<UInt64, Int64>()
    for (f in tasks) {
        for ((key, c) in f.get()) {
            total.add(key, (total.get(key) ?? 0) + c.n)
        }
    }
    let kvs = ArrayList<(String, Int64)>()
    for ((key, v) in total) {
        kvs.add((keyToString(key, k), v))
    }
    let arr = kvs.toArray()
    // descending frequency, then ascending key
    sort(arr, by: {a: (String, Int64), b: (String, Int64) =>
        if (a[1] == b[1]) { a[0].compare(b[0]) } else { b[1].compare(a[1]) }
    }, stable: true)
    let sum = Float64(seqSize - k + 1)
    let sb = StringBuilder()
    for ((s, v) in arr) {
        sb.append(s)
        sb.append(r' ')
        sb.append((Float64(v * 100) / sum).format(".3"))
        sb.append(r'\n')
    }
    println(sb)
}

func writeCount(fragment: String, tasks: ArrayList<Future<HashMap<UInt64, Counter>>>): Unit {
    let key = stringToKey(fragment)
    var count = 0
    for (f in tasks) {
        if (let Some(c) <- f.get().get(key)) {
            count += c.n
        }
    }
    println("${count}\t${fragment}")
}

main(): Int64 {
    let seq = readSequence()
    // Submit all tasks up front, like Java's invokeAll.
    let tasks = ArrayList<ArrayList<Future<HashMap<UInt64, Counter>>>>()
    for (k in fragmentLengths) {
        tasks.add(spawnFrames(seq, k))
    }
    writeFrequencies(seq.size, 1, tasks[0])
    writeFrequencies(seq.size, 2, tasks[1])
    for (i in 0..fragments.size) {
        writeCount(fragments[i], tasks[i + 2])
    }
    return 0
}
