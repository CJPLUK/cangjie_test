/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
// T224-T227, T231: check local string predicates, comparisons, hashing, and search.

main(): Int64 {
    var failed = 0

    // T224: check size and character predicates.
    let s224: String @local? = "A¢仓\u{1F600}\u{0000}"
    failed += assertEq(s224.size, 11, "T224_unicode_size")
    let empty224: String @local? = ""
    failed += assertB(empty224.isEmpty(), "T224_empty_isEmpty")
    failed += assertB(empty224.isAscii(), "T224_empty_isAscii")
    failed += assertB(empty224.isAsciiBlank(), "T224_empty_isAsciiBlank")
    let nul224: String @local? = "A\u{0000}"
    failed += assertB(nul224.isAscii(), "T224_nul_isAscii_true")
    failed += assertB(!nul224.isAsciiBlank(), "T224_nul_isAsciiBlank_false")
    failed += assertEq(nul224.size, 2, "T224_nul_size")
    let ws224: String @local? = " \t\n"
    failed += assertB(ws224.isAsciiBlank(), "T224_asciiWs_isAsciiBlank")
    let cent224: String @local? = "¢"
    failed += assertB(!cent224.isAscii(), "T224_cent_notAscii")
    let nbsp224: String @local? = "\u{00A0}"
    failed += assertB(!nbsp224.isAscii(), "T224_nbsp_notAscii")
    failed += assertB(!nbsp224.isAsciiBlank(), "T224_nbsp_notAsciiBlank")

    // T225: match bytes without Unicode normalization.
    let s225: String @local? = "A\u{0000}¢仓\u{1F600}"
    failed += assertB(s225.contains(""), "T225_contains_empty_true")
    failed += assertB(s225.contains("\u{0000}"), "T225_contains_nul")
    failed += assertB(s225.contains("仓\u{1F600}"), "T225_contains_tail")
    failed += assertB(!s225.contains("X"), "T225_contains_miss")
    failed += assertB(!s225.contains("A\u{0000}¢仓\u{1F600}!"), "T225_contains_longer_false")
    failed += assertB(s225.startsWith(""), "T225_startsWith_empty")
    failed += assertB(s225.startsWith("A\u{0000}"), "T225_startsWith_nul")
    failed += assertB(!s225.startsWith("¢"), "T225_startsWith_miss")
    failed += assertB(s225.endsWith("\u{1F600}"), "T225_endsWith_emoji")
    failed += assertB(s225.endsWith(""), "T225_endsWith_empty")
    failed += assertB(!s225.endsWith("仓"), "T225_endsWith_miss")
    // NFC and NFD forms remain unequal.
    let nfc225: String @local? = "é"
    let nfd225: String @local? = "e\u{0301}"
    failed += assertB(!s225.contains(nfd225), "T225_nfc_notContains_nfd")

    // T226: equalsIgnoreAsciiCase
    let e226a: String @local? = "Az"
    failed += assertB(e226a.equalsIgnoreAsciiCase("aZ"), "T226_asciiFold_true")
    failed += assertB(!e226a.equalsIgnoreAsciiCase("aZx"), "T226_lengthMismatch_false")
    let emoji226: String @local? = "仓\u{1F600}"
    failed += assertB(emoji226.equalsIgnoreAsciiCase("仓\u{1F600}"), "T226_sameNonAscii_true")
    let e226b: String @local? = "É"
    let e226c: String @local? = "é"
    failed += assertB(!e226b.equalsIgnoreAsciiCase(e226c), "T226_nonAsciiNotFolded_false")
    failed += assertB(!nfc225.equalsIgnoreAsciiCase(nfd225), "T226_nfc_nfd_false")

    // T227: check comparison operators and hashing.
    let a227: String @local? = "a"
    let b227: String @local? = "b"
    failed += assertB(a227.compare(b227) == Ordering.LT, "T227_compare_LT")
    failed += assertB(a227.compare(a227) == Ordering.EQ, "T227_compare_EQ")
    failed += assertB(b227.compare(a227) == Ordering.GT, "T227_compare_GT")
    let ab227: String @local? = "ab"
    failed += assertB(ab227.compare(a227) == Ordering.GT, "T227_compare_prefix_GT")
    failed += assertB(a227.compare(ab227) == Ordering.LT, "T227_compare_prefix_LT")
    // NFC sorts after NFD by byte order.
    failed += assertB(nfc225.compare(nfd225) == Ordering.GT, "T227_compare_nfc_gt_nfd")
    // Check both equality and inequality directly.
    failed += assertB(a227 == a227, "T227_eq_EQ_true")
    failed += assertB(!(a227 == b227), "T227_eq_LT_false")
    failed += assertB(a227 != b227, "T227_ne_LT_true")
    failed += assertB(!(a227 != a227), "T227_ne_EQ_false")
    // Check all ordering operators.
    failed += assertB(a227 < b227, "T227_lt_LT_true")
    failed += assertB(!(a227 < a227), "T227_lt_EQ_false")
    failed += assertB(b227 > a227, "T227_gt_GT_true")
    failed += assertB(!(a227 > b227), "T227_gt_LT_false")
    failed += assertB(a227 <= a227, "T227_le_EQ_true")
    failed += assertB(a227 <= b227, "T227_le_LT_true")
    failed += assertB(!(b227 <= a227), "T227_le_GT_false")
    failed += assertB(b227 >= a227, "T227_ge_GT_true")
    failed += assertB(a227 >= a227, "T227_ge_EQ_true")
    failed += assertB(!(a227 >= b227), "T227_ge_LT_false")
    // Equal strings must have equal hashes.
    let h1a: String @local? = ""
    let h1b: String @local? = ""
    failed += assertB(h1a.hashCode() == h1b.hashCode(), "T227_hash_len0")
    let h3a: String @local? = "abc"
    let h3b: String @local? = "abc"
    let h1ca: String @local? = "a"
    let h1cb: String @local? = "a"
    failed += assertB(h1ca.hashCode() == h1cb.hashCode(), "T227_hash_len1")
    failed += assertB(h3a.hashCode() == h3b.hashCode(), "T227_hash_len3")
    let h4a: String @local? = "a¢仓\u{1F600}"
    let h4b: String @local? = "a¢仓\u{1F600}"
    failed += assertB(h4a.hashCode() == h4b.hashCode(), "T227_hash_len7")
    let h4aa: String @local? = "a¢仓\u{1F600}x"
    let h4bb: String @local? = "a¢仓\u{1F600}x"
    failed += assertB(h4aa.hashCode() == h4bb.hashCode(), "T227_hash_len8")
    let h8a: String @local? = "a¢仓\u{1F600}abc"
    let h8b: String @local? = "a¢仓\u{1F600}abc"
    failed += assertB(h8a.hashCode() == h8b.hashCode(), "T227_hash_len12")
    let h17a: String @local? = "abcdefghij¢¢¢仓仓仓仓"
    let h17b: String @local? = "abcdefghij¢¢¢仓仓仓仓"
    failed += assertB(h17a.hashCode() == h17b.hashCode(), "T227_hash_len28")
    let h16a: String @local? = "0123456789abcdef"
    let h16b: String @local? = "0123456789abcdef"
    failed += assertB(h16a.hashCode() == h16b.hashCode(), "T227_hash_len16")
    let h17a2: String @local? = "0123456789abcdefg"
    let h17b2: String @local? = "0123456789abcdefg"
    failed += assertB(h17a2.hashCode() == h17b2.hashCode(), "T227_hash_len17")
    let h48a: String @local? = "The quick brown fox jumps over the lazy dog 01"
    let h48b: String @local? = "The quick brown fox jumps over the lazy dog 01"
    failed += assertB(h48a.hashCode() == h48b.hashCode(), "T227_hash_len48")
    let h49a: String @local? = "The quick brown fox jumps over the lazy dog 0123"
    let h49b: String @local? = "The quick brown fox jumps over the lazy dog 0123"
    // Compare a shared 33-byte prefix with different final bytes.
    let p33a: String @local? = "012345678901234567890123456789012a"
    let p33b: String @local? = "012345678901234567890123456789012b"
    failed += assertB(p33a.compare(p33b) == Ordering.LT, "T227_compare_33byte_prefix_LT")
    failed += assertB(p33a != p33b, "T227_ne_33byte_prefix")
    failed += assertB(h49a.hashCode() == h49b.hashCode(), "T227_hash_len49")
    // Check heap overloads.
    let heap227a = "abcdefg"
    let heap227b = "abcdefg"
    failed += assertB(heap227a == heap227b, "T227_heap_eq")
    failed += assertB(heap227a.hashCode() == heap227b.hashCode(), "T227_heap_hash")

    // T231: indexOf on a shared receiver returns an exact heap Option payload.
    let s231: String @local! = "A¢仓A"
    let s231q: String @local? = s231
    let i231a: Option<Int64> = s231q.indexOf(b'A')
    match (i231a) {
        case Some(v) => failed += assertEq(v, 0, "T231_indexOf_A")
        case None => failed += 1
        println("FAIL: T231_indexOf_A — expected Some(0)")
    }
    let i231b: Option<Int64> = s231q.indexOf(0xC2u8)
    match (i231b) {
        case Some(v) => failed += assertEq(v, 1, "T231_indexOf_C2")
        case None => failed += 1
        println("FAIL: T231_indexOf_C2 — expected Some(1)")
    }
    let i231c: Option<Int64> = s231q.indexOf(0xA2u8)
    match (i231c) {
        case Some(v) => failed += assertEq(v, 2, "T231_indexOf_A2")
        case None => failed += 1
        println("FAIL: T231_indexOf_A2 — expected Some(2)")
    }
    let i231d: Option<Int64> = s231q.indexOf("仓")
    match (i231d) {
        case Some(v) => failed += assertEq(v, 3, "T231_indexOf_cang")
        case None => failed += 1
        println("FAIL: T231_indexOf_cang — expected Some(3)")
    }
    let i231e: Option<Int64> = s231q.indexOf("A")
    match (i231e) {
        case Some(v) => failed += assertEq(v, 0, "T231_indexOf_strA_first")
        case None => failed += 1
        println("FAIL: T231_indexOf_strA_first — expected Some(0)")
    }
    let i231f: Option<Int64> = s231q.indexOf(b'Z')
    match (i231f) {
        case Some(_) => failed += 1
        println("FAIL: T231_indexOf_absent — expected None")
        case None => failed += assertB(true, "T231_indexOf_absent_none")
    }
    let i231g: Option<Int64> = s231q.indexOf("A¢仓A!")
    match (i231g) {
        case Some(_) => failed += 1
        println("FAIL: T231_indexOf_tooLong — expected None")
        case None => failed += assertB(true, "T231_indexOf_tooLong_none")
    }
    // An exhausted search remains None.
    match (i231f) {
        case None => failed += assertB(true, "T231_indexOf_absent_repeat")
        case Some(_) => failed += 1
        println("FAIL: T231_indexOf_absent_repeat — expected None")
    }

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
