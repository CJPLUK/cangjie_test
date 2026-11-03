/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 --no-sub-pkg %f -o %output
// RUN-EXEC: %export cjHeapSize=512mb && %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan ms
// TIMEOUT: 1800
import std.collection.*
import std.time.*
import std.convert.*
import std.regex.*
import std.math.*

// ------ gbemu-part1 ------
var decodedgameboyrom: String = ""

var expectedGameboyStateStr: String = "{\"registerA\":160,\"registerB\":255,\"registerC\":255,\"registerE\":11,\"registersHL\":51600,\"programCounter\":24309,\"stackPointer\":49706,\"sumROM\":10171578,\"sumMemory\":3435856,\"sumMBCRam\":234598,\"sumVRam\":0}"

//Flash NPAPI Event Handler:
var samplesPerCallback: Int64 = 2048      //Has to be between 2048 and 4096 (If over, then samples are ignored, if under then silence is added).
var outputConvert: String = ""

var gameboy: ?GameBoyCore = None
var gbRunInt64erval: ?Any = None        //GameBoyCore Timer
var settings: Array<Any> = [            //Some settings.
    true,                 //Turn on sound.
    false,                //Boot with boot ROM first? (set to false for benchmarking)
    false,                //Give priority to GameBoy mode
    [39, 37, 38, 40, 88, 90, 16, 13],  //Keyboard button map.
    true,                //Colorize GB mode?
    false,                //Disallow typed arrays?
    4,                  //Int64erval for the emulator loop.
    15,                  //Audio buffer minimum span amount over x interpreter iterations.
    30,                  //Audio buffer maximum span amount over x interpreter iterations.
    false,                //Override to allow for MBC1 instead of ROM only (compatibility for broken 3rd-party cartridges).
    false,                //Override MBC RAM disabling and always allow reading and writing to the banks.
    false,                //Use the GameBoy boot ROM instead of the GameBoy Color boot ROM.
    false,                //Scale the canvas in JS, or let the browser scale the canvas?
    0x10,                //Int64ernal audio buffer pre-interpolation factor.
    1                  //Volume level set.
]

//Audio API Event Handler:
var audioContextHandle: ?GameBoyAudioContext = None
var audioNode: ?GameBoyAudioNodeConstrc = None
var audioSource: ?GameBoyAudioContextBufferSource = None
var launchedContext: Bool = false
var audioContextSampleBuffer: Array<Float32> = []
var resampled: Array<Float32> = []
var webAudioMinBufferSize: Int64 = 15000
var webAudioMaxBufferSize: Int64 = 25000
var webAudioActualSampleRate: Float64 = 44100.0
var XAudioJSSampleRate: Float64 = 0.0
var webAudioMono: Bool = false
var XAudioJSVolume: Int64 = 1
var resampleControl: ?Resampler = None
var audioBufferSize: Int64 = 0
var resampleBufferStart: Int64 = 0
var resampleBufferEnd: Int64 = 0
var resampleBufferSize: Int64 = 2
// Start of browser emulation.

class GameBoyWindowClass {
    var opera: Bool = false
    var mozRequestAnimationFrame: Bool = false
}

let GameBoyWindow = GameBoyWindowClass()

class GameBoyContext {
    func createImageData( w: Int64,  h: Int64) : GameBoyContextImageDataResult {
        let result = GameBoyContextImageDataResult()
        result.data = Array<Int64>( w * h * 4,repeat:0)
        return result
    }
    func putImageData( buffer: GameBoyContextImageDataResult,  x: Int64,  y: Int64) {
        var sum = 0
        for ( i in 0..buffer.data.size) {
            sum += i * buffer.data[i]
            sum = sum % 1000
        }
    }
    func drawImage( canvas: GameBoyCanvas,  x: Int64,  y: Int64,  screenWidth: Int64,  screenHeight: Int64) {
    }
}

class GameBoyContextImageDataResult {
    var data: Array<Int64> = []
}

class GameBoyCanvas {
    var width: Int64 = 160
    var height: Int64 = 144
    var clientWidth: Int64 = 0
    var clientHeight: Int64 = 0
    var style: GameBoyCanvasStyle = GameBoyCanvasStyle()
    func getContext( string: String) : GameBoyContext {
        return GameBoyContext()
    }
}

class GameBoyCanvasStyle {
    var visibility = "visibile"
}

func cout( message: String,  colorIndex: Int64) {
    
}

class GameBoyAudioNodeConstrc {
    var bufferSize: Int64 = 0
    var outputBuffer: ?GameBoyAudioNodeBuffer = None
    var onaudioprocess: ?((GameBoyAudioNodeEvent)->Unit) = None
    func connect( destination: GameBoyAudioContextDestination) {
        
    }
    func run() {
        let event: GameBoyAudioNodeEvent = GameBoyAudioNodeEvent()
        event.outputBuffer = outputBuffer
        onaudioprocess.getOrThrow()(event)
    }
}

let GameBoyAudioNode = GameBoyAudioNodeConstrc()

class GameBoyAudioNodeEvent {
    var outputBuffer: ?GameBoyAudioNodeBuffer = None
}

class GameBoyAudioNodeBuffer {
    var channelData: ArrayList<Array<Float32>> = ArrayList<Array<Float32>>()
    func getChannelData( i: Int64) : Array<Float32> {
        return channelData[i]
    }
}

class GameBoyAudioContext {
    var sampleRate: Float64 = 48000.0
    var destination: ?GameBoyAudioContextDestination = GameBoyAudioContextDestination()
    func createBufferSource() : GameBoyAudioContextBufferSource {
        return GameBoyAudioContextBufferSource()
    }
    func createBuffer( channels: Int64,  len: Int64,  sampleRate: Float64) : GameBoyAudioContextBuffer {
        return GameBoyAudioContextBuffer(1, 1, 1, 0.000020833333110203966, 48000)
    }
    func createJavaScriptNode( bufferSize: Int64,  inputChannels: Int64,  outputChannels: Int64) : GameBoyAudioNodeConstrc {
        GameBoyAudioNode.bufferSize = bufferSize
        GameBoyAudioNode.outputBuffer = GameBoyAudioNodeBuffer()
        for ( _ in 0..outputChannels) {
            GameBoyAudioNode.outputBuffer.getOrThrow().channelData.add(Array<Float32>(bufferSize,repeat:0.0))
        }
        return GameBoyAudioNode
    }
}

class GameBoyAudioContextBufferSource {
    var loop: Bool = false
    var buffer: ?GameBoyAudioContextBuffer = None
    func noteOn( index: Int64) {
        
    }
    func connect( audioNode: GameBoyAudioNodeConstrc) {
        
    }
}

class GameBoyAudioContextDestination {
    
}

class GameBoyAudioContextBuffer {
    var gain: Int64 = 0
    var numberOfChannels: Int64= 0
    var length: Int64= 0
    var duration: Float64= 0.0
    var sampleRate: Int64= 0
    init( gain: Int64,  numberOfChannels: Int64,  length: Int64,  duration: Float64,  sampleRate: Int64) {
        this.gain = gain
        this.numberOfChannels = numberOfChannels
        this.length = length
        this.duration = duration
        this.sampleRate = sampleRate
    }
}

var mock_date_time_counter: Int64 = 0

class new_Date {
    func getTime() : Int64 {
        mock_date_time_counter += 16
        return mock_date_time_counter
    }
}

// End of browser emulation.

// Start of helper functions.

func checkFinalState() {
let stateStr:String = "{\"registerA\":${gameboy.getOrThrow().registerA},\"registerB\":${gameboy.getOrThrow().registerB},\"registerC\":${gameboy.getOrThrow().registerC},\"registerE\":${gameboy.getOrThrow().registerE},\"registersHL\":${gameboy.getOrThrow().registersHL},\"programCounter\":${gameboy.getOrThrow().programCounter},\"stackPointer\":${gameboy.getOrThrow().stackPointer},\"sumROM\":${setStateSum((gameboy.getOrThrow().fromTypedArray(gameboy.getOrThrow().ROM) ))},\"sumMemory\":${setStateSum((gameboy.getOrThrow().fromTypedArray(gameboy.getOrThrow().memory)))},\"sumMBCRam\":${setStateSum((gameboy.getOrThrow().fromTypedArray(gameboy.getOrThrow().MBCRam)))},\"sumVRam\":${setStateSum((gameboy.getOrThrow().fromTypedArray(gameboy.getOrThrow().VRAM)))}}"
    if ( expectedGameboyStateStr.size > 0) {
        if ( stateStr != expectedGameboyStateStr) {
            
        }
    }
    else {
        
    }
}

func setStateSum( a: Array<Int64>) : Int64 {
    var result: Int64 = 0
    for ( i in 0..a.size) {
        result += a[i]
    }
    return result
}

func resetGlobalVariables() {

    //Audio API Event Handler:
    audioContextHandle = None
    audioNode = None
    audioSource = None
    launchedContext = false
    audioContextSampleBuffer = []
    resampled = []
    webAudioMinBufferSize = 15000
    webAudioMaxBufferSize = 25000
    webAudioActualSampleRate = 44100.0
    XAudioJSSampleRate = 0.0
    webAudioMono = false
    XAudioJSVolume = 1
    resampleControl = None
    audioBufferSize = 0
    resampleBufferStart = 0
    resampleBufferEnd = 0
    resampleBufferSize = 2
    gameboy = None           //GameBoyCore object.
}

// End of helper functions.

// Original code from Grant Galitz follows.
// Modifications by Google are marked in comments.

// Start of js/other/base64.js file.

var toBase64Table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
var base64Pad = "="

/* Convert Base64 data to a string */
var toBinaryTable: Array<Int64> = [
    -1,-1,-1,-1, -1,-1,-1,-1, -1,-1,-1,-1, -1,-1,-1,-1,
     -1,-1,-1,-1, -1,-1,-1,-1, -1,-1,-1,-1, -1,-1,-1,-1,
     -1,-1,-1,-1, -1,-1,-1,-1, -1,-1,-1,62, -1,-1,-1,63,
     52,53,54,55, 56,57,58,59, 60,61,-1,-1, -1, 0,-1,-1,
     -1, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,
     15,16,17,18, 19,20,21,22, 23,24,25,-1, -1,-1,-1,-1,
     -1,26,27,28, 29,30,31,32, 33,34,35,36, 37,38,39,40,
     41,42,43,44, 45,46,47,48, 49,50,51,-1, -1,-1,-1,-1
]

func base64decode( data: String) : String {
    var result = ""
    var leftbits = 0  // number of bits decoded, but yet to be appended
    var leftdata = 0   // bits decoded, but yet to be appended
    
    let charArray = data.toArray()
    
    for ( i in 0..data.size) {
        let c = toBinaryTable[Int64((charArray[i]) & 0x7f)]
        let padding = ((charArray[i]) == (base64Pad.toArray()[0]))
        // Skip illegal characters and whitespace
        if ( c == -1) { continue }
        
        // Collect data into leftdata, update bitcount
        leftdata = (leftdata << 6) | c
        leftbits += 6
        
        // If we have 8 or more bits, append 8 bits to the result
        if ( leftbits >= 8) {
            leftbits -= 8
            // Append if not padding.
            if ( (!padding)) {
                result += String(Rune(Int64(((leftdata >> leftbits) & 0xff))))
            }
            leftdata &= (1 << leftbits) - 1
        }
    }
    return result
}
// End of js/other/base64.js file.

// Start of js/other/resampler.js file.

//JavaScript Audio Resampler (c) 2011 - Grant Galitz
class Resampler {
    var fromSampleRate: Float64 = 0.0
    var toSampleRate: Float64 = 0.0
    var channels = 0
    var outputBufferSize: Int64 = 0
    var noReturn: Bool = false
    var resampler: ?((Array<Float32>)->Any) = None
    var ratioWeight: Float64 = 0.0
    var tailExists: Bool = false
    var lastWeight: Float64 = 0.0
    var lastOutput: Array<Float32> = []
    var outputBuffer: Array<Float32> = []
    init( fromSampleRate: Float64,  toSampleRate: Float64,  outputBufferSize: Int64,  noReturn: Bool,  channels!: Int64 = 0) {
        this.fromSampleRate = fromSampleRate
        this.toSampleRate = toSampleRate
        this.channels = channels | 0
        this.outputBufferSize = outputBufferSize
        this.noReturn = noReturn
        initialize()
    }
    func initialize() {
        //Perform some checks:
        if ( (fromSampleRate > 0.0 && toSampleRate > 0.0 && channels > 0)) {
            if ( (fromSampleRate == toSampleRate)) {
                //Setup a resampler bypass:
                resampler = bypassResampler    //Resampler just returns what was passed through.
                ratioWeight = 1.0
            }
            else {
                //Setup the interpolation resampler:
                resampler = interpolate      //Resampler is a custom quality interpolation algorithm.
                ratioWeight = fromSampleRate / toSampleRate
                tailExists = false
                lastWeight = 0.0
                initializeBuffers()
            }
        }
        else {
        }
    }
    func interpolate( buffer: Array<Float32>) : Any {
        let bufferLength = min(buffer.size, outputBufferSize)
        if ( ((bufferLength % 2) == 0)) {
            if ( (bufferLength > 0)) {
                let ratioWeight: Float64 = ratioWeight
                var weight: Float64 = 0.0
                var output0: Float64 = 0.0
                var output1: Float64 = 0.0
                var actualPosition: Int64 = 0
                var amountToNext: Float64 = 0.0
                var alreadyProcessedTail: Bool = !tailExists
                tailExists = false
                var outputBuffer:Array<Float32> = outputBuffer
                var outputOffset: Int64 = 0
                var currentPosition: Float64 = 0.0
                do {
                    if ( (alreadyProcessedTail)) {
                        weight = ratioWeight
                        output0 = 0.0
                        output1 = 0.0
                    }
                    else {
                        weight = Float64(lastWeight)
                        output0 = Float64(lastOutput[0])
                        output1 = Float64(lastOutput[1])
                        alreadyProcessedTail = true
                    }
                    while ( (weight > 0.0 && actualPosition < bufferLength)) {
                        amountToNext = 1.0 + Float64(actualPosition) - currentPosition
                        if ( (weight >= Float64(amountToNext))) {
                            output0 += Float64(buffer[actualPosition]) * amountToNext
                            actualPosition++
                            output1 += Float64(buffer[actualPosition]) * amountToNext
                            actualPosition++
                            currentPosition = Float64(actualPosition)
                            weight -= Float64(amountToNext)
                        }
                        else {
                            output0 += Float64(buffer[actualPosition]) * weight
                            output1 += Float64(buffer[actualPosition + 1]) * weight
                            currentPosition += weight
                            weight = 0.0
                            break
                        }
                    }
                    if ( (weight == 0.0)) {
                        outputBuffer[outputOffset] = Float32(output0 / ratioWeight)
                        outputOffset++
                        outputBuffer[outputOffset] = Float32(output1 / ratioWeight)
                        outputOffset++
                    }
                    else {
                        lastWeight = weight
                        lastOutput[0] = Float32(output0)
                        lastOutput[1] = Float32(output1)
                        tailExists = true
                        break
                    }
                } while (actualPosition < bufferLength)
                return bufferSlice(outputOffset)
            }
            else {
                if(noReturn){return 0}else{return Array<Any>()}
            }
        }
        else {
        }
        return Array<Any>()
    }
    func bypassResampler( buffer: Array<Float32>) : Any {
        if ( (noReturn)) {
            //Set the buffer passed as our own, as we don't need to resample it:
            outputBuffer = buffer
            return buffer.size
        }
        else {
            //Just return the buffer passsed:
            return buffer
        }
    }
    func bufferSlice( sliceAmount: Int64) : Any {
        if ( (noReturn)) {
            //If we're going to access the properties directly from this object:
            return sliceAmount
        }
        else {
            //Typed array and normal array buffer section referencing:
            return outputBuffer[0..sliceAmount]
        }
    }
    func initializeBuffers() {
        //Initialize the internal buffer:
        outputBuffer = Array<Float32>(outputBufferSize,repeat:Float32(0))
        lastOutput = Array<Float32>(channels,repeat:0.0)
    }
}

// End of js/other/resampler.js file.

// Start of js/other/XAudioServer.js file.

/*Initialize here first:
 Example:
 Stereo audio with a sample rate of 70 khz, a minimum buffer of 15000 samples total, a maximum buffer of 25000 samples total and a starting volume level of 1.
 var parentObj = this
 audioHandle = new XAudioServer(2, 70000, 15000, 25000, function (sampleCount) {
 return parentObj.audioUnderRun(sampleCount)
 }, 1)
 
 The callback is passed the number of samples requested, while it can return any number of samples it wants back.
 */
class XAudioServer {
    var audioChannels: Int64 = 0
    var channels: Int64 = 0
    var sampleRate: Int64 = 0
    var minBufferSize: Int64 = 0
    var maxBufferSize: Int64 = 0
    var volume = 0
    var audioType = -1
    var mozAudioTail: Array<Int64> = []
    var audioHandleMoz: ?Audio =None
    var audioHandleFlash: ?XAudioServer = None
    var flashInitialized: Bool = false
    var mozAudioFound: Bool = false
    var underRunCallback: ?((Int64)->Unit) = None
    public init( channels!: Int64 = 0, sampleRate!: Int64 = 0,  minBufferSize!: Int64 = 0,  maxBufferSize!: Int64 = 0, underRunCallback!: ?((Int64) -> Unit) = None,  volume!: Int64 = 0) {
        this.channels = channels
        this.sampleRate = sampleRate
        this.minBufferSize = minBufferSize
        this.maxBufferSize = maxBufferSize
        this.volume = volume
        if(channels == 2){audioChannels=2}else{audioChannels=1}
        webAudioMono = (audioChannels == 1)
        if((sampleRate > 0 && sampleRate <= 0xFFFFFF)){
            XAudioJSSampleRate = Float64(sampleRate)
        }else{XAudioJSSampleRate = Float64(44100)}
        if((minBufferSize >= (samplesPerCallback << 1) && minBufferSize < maxBufferSize)){
            if(webAudioMono){
                webAudioMinBufferSize= (minBufferSize & (0xFFFFFFFF ))
            }else{
                webAudioMinBufferSize= (minBufferSize & (0xFFFFFFFE))
            }

        }else{
            webAudioMinBufferSize=(samplesPerCallback << 1)
        }
        if(Int64(floor(Float64(maxBufferSize))) > webAudioMinBufferSize + audioChannels){
            if(webAudioMono){
                webAudioMaxBufferSize = (maxBufferSize & (0xFFFFFFFF ))
            }else{
                webAudioMaxBufferSize = (maxBufferSize & (0xFFFFFFFE))
            }

        }else{
            webAudioMaxBufferSize = (minBufferSize << 1)
        }
        if(underRunCallback.isNone()){this.underRunCallback }else{underRunCallback}
        if(volume >= 0 && volume <= 1){XAudioJSVolume=volume}else{XAudioJSVolume=1}
        initializeAudio()
    }
    func callbackBasedWriteAudioNoCallback( buffer: Array<Float32>) {
        //Callback-centered audio APIs:
        let length: Int64 = buffer.size
        var bufferCounter: Int64 = 0
        while ( bufferCounter < length && audioBufferSize < webAudioMaxBufferSize) {
            audioContextSampleBuffer[audioBufferSize] = buffer[bufferCounter]
            bufferCounter++
            audioBufferSize++
        }
    }
    /*Pass your samples into here if you don't want automatic callback calling:
     Pack your samples as a one-dimenional array
     With the channel samplea packed uniformly.
     examples:
     mono - [left, left, left, left]
     stereo - [left, right, left, right, left, right, left, right]
     Useful in preventing infinite recursion issues with calling writeAudio inside your callback.
     */
    func writeAudioNoCallback( buffer: Array<Float32>) {
        if ( (audioType == 0)) {
        }
        else if ( (audioType == 1)) {
            callbackBasedWriteAudioNoCallback(buffer)
        }
        else if ( (audioType == 2)) {
            if ( (checkFlashInit() || launchedContext)) {
                callbackBasedWriteAudioNoCallback(buffer)
            }
            else if ( (mozAudioFound)) {
            }
        }
    }
    //Developer can use this to see how many samples to write (example: minimum buffer allotment minus remaining samples left returned from this function to make sure maximum buffering is done...)
    //If -1 is returned, then that means metric could not be done.
    func remainingBuffer() : Int64 {
        if ( (audioType == 0)) {
            //mozAudio:
        }
        else if ( (audioType == 1)) {
            //WebKit Audio:
            return ((Int64(Float64(resampledSamplesLeft()) * resampleControl.getOrThrow().ratioWeight) >> (audioChannels - 1)) << (audioChannels - 1)) + audioBufferSize
        }
        else if ( (audioType == 2)) {
            if ( (checkFlashInit() || launchedContext)) {
                //Webkit Audio / Flash Plugin Audio:
                return ((Int64(Float64(resampledSamplesLeft()) * resampleControl.getOrThrow().ratioWeight) >> (audioChannels - 1)) << (audioChannels - 1)) + audioBufferSize
            }
            else if ( (mozAudioFound)) {
                //mozAudio:
            }
        }
        //Default return:
        return 0
    }
    //DO NOT CALL THIS, the lib calls this internally!
    func initializeAudio() {
        if ( (launchedContext)) {
            initializeWebAudio()
        }
        else {
            initializeFlashAudio()
        }
    }
    func initializeWebAudio() {
        resetCallbackAPIAudioBuffer(webAudioActualSampleRate, samplesPerCallback)
        audioType = 1
    }
    func changeVolume( newVolume: Int64) {
        if ( (newVolume >= 0 && newVolume <= 1)) {
            XAudioJSVolume = newVolume;
            if ( (checkFlashInit())) {
            }
        }
    }
    func initializeFlashAudio() {
        
    }
    //Checks to see if the NPAPI Adobe Flash bridge is ready yet:
    func checkFlashInit() : Bool {
        return flashInitialized
    }
}

class Audio {
    
}

/////////END LIB
func getFloat32( size: Int64) : Array<Float32> {
    return Array( size,repeat:Float32(0))
}
func getFloat32Flat( size: Int64) : Array<Float32> {
    return Array( size,repeat:Float32(0))
}

func generateFlashStereoString() : String {  //Convert the arrays to one long string for ( speed.
    var copyBinaryStringLeft: String = ""
    var copyBinaryStringRight: String = ""
    var index: Int64 = 0
    while ( (index < samplesPerCallback) && (resampleBufferStart != resampleBufferEnd)) {
        //Sanitize the buffer:
        copyBinaryStringLeft += String(Rune(((min(max(Int64(resampled[resampleBufferStart]) + 1, 0), 2) * 0x3FFF) | 0) + 0x3000))
        resampleBufferStart++
        copyBinaryStringRight += String(Rune(((min(max(Int64(resampled[resampleBufferStart]) + 1, 0), 2) * 0x3FFF) | 0) + 0x3000))
        resampleBufferStart++
        if ( resampleBufferStart == resampleBufferSize) {
            resampleBufferStart = 0
        }
        index += 1
    }
    return copyBinaryStringLeft + copyBinaryStringRight
}
func generateFlashMonoString() : String {  //Convert the array to one long string for ( speed.
    var copyBinaryString:String = ""
    var index: Int64 = 0
    while ( index < samplesPerCallback && resampleBufferStart != resampleBufferEnd) {
        //Sanitize the buffer:
        copyBinaryString += String(Rune(((min(max(Int64(resampled[resampleBufferStart]) + 1, 0), 2) * 0x3FFF) | 0) + 0x3000))
        resampleBufferStart++
        if ( resampleBufferStart == resampleBufferSize) {
            resampleBufferStart = 0
        }
        index += 1
    }
    return copyBinaryString
}

func audioOutputEvent( event: GameBoyAudioNodeEvent) {    //Web Audio API callback...
    var index = 0
    var buffer1 = event.outputBuffer.getOrThrow().getChannelData(0)
    var buffer2 = event.outputBuffer.getOrThrow().getChannelData(1)
    resampleRefill()
    if ( (!webAudioMono)) {
        //STEREO:
        while ( (index < samplesPerCallback && resampleBufferStart != resampleBufferEnd)) {
            buffer1[index] = Float32(resampled[resampleBufferStart] * Float32(XAudioJSVolume))
            resampleBufferStart++
            buffer2[index] = Float32(resampled[resampleBufferStart] * Float32(XAudioJSVolume))
            resampleBufferStart++
            index++
            if ( (resampleBufferStart == resampleBufferSize)) {
                resampleBufferStart = 0
            }
        }
    }
    else {
        //MONO:
        while ( (index < samplesPerCallback && resampleBufferStart != resampleBufferEnd)) {
            buffer1[index] = Float32(resampled[resampleBufferStart] * Float32(XAudioJSVolume))
            resampleBufferStart++
            buffer2[index] = buffer1[index]
            index += 1
            if ( (resampleBufferStart == resampleBufferSize)) {
                resampleBufferStart = 0
            }
        }
    }
    //Pad with silence if we're underrunning:
    while ( (index < samplesPerCallback)) {
        buffer1[index] = Float32(0)
        buffer2[index] = Float32(0)
        index += 1
    }
}

func resampleRefill() {
    if ( (audioBufferSize > 0)) {
        //Resample a chunk of audio:
        let resampleLength = (resampleControl.getOrThrow().resampler.getOrThrow()(getBufferSamples()) as Int64).getOrThrow()
        let resampledResult = resampleControl.getOrThrow().outputBuffer
        for ( index2 in 0..resampleLength) {
            resampled[resampleBufferEnd] = resampledResult[index2]
            resampleBufferEnd++
            if ( (resampleBufferEnd == resampleBufferSize)) {
                resampleBufferEnd = 0
            }
            if ( (resampleBufferStart == resampleBufferEnd)) {
                resampleBufferStart += 1
                if ( (resampleBufferStart == resampleBufferSize)) {
                    resampleBufferStart = 0
                }
            }
        }
        audioBufferSize = 0
    }
}

func resampledSamplesLeft() : Int64 {
    if((resampleBufferStart <= resampleBufferEnd)){
        return 0+resampleBufferEnd - resampleBufferStart
    }
    else{
        return  resampleBufferSize + resampleBufferEnd - resampleBufferStart
    }
}

func getBufferSamples() : Array<Float32> {
    // Typed array and normal array buffer section referencing:
    return audioContextSampleBuffer[0..audioBufferSize]
}

//Initialize WebKit Audio /Flash Audio Buffer:
func resetCallbackAPIAudioBuffer( APISampleRate: Float64,  bufferAlloc: Int64) {
    audioContextSampleBuffer = getFloat32(webAudioMaxBufferSize)
    audioBufferSize = webAudioMaxBufferSize
    resampleBufferStart = 0
    resampleBufferEnd = 0
    resampleBufferSize = max(webAudioMaxBufferSize * Int64(ceil(Float64(XAudioJSSampleRate / APISampleRate))), samplesPerCallback) << 1
    if ( (webAudioMono)) {
        //MONO Handling:
        resampled = getFloat32Flat(resampleBufferSize)
        resampleControl = Resampler(XAudioJSSampleRate, APISampleRate, resampleBufferSize, true,channels:1)
        outputConvert = generateFlashMonoString()
    }
    else {
        //STEREO Handling:
        resampleBufferSize  <<= 1
        resampled = getFloat32Flat(resampleBufferSize)
        resampleControl = Resampler(XAudioJSSampleRate, APISampleRate, resampleBufferSize, true,channels:2)
        outputConvert = generateFlashStereoString()
    }
}

//Initialize WebKit Audio:
func initializeWebKitAudio() {
 
    if ( (!launchedContext)) {
        // The following line was modified for benchmarking:
        audioContextHandle = GameBoyAudioContext()                       //Create a system audio context.
        audioSource = audioContextHandle.getOrThrow().createBufferSource()           //We need to create a false input to get the chain started.
        audioSource.getOrThrow().loop = false                                        //Keep this alive forever (Event handler will know when to ouput.)
        XAudioJSSampleRate = audioContextHandle.getOrThrow().sampleRate
        webAudioActualSampleRate = audioContextHandle.getOrThrow().sampleRate
        audioSource.getOrThrow().buffer = audioContextHandle.getOrThrow().createBuffer(1, 1, webAudioActualSampleRate)  //Create a zero'd input buffer for the input to be valid.
        audioNode = audioContextHandle.getOrThrow().createJavaScriptNode(samplesPerCallback, 1, 2)          //Create 2 outputs and ignore the input buffer (Just copy buffer 1 over if mono)
        audioNode.getOrThrow().onaudioprocess = audioOutputEvent                       //Connect the audio processing event to a handling function so we can manipulate output
        audioSource.getOrThrow().connect(audioNode.getOrThrow())                                   //Send and chain the input to the audio manipulation.
        audioNode.getOrThrow().connect(audioContextHandle.getOrThrow().destination.getOrThrow())               //Send and chain the output of the audio manipulation to the system audio output.
        audioSource.getOrThrow().noteOn(0)                                             //Start the loop!
        launchedContext = true
    }
}
// End of js/other/XAudioServer.js file.

// Start of js/other/resize.js file.

//JavaScript Image Resizer (c) 2012 - Grant Galitz
class Resize {
    var widthOriginal: Int64 = 0
    var heightOriginal: Int64 = 0
    var targetWidth: Int64 = 0
    var targetHeight:Int64 = 0
    var blendAlpha: Bool = false
    var colorChannels: Int64 = 0
    var interpolationPass: Bool = false
    var targetWidthMultipliedByChannels: Int64 = 0
    var originalWidthMultipliedByChannels: Int64 = 0
    var originalHeightMultipliedByChannels: Int64 = 0
    var widthPassResultSize: Int64 = 0
    var finalResultSize: Int64 = 0
    var resizeWidth:?((Array<Float32>)->Array<Float32>) = None
    var resizeHeight:?((Array<Float32>)->Array<Float32>) = None
    var ratioWeightWidthPass: Int64 = 0
    var ratioWeightHeightPass: Int64 = 0
    var outputWidthWorkBench: Array<Float32> = []
    var widthBuffer: Array<Float32> = []
    var outputHeightWorkBench: Array<Float32> = []
    var heightBuffer: Array<Int64> = []
    init( widthOriginal!: Int64 = 0,  heightOriginal!: Int64 = 0,  targetWidth!: Int64 = 0,  targetHeight!: Int64 = 0,  blendAlpha!: Bool = false,  interpolationPass!: Bool = false) {
        this.blendAlpha = blendAlpha
        if((widthOriginal as Int64).isSome()){
            this.widthOriginal = abs(widthOriginal)
        }else{
             this.widthOriginal = 0
        }
        if((heightOriginal as Int64).isSome()){
            this.heightOriginal = abs(heightOriginal)
        }else{
             this.heightOriginal = 0
        }
        if((targetWidth as Int64).isSome()){
            this.targetWidth = abs(targetWidth)
        }else{
             this.targetWidth = 0
        }
        if((targetHeight as Int64).isSome()){
            this.targetHeight = abs(targetHeight)
        }else{
             this.targetHeight = 0
        }
        if(blendAlpha){this.colorChannels=4}else{this.colorChannels=3}
        this.interpolationPass = interpolationPass
        this.targetWidthMultipliedByChannels = this.targetWidth * this.colorChannels
        this.originalWidthMultipliedByChannels = this.widthOriginal * this.colorChannels
        this.originalHeightMultipliedByChannels = this.heightOriginal * this.colorChannels
        this.widthPassResultSize = this.targetWidthMultipliedByChannels * this.heightOriginal
        this.finalResultSize = this.targetWidthMultipliedByChannels * this.targetHeight
        initialize()
    }
    
    func initialize() {
        //Perform some checks:
        if ( (widthOriginal > 0 && heightOriginal > 0 && targetWidth > 0 && targetHeight > 0)) {
            if ( (widthOriginal == targetWidth)) {
                //Bypass the width resizer pass:
                resizeWidth = bypassResizer
            }
            else {
                //Setup the width resizer pass:
                ratioWeightWidthPass = widthOriginal / targetWidth
                if ( (ratioWeightWidthPass < 1 && interpolationPass)) {
                    initializeFirstPassBuffers(true)
                    if(colorChannels == 4){resizeWidth =resizeWidthInt64erpolatedRGBA}else{resizeWidth= resizeWidthInt64erpolatedRGB}
                }
                else {
                    initializeFirstPassBuffers(false)
                    if(colorChannels == 4){resizeWidth = resizeWidthRGBA}else{resizeWidth = resizeWidthRGB}
                }
            }
            if ( (heightOriginal == targetHeight)) {
                //Bypass the height resizer pass:
                resizeHeight = bypassResizer
            }
            else {
                //Setup the height resizer pass:
                ratioWeightHeightPass = heightOriginal / targetHeight
                if ( (ratioWeightHeightPass < 1 && interpolationPass)) {
                    initializeSecondPassBuffers(true)
                    resizeHeight = resizeHeightInt64erpolated
                }
                else {
                    initializeSecondPassBuffers(false)
                    if(colorChannels == 4){resizeHeight =resizeHeightRGBA}else{resizeHeight =resizeHeightRGB}
                }
            }
        }
    }
    
    func resizeWidthRGB( buffer: Array<Float32>) : Array<Float32> {
        let ratioWeight = ratioWeightWidthPass
        var weight = 0
        var amountToNext = 0
        var actualPosition = 0
        var currentPosition = 0
        var line = 0
        var pixelOffset = 0
        var outputOffset = 0
        let nextLineOffsetOriginalWidth = originalWidthMultipliedByChannels - 2
        let nextLineOffsetTargetWidth = targetWidthMultipliedByChannels - 2
        var output = outputWidthWorkBench
        var outputBuffer = widthBuffer
        do {
            line = 0
            while ( line < originalHeightMultipliedByChannels) {
                output[line] = 0.0
                line++
                output[line] = 0.0
                line++
                output[line] = 0.0
                line++
            }
            weight = ratioWeight
            do {
                amountToNext = 1 + actualPosition - currentPosition
                if ( (weight >= amountToNext)) {
                    line = 0
                    pixelOffset = actualPosition
                    while ( line < originalHeightMultipliedByChannels) {
                        output[line] += Float32(buffer[pixelOffset] * Float32(amountToNext))
                        pixelOffset++
                        line++
                        output[line] += Float32(buffer[pixelOffset] * Float32(amountToNext))
                        pixelOffset++
                        line++
                        output[line] += Float32(buffer[pixelOffset] * Float32(amountToNext))
                        line++
                        pixelOffset += nextLineOffsetOriginalWidth
                    }
                    actualPosition = actualPosition + 3
                    currentPosition = actualPosition
                    weight -= amountToNext
                }
                else {
                    line = 0
                    pixelOffset = actualPosition
                    while ( line < originalHeightMultipliedByChannels) {
                        output[line] += Float32(buffer[pixelOffset] * Float32(weight))
                        pixelOffset++
                        line++
                        output[line] += Float32(buffer[pixelOffset] * Float32(weight))
                        pixelOffset++
                        line++
                        output[line] += Float32(buffer[pixelOffset] * Float32(weight))
                        line++
                        pixelOffset += nextLineOffsetOriginalWidth
                    }
                    currentPosition += weight
                    break
                }
            } while (weight > 0 && actualPosition < originalWidthMultipliedByChannels)
            line = 0
            pixelOffset = outputOffset
            while ( line < originalHeightMultipliedByChannels) {
                outputBuffer[pixelOffset] = output[line] / Float32(ratioWeight)
                line++
                pixelOffset++
                outputBuffer[pixelOffset] = output[line] / Float32(ratioWeight)
                line++
                pixelOffset++
                outputBuffer[pixelOffset] = output[line] / Float32(ratioWeight)
                line++
                pixelOffset += nextLineOffsetTargetWidth
            }
            outputOffset += 3
        } while (outputOffset < targetWidthMultipliedByChannels)
        return outputBuffer
    }
    
    func resizeWidthInt64erpolatedRGB( buffer: Array<Float32>) : Array<Float32> {
        let ratioWeight: Int64 = (widthOriginal - 1) / targetWidth;
        var weight: Int64 = 0;
        var finalOffset: Int64 = 0;
        var pixelOffset: Int64 = 0;
        var outputBuffer: Array<Float32> = widthBuffer;
        var targetPosition: Int64 = 0
        while ( targetPosition < targetWidthMultipliedByChannels) {
            //Calculate weightings:
            let secondWeight = weight % 1;
            let firstWeight = 1 - secondWeight;
            //Int64erpolate:
            finalOffset = targetPosition
            pixelOffset = Int64(floor(Float64(weight))) * 3
            while ( finalOffset < widthPassResultSize) {
                outputBuffer[finalOffset] = (buffer[pixelOffset] * Float32(firstWeight)) + (buffer[pixelOffset + 3] * Float32(secondWeight));
                outputBuffer[finalOffset + 1] = (buffer[pixelOffset + 1] * Float32(firstWeight)) + (buffer[pixelOffset + 4] * Float32(secondWeight));
                outputBuffer[finalOffset + 2] = (buffer[pixelOffset + 2] * Float32(firstWeight)) + (buffer[pixelOffset + 5] * Float32(secondWeight));
                pixelOffset += originalWidthMultipliedByChannels
                finalOffset += targetWidthMultipliedByChannels
            }
            targetPosition += 3;
            weight += ratioWeight;
        }
        return outputBuffer;
    }
    
    func resizeWidthInt64erpolatedRGBA( buffer: Array<Float32>) : Array<Float32> {
        let ratioWeight: Int64 = (widthOriginal - 1) / targetWidth
        var weight: Int64 = 0
        var finalOffset: Int64 = 0
        var pixelOffset: Int64 = 0
        var outputBuffer: Array<Float32> = widthBuffer
        var targetPosition: Int64 = 0
        while ( targetPosition < targetWidthMultipliedByChannels) {
            //Calculate weightings:
            let secondWeight = weight % 1
            let firstWeight = 1 - secondWeight
            //Int64erpolate:
            finalOffset = targetPosition
            pixelOffset = Int64(floor(Float64(weight))) * 4
            while ( finalOffset < widthPassResultSize) {
                outputBuffer[finalOffset] = (buffer[pixelOffset] * Float32(firstWeight)) + (buffer[pixelOffset + 4] * Float32(secondWeight))
                outputBuffer[finalOffset + 1] = (buffer[pixelOffset + 1] * Float32(firstWeight)) + (buffer[pixelOffset + 5] * Float32(secondWeight))
                outputBuffer[finalOffset + 2] = (buffer[pixelOffset + 2] * Float32(firstWeight)) + (buffer[pixelOffset + 6] * Float32(secondWeight))
                outputBuffer[finalOffset + 3] = (buffer[pixelOffset + 3] * Float32(firstWeight)) + (buffer[pixelOffset + 7] * Float32(secondWeight));
                pixelOffset += originalWidthMultipliedByChannels
                finalOffset += targetWidthMultipliedByChannels
            }
            targetPosition += 4
            weight += ratioWeight
        }
        return outputBuffer
    }
    
    func resizeWidthRGBA( buffer: Array<Float32>) : Array<Float32> {
        let ratioWeight: Int64 = ratioWeightWidthPass;
        var weight: Int64 = 0;
        var amountToNext: Int64 = 0;
        var actualPosition: Int64 = 0;
        var currentPosition: Int64 = 0;
        var line: Int64 = 0;
        var pixelOffset: Int64 = 0;
        var outputOffset: Int64 = 0;
        let nextLineOffsetOriginalWidth: Int64 = originalWidthMultipliedByChannels - 3;
        let nextLineOffsetTargetWidth: Int64 = targetWidthMultipliedByChannels - 3;
        var output: Array<Float32> = outputWidthWorkBench;
        var outputBuffer: Array<Float32> = widthBuffer;
        do {
            line = 0
            while ( line < originalHeightMultipliedByChannels) {
                output[line] = 0.0;
                line++
                output[line] = 0.0;
                line++
                output[line] = 0.0;
                line++
                output[line] = 0.0;
                line++
            }
            weight = ratioWeight;
            do {
                amountToNext = 1 + actualPosition - currentPosition;
                if ( (weight >= amountToNext)) {
                    line = 0
                    pixelOffset = actualPosition
                    while ( line < originalHeightMultipliedByChannels) {
                        output[line] += buffer[pixelOffset] * Float32(amountToNext);
                        pixelOffset++
                        line++
                        output[line] += buffer[pixelOffset] * Float32(amountToNext);
                        pixelOffset++
                        line++
                        output[line] += buffer[pixelOffset] * Float32(amountToNext);
                        pixelOffset++
                        line++
                        output[line] += buffer[pixelOffset] * Float32(amountToNext);
                        line++
                        pixelOffset += nextLineOffsetOriginalWidth
                    }
                    actualPosition = actualPosition + 4;
                    currentPosition = actualPosition
                    weight -= amountToNext;
                }
                else {
                    line = 0
                    pixelOffset = actualPosition
                    while ( line < originalHeightMultipliedByChannels) {
                        output[line] += buffer[pixelOffset] * Float32(weight);
                        pixelOffset++
                        line++
                        output[line] += buffer[pixelOffset] * Float32(weight);
                        pixelOffset++
                        line++
                        output[line] += buffer[pixelOffset] * Float32(weight);
                        pixelOffset++
                        line++
                        output[line] += buffer[pixelOffset] * Float32(weight);
                        line++
                        pixelOffset += nextLineOffsetOriginalWidth
                    }
                    currentPosition += weight;
                    break;
                }
            } while (weight > 0 && actualPosition < originalWidthMultipliedByChannels);
            line = 0
            pixelOffset = outputOffset
            while ( line < originalHeightMultipliedByChannels) {
                outputBuffer[pixelOffset] = output[line] / Float32(ratioWeight);
                line++
                pixelOffset++
                outputBuffer[pixelOffset] = output[line] / Float32(ratioWeight);
                line++
                pixelOffset++
                outputBuffer[pixelOffset] = output[line] / Float32(ratioWeight);
                line++
                pixelOffset++
                outputBuffer[pixelOffset] = output[line] / Float32(ratioWeight);
                line++
                pixelOffset += nextLineOffsetTargetWidth
            }
            outputOffset += 4;
        } while (outputOffset < targetWidthMultipliedByChannels);
        return outputBuffer;
    }
    
    func resizeHeightRGB( buffer: Array<Float32>) : Array<Float32> {
        let ratioWeight: Int64 = ratioWeightHeightPass
        var weight: Int64 = 0
        var amountToNext: Int64 = 0
        var actualPosition: Int64 = 0
        var currentPosition: Int64 = 0
        var pixelOffset: Int64 = 0
        var outputOffset: Int64 = 0
        var output: Array<Float32> = outputHeightWorkBench
        var outputBuffer: Array<Float32> = Array<Float32>(heightBuffer.size,repeat:0.0)
        do {
            pixelOffset = 0
            while ( pixelOffset < targetWidthMultipliedByChannels) {
                output[pixelOffset] = 0.0
                pixelOffset++
                output[pixelOffset] = 0.0
                pixelOffset++
                output[pixelOffset] = 0.0
                pixelOffset++
            }
            weight = ratioWeight
            do {
                amountToNext = 1 + actualPosition - currentPosition
                if ( (weight >= amountToNext)) {
                    pixelOffset = 0
                    while ( pixelOffset < targetWidthMultipliedByChannels) {
                        output[pixelOffset] += buffer[actualPosition] * Float32(amountToNext)
                        actualPosition++
                        pixelOffset++
                        output[pixelOffset] += buffer[actualPosition] * Float32(amountToNext)
                        actualPosition++
                        pixelOffset++
                        output[pixelOffset] += buffer[actualPosition] * Float32(amountToNext)
                        actualPosition++
                        pixelOffset++
                    }
                    currentPosition = actualPosition
                    weight -= amountToNext
                }
                else {
                    pixelOffset = 0
                    amountToNext = actualPosition
                    while ( pixelOffset < targetWidthMultipliedByChannels) {
                        output[pixelOffset] += buffer[amountToNext] * Float32(weight)
                        amountToNext++
                        pixelOffset++
                        output[pixelOffset] += buffer[amountToNext] * Float32(weight)
                        amountToNext++
                        pixelOffset++
                        output[pixelOffset] += buffer[amountToNext] * Float32(weight)
                        amountToNext++
                        pixelOffset++
                    }
                    currentPosition += weight
                    break
                }
            } while (weight > 0 && actualPosition < widthPassResultSize)
            pixelOffset = 0
            while ( pixelOffset < targetWidthMultipliedByChannels) {
                outputBuffer[outputOffset] = round(output[pixelOffset] / Float32(ratioWeight))
                pixelOffset++
                outputOffset++
                outputBuffer[outputOffset] = round(output[pixelOffset] / Float32(ratioWeight))
                pixelOffset++
                outputOffset++
                outputBuffer[outputOffset] = round(output[pixelOffset] / Float32(ratioWeight))
                pixelOffset++
                outputOffset++
            }
        } while (outputOffset < finalResultSize)
        if((outputBuffer as  Array<Float32>).isSome()){
            return outputBuffer
        }else{
            return Array<Float32>()
        }
    }
    
    func resizeHeightInt64erpolated( buffer: Array<Float32>) : Array<Float32> {
        let ratioWeight: Int64 = (heightOriginal - 1) / targetHeight
        var weight: Int64 = 0
        var finalOffset: Int64 = 0
        var pixelOffset: Int64 = 0
        var pixelOffsetAccumulated: Int64 = 0
        var pixelOffsetAccumulated2: Int64 = 0
        var outputBuffer: Array<Float32> =Array<Float32>( heightBuffer.size,repeat:0.0)
        do {
            //Calculate weightings:
            let secondWeight = weight % 1
            let firstWeight = 1 - secondWeight
            //Int64erpolate:
            pixelOffsetAccumulated = Int64(floor(Float64(weight))) * targetWidthMultipliedByChannels
            pixelOffsetAccumulated2 = pixelOffsetAccumulated + targetWidthMultipliedByChannels
            pixelOffset = 0
            while ( pixelOffset < targetWidthMultipliedByChannels) {
                outputBuffer[finalOffset] = (buffer[pixelOffsetAccumulated + pixelOffset] * Float32(firstWeight)) + (buffer[pixelOffsetAccumulated2 + pixelOffset] * Float32(secondWeight))
                finalOffset++
                pixelOffset += 1
            }
            weight += ratioWeight
        } while (finalOffset < finalResultSize)
        if((outputBuffer as  Array<Float32>).isSome()){
            return (outputBuffer as  Array<Float32>).getOrThrow()
        }else{
            return Array<Float32>()
        }
    }
    
    func resizeHeightRGBA( buffer: Array<Float32>) : Array<Float32> {
        let ratioWeight: Int64 = ratioWeightHeightPass
        var weight: Int64 = 0
        var amountToNext: Int64 = 0
        var actualPosition: Int64 = 0
        var currentPosition: Int64 = 0
        var pixelOffset: Int64 = 0
        var outputOffset: Int64 = 0
        var output: Array<Float32> = outputHeightWorkBench
        var outputBuffer: Array<Float32> =Array<Float32>( heightBuffer.size,repeat:0.0)
        do {
            pixelOffset = 0
            while ( pixelOffset < targetWidthMultipliedByChannels) {
                output[pixelOffset] = 0.0
                pixelOffset++
                output[pixelOffset] = 0.0
                pixelOffset++
                output[pixelOffset] = 0.0
                pixelOffset++
                output[pixelOffset] = 0.0
                pixelOffset++
            }
            weight = ratioWeight
            do {
                amountToNext = 1 + actualPosition - currentPosition
                if ( (weight >= amountToNext)) {
                    pixelOffset = 0
                    while ( pixelOffset < targetWidthMultipliedByChannels) {
                        output[pixelOffset] += buffer[actualPosition] * Float32(amountToNext)
                        actualPosition++
                        pixelOffset++
                        output[pixelOffset] += buffer[actualPosition] * Float32(amountToNext)
                        actualPosition++
                        pixelOffset++
                        output[pixelOffset] += buffer[actualPosition] * Float32(amountToNext)
                        actualPosition++
                        pixelOffset++
                        output[pixelOffset] += buffer[actualPosition] * Float32(amountToNext)
                        actualPosition++
                        pixelOffset++
                    }
                    currentPosition = actualPosition
                    weight -= amountToNext
                }
                else {
                    pixelOffset = 0
                    amountToNext = actualPosition
                    while ( pixelOffset < targetWidthMultipliedByChannels) {
                        output[pixelOffset] += buffer[amountToNext] * Float32(weight)
                        amountToNext++
                        pixelOffset++
                        output[pixelOffset] += buffer[amountToNext] * Float32(weight)
                        amountToNext++
                        pixelOffset++
                        output[pixelOffset] += buffer[amountToNext] * Float32(weight)
                        amountToNext++
                        pixelOffset++
                        output[pixelOffset] += buffer[amountToNext] * Float32(weight)
                        amountToNext++
                        pixelOffset++
                    }
                    currentPosition += weight
                    break
                }
            } while (weight > 0 && actualPosition < widthPassResultSize)
            pixelOffset = 0
            while ( pixelOffset < targetWidthMultipliedByChannels) {
                outputBuffer[outputOffset] = round(output[pixelOffset] / Float32(ratioWeight))
                pixelOffset++
                outputOffset++
                outputBuffer[outputOffset] = round(output[pixelOffset] / Float32(ratioWeight))
                pixelOffset++
                outputOffset++
                outputBuffer[outputOffset] = round(output[pixelOffset] / Float32(ratioWeight))
                pixelOffset++
                outputOffset++
                outputBuffer[outputOffset] = round(output[pixelOffset] / Float32(ratioWeight))
                pixelOffset++
                outputOffset++
            }
        } while (outputOffset < finalResultSize)
        if((outputBuffer as  Array<Float32>).isSome()){
            return (outputBuffer as  Array<Float32>).getOrThrow()
        }else{
            return Array<Float32>()
        }
    }
    
    func resize( buffer: Array<Float32>) : Array<Float32> {
        return resizeHeight.getOrThrow()(resizeWidth.getOrThrow()(buffer))
    }
    
    func bypassResizer( buffer: Array<Float32>) : Array<Float32> {
        //Just return the buffer passsed:
        return buffer
    }
    
    func initializeFirstPassBuffers( BILINEARAlgo: Bool) {
        //Initialize the internal width pass buffers:
        widthBuffer = generateFloatBuffer(widthPassResultSize)
        if ( (!BILINEARAlgo)) {
            outputWidthWorkBench = generateFloatBuffer(originalHeightMultipliedByChannels)
        }
    }
    
    func initializeSecondPassBuffers( BILINEARAlgo: Bool) {
        //Initialize the internal height pass buffers:
        heightBuffer = generateUint8Buffer(finalResultSize)
        if ( (!BILINEARAlgo)) {
            outputHeightWorkBench = generateFloatBuffer(targetWidthMultipliedByChannels)
        }
    }
    
    func generateFloatBuffer( bufferLength: Int64) : Array<Float32> {
        //Generate a float32 typed array buffer:
        return Array(bufferLength,repeat:Float32(0))
    }
    
    func generateUint8Buffer( bufferLength: Int64) : Array<Int64> {
        //Generate a uint8 typed array buffer:
        return Array(bufferLength,repeat:0)
    }
}
// End of js/other/resize.js file.

// Remaining files are in gbemu-part2.js, since they run in strict mode.

// ------ gbemu-part2 ------
class GameBoyCore {
    //Params, etc...
    var canvas: ?GameBoyCanvas = None				//Canvas DOM object for drawing out the graphics to.
    var drawContext: ?Any = None       				//LCD Context
    var ROMImage: String = ""            			//The game's ROM.
    //CPU Registers and Flags:
    var registerA: Int64 = 0x01       				//Register A (Accumulator)
    var FZero: Bool = true            				//Register F  - Result was zero
    var FSubtract: Bool = false       				//Register F  - Subtraction was executed
    var FHalfCarry: Bool = true       				//Register F  - Half carry or half borrow
    var FCarry: Bool = true           				//Register F  - Carry or borrow
    var registerB: Int64 = 0x00         				//Register B
    var registerC: Int64 = 0x13       				//Register C
    var registerD: Int64 = 0x00       				//Register D
    var registerE: Int64 = 0xD8       				//Register E
    var registerF: Int64 = 0          				//Register F
    var registersHL: Int64 = 0x014D        			//Registers H and L combined
    var stackPointer: Int64 = 0xFFFE       			//Stack Pointer
    var programCounter: Int64 = 0x0100     			//Program Counter
    //Some CPU Emulation State Variables:
    var CPUCyclesTotal: Float64 = 0.0               		//Relative CPU clocking to speed set, rounded appropriately.
    var CPUCyclesTotalBase: Float64 = 0.0         		//Relative CPU clocking to speed set base.
    var CPUCyclesTotalCurrent: Float64 = 0.0        		//Relative CPU clocking to speed set, the directly used value.
    var CPUCyclesTotalRoundoff: Float64 = 0.0       		//Clocking per iteration rounding catch.
    var baseCPUCyclesPerIteration: Float64 = 0.0    		//CPU clocks per iteration at 1x speed.
    var remainingClocks: Int64 = 0              			//HALT clocking overrun carry over.
    var inBootstrap: Bool = true              			//Whether we're in the GBC boot ROM.
    var usedBootROM: Bool = false             			//Updated upon ROM loading...
    var usedGBCBootROM: Bool = false          			//Did we boot to the GBC boot ROM?
    var halt: Bool = false                    			//Has the CPU been suspended until the next interrupt?
    var skipPCIncrement: Bool = false         			//Did we trip the DMG Halt bug?
    var stopEmulator: Int64 = 3                 			//Has the emulation been paused or a frame has ended?
    var IME: Bool = true                      			//Are interrupts enabled?
    var IRQLineMatched: Int64 = 0               			//CPU IRQ assertion.
    var interruptsRequested: Int64 = 0          			//IF Register
    var interruptsEnabled: Int64 = 0            			//IE Register
    var hdmaRunning: Bool = false             			//HDMA Transfer Flag - GBC only
    var CPUTicks: Int64 = 0                     			//The number of clock cycles emulated.
    var doubleSpeedShifter: Int64 = 0           			//GBC double speed clocking shifter.
    var JoyPad: UInt8 = 0xFF                  			//Joypad State (two four-bit states actually)
    var CPUStopped: Bool = false              			//CPU STOP status.
    //Main RAM, MBC RAM, GBC Main RAM, VRAM, etc.
    var memoryReader: Array<(GameBoyCore, Int64)->Int64> = Array( 0xFFFF+1,repeat:{parentObj, address => return 0})			//Array of functions mapped to read back memory
    var memoryWriter: Array<(GameBoyCore, Int64, Int64)->Unit> = Array(0xFFFF+1,repeat:{parentObj:GameBoyCore, address:Int64, data:Int64 => })		//Array of functions mapped to write to memory
    var memoryHighReader: Array<(GameBoyCore, Int64)->Int64> = Array(0xFF+1,repeat:{parentObj, address => return 0})			//Array of functions mapped to read back 0xFFXX memory
    var memoryHighWriter: Array<(GameBoyCore, Int64, Int64)->Unit> = Array(0xFF+1,repeat:{parentObj:GameBoyCore, address:Int64, data:Int64 => })		//Array of functions mapped to write to 0xFFXX memory
    var ROM: Array<Int64> = []                       			//The full ROM file dumped to an array.
    var memory: Array<Int64> = []                    			//Main Core Memory
    var MBCRam: Array<Int64> = []                              	//Switchable RAM (Used by games for more RAM) for the main memory range 0xA000 - 0xC000.
    var VRAM: Array<Int64> = []                      			//Extra VRAM bank for GBC.
    var GBCMemory: Array<Int64> = []                 			//GBC main RAM Banks
    var MBC1Mode: Bool = false                			//MBC1 Type (4/32, 16/8)
    var MBCRAMBanksEnabled: Bool = false      			//MBC RAM Access Control.
    var currMBCRAMBank: Int64 = 0                   		//MBC Currently Indexed RAM Bank
    var currMBCRAMBankPosition: Int64 = -0xA000     		//MBC Position Adder
    var cGBC: Bool = false                        		//GameBoy Color detection.
    var gbcRamBank: Int64 = 1                       		//Currently Switched GameBoy Color ram bank
    var gbcRamBankPosition: Int64 = -0xD000         		//GBC RAM offset from address start.
    var gbcRamBankPositionECHO: Int64 = -0xF000      		//GBC RAM (ECHO mirroring) offset from address start.
    var RAMBanks: Array<Int64> = [0, 1, 2, 4, 16]         		//Used to map the RAM banks to maximum size the MBC used can do.
    var ROMBank1offs: Int64 = 0                   		//Offset of the ROM bank switching.
    var currentROMBank: Int64 = 0                 		//The parsed current ROM bank selection.
    var cartridgeType: Int64 = 0                  		//Cartridge Type
    var name: String = ""                       		//Name of the game
    var gameCode: String = ""                   		//Game code (Suffix for older games)
    var fromSaveState: Bool = false             		//A boolean to see if this was loaded in as a save state.
    var savedStateFileName: String = ""         		//When loaded in as a save state, this will not be empty.
    var STATTracker: Int64 = 0                    		//Tracker for STAT triggering.
    var modeSTAT: Int64 = 0                       		//The scan line mode (for lines 1-144 it's 2-3-0, for 145-154 it's 1)
    var spriteCount: Int64 = 252                  		//Mode 3 extra clocking counter (Depends on how many sprites are on the current line.).
    var LYCMatchTriggerSTAT: Bool = false       		//Should we trigger an interrupt if LY==LYC?
    var mode2TriggerSTAT: Bool = false          		//Should we trigger an interrupt if in mode 2?
    var mode1TriggerSTAT: Bool = false          		//Should we trigger an interrupt if in mode 1?
    var mode0TriggerSTAT: Bool = false          		//Should we trigger an interrupt if in mode 0?
    var LCDisOn: Bool = false                   		//Is the emulated LCD controller on?
    var LINECONTROL: Array<(GameBoyCore) ->Unit> = Array(154,repeat:{parentObj => })                  // Array of functions to handle each scan line we do (onscreen + offscreen)
    var DISPLAYOFFCONTROL: Array<(GameBoyCore) ->Unit> = [{ parentObj =>
        //Array of line 0 function to handle the LCD controller when it's off (Do nothing!).
    }]
    var LCDCONTROL: Array<(GameBoyCore) ->Unit> = []                // Pointer to either LINECONTROL or DISPLAYOFFCONTROL.
    // RTC (Real Time Clock for MBC3):
    var RTCisLatched: Bool = false
    var latchedSeconds: Int64 = 0                  		// RTC latched seconds.
    var latchedMinutes: Int64 = 0                  		// RTC latched minutes.
    var latchedHours: Int64 = 0                    		// RTC latched hours.
    var latchedLDays: Int64 = 0                    		// RTC latched lower 8-bits of the day counter.
    var latchedHDays: Int64 = 0                    		// RTC latched high-bit of the day counter.
    var RTCSeconds: Int64 = 0                      		// RTC seconds counter.
    var RTCMinutes: Int64 = 0                      		// RTC minutes counter.
    var RTCHours: Int64 = 0                        		// RTC hours counter.
    var RTCDays: Int64 = 0                          		// RTC days counter.
    var RTCDayOverFlow: Bool = false              		// Did the RTC overflow and wrap the day counter?
    var RTCHALT: Bool = false                    		// Is the RTC allowed to clock up?
    // Gyro:
    var highX: Int64 = 127
    var lowX: Int64 = 127
    var highY: Int64 = 127
    var lowY: Int64 = 127
    // Sound variables:
    var audioHandle: ?XAudioServer = None            		//XAudioJS handle
    var numSamplesTotal: Int64 = 0                  		//Length of the sound buffers.
    var sampleSize: Float64 = 0.0                       		//Length of the sound buffer for one channel.
    var dutyLookup: Array<Array<Bool>> = [                  		//Map the duty values given to ones we can work with.
        [false, false, false, false, false, false, false, true],
        [true, false, false, false, false, false, false, true],
        [true, false, false, false, false, true, true, true],
        [false, true, true, true, true, true, true, false]
    ]
    var currentBuffer: Array<Int64> = []                    		//The audio buffer we're working on.
    var secondaryBuffer: Array<Float32> = []
    var bufferContainAmount: Int64 = 0                 		//Buffer maintenance metric.
    var LSFR15Table: Array<Int64> = []
    var LSFR7Table: Array<Int64> = []
    var noiseSampleTable: Array<Int64> = []
    
    var soundMasterEnabled: Bool = false           		//As its name implies
    var channel3PCM: Array<Int64> = []                    		//Channel 3 adjusted sample buffer.
    //Vin Shit:
    var VinLeftChannelMasterVolume: Int64 = 8        		//Computed post-mixing volume.
    var VinRightChannelMasterVolume: Int64 = 8       		//Computed post-mixing volume.
    //Channel paths enabled:
    var leftChannel1: Bool = false
    var leftChannel2: Bool = false
    var leftChannel3: Bool = false
    var leftChannel4: Bool = false
    var rightChannel1: Bool = false
    var rightChannel2: Bool = false
    var rightChannel3: Bool = false
    var rightChannel4: Bool = false
    //Channel output level caches:
    var channel1currentSampleLeft: Int64 = 0
    var channel1currentSampleRight: Int64 = 0
    var channel2currentSampleLeft: Int64 = 0
    var channel2currentSampleRight: Int64 = 0
    var channel3currentSampleLeft: Int64 = 0
    var channel3currentSampleRight: Int64 = 0
    var channel4currentSampleLeft: Int64 = 0
    var channel4currentSampleRight: Int64 = 0
    var channel1currentSampleLeftSecondary: Int64 = 0
    var channel1currentSampleRightSecondary: Int64 = 0
    var channel2currentSampleLeftSecondary: Int64 = 0
    var channel2currentSampleRightSecondary: Int64 = 0
    var channel3currentSampleLeftSecondary: Int64 = 0
    var channel3currentSampleRightSecondary: Int64 = 0
    var channel4currentSampleLeftSecondary: Int64 = 0
    var channel4currentSampleRightSecondary: Int64 = 0
    var channel1currentSampleLeftTrimary: Int64 = 0
    var channel1currentSampleRightTrimary: Int64 = 0
    var channel2currentSampleLeftTrimary: Int64 = 0
    var channel2currentSampleRightTrimary: Int64 = 0
    var mixerOutputCache: Int64 = 0
    //Pre-multipliers to cache some calculations:
    var machineOut: Int64 = 0                 			//Premultiplier for audio samples per instruction.
    // Audio generation counters:
    var audioTicks: Float64 = 0.0               			//Used to sample the audio system every x CPU instructions.
    var audioIndex: Int64 = 0                 			//Used to keep alignment on audio generation.
    var rollover: Int64 = 0                   			//Used to keep alignment on the number of samples to output (Realign from counter alias).
    // Timing Variables
    var emulatorTicks: Float64 = 0.0              			//Times for how many instructions to execute before ending the loop.
    var DIVTicks: Int64 = 56                  			//DIV Ticks Counter (Invisible lower 8-bit)
    var LCDTicks: Int64 = 60                  			//Counter for how many instructions have been executed on a scanline so far.
    var timerTicks: Int64 = 0                 			//Counter for the TIMA timer.
    var TIMAEnabled: Bool = false            			//Is TIMA enabled?
    var TACClocker: Int64 = 1024              			//Timer Max Ticks
    var serialTimer: Int64 = 0                			//Serial IRQ Timer
    var serialShiftTimer: Int64 = 0           			//Serial Transfer Shift Timer
    var serialShiftTimerAllocated: Int64 = 0  			//Serial Transfer Shift Timer Refill
    var IRQEnableDelay: Int64 = 0              			//Are the interrupts on queue to be enabled?
    var lastIteration: Int64 = new_Date().getTime()    		//The last time we iterated the main loop.
    var firstIteration: Int64 = new_Date().getTime()    		//The line is changed for benchmarking.
    var iterations: Int64 = 0
    var actualScanLine: Int64 = 0               			//Actual scan line...
    var lastUnrenderedLine: Int64 = 0           			//Last rendered scan line...
    var queuedScanLines: Int64 = 0
    var totalLinesPassed: Int64 = 0
    var haltPostClocks: Int64 = 0               			//Post-Halt clocking.
    // ROM Cartridge Components:
    var cMBC1: Bool = false                    			//Does the cartridge use MBC1?
    var cMBC2: Bool = false                    			//Does the cartridge use MBC2?
    var cMBC3: Bool = false                    			//Does the cartridge use MBC3?
    var cMBC5: Bool = false                    			//Does the cartridge use MBC5?
    var cMBC7: Bool = false                    			//Does the cartridge use MBC7?
    var cSRAM: Bool = false                    			//Does the cartridge use save RAM?
    var cMMMO1: Bool = false                   			//...
    var cRUMBLE: Bool = false                  			//Does the cartridge use the RUMBLE addressing (modified MBC5)?
    var cCamera: Bool = false                  			//Is the cartridge actually a GameBoy Camera?
    var cTAMA5: Bool = false                   			//Does the cartridge use TAMA5? (Tamagotchi Cartridge)
    var cHuC3: Bool = false                    			//Does the cartridge use HuC3 (Hudson Soft / modified MBC3)?
    var cHuC1: Bool = false                    			//Does the cartridge use HuC1 (Hudson Soft / modified MBC1)?
    var cTIMER: Bool = false                   			//Does the cartridge have an RTC?
    var ROMBanks:HashMap<Int64,Int64>= 				//1 Bank = 16 KBytes = 256 Kbits
        HashMap<Int64,Int64>([(0,2),(1,4),(2,8),(3,16),(4,32),(5,64),(6,128),(7,256),(8,512),(0x52,72),(0x53,80),(0x54,96)])
    var numRAMBanks: Int64 = 0                     		//How many RAM banks were actually allocated?
    //Graphics Variables
    var currVRAMBank: Int64 = 0                    		//Current VRAM bank for GBC.
    var backgroundX: Int64 = 0                     		//Register SCX (X-Scroll)
    var backgroundY: Int64 = 0                     		//Register SCY (Y-Scroll)
    var gfxWindowDisplay: Bool = false           		//Is the windows enabled?
    var gfxSpriteShow: Bool = false              		//Are sprites enabled?
    var gfxSpriteNormalHeight: Bool = true       		//Are we doing 8x8 or 8x16 sprites?
    var bgEnabled: Bool = true                   		//Is the BG enabled?
    var BGPriorityEnabled: Bool = true           		//Can we flag the BG for priority over sprites?
    var gfxWindowCHRBankPosition: Int64 = 0        		//The current bank of the character map the window uses.
    var gfxBackgroundCHRBankPosition: Int64 = 0    		//The current bank of the character map the BG uses.
    var gfxBackgroundBankOffset: Int64 = 0x80      		//Fast mapping of the tile numbering/
    var windowY: Int64 = 0                         		//Current Y offset of the window.
    var windowX: Int64 = 0                         		//Current X offset of the window.
    var drewBlank: Int64 = 0                       		//To prevent the repeating of drawing a blank screen.
    var drewFrame: Bool = false                  		//Throttle how many draws we can do to once per iteration.
    var midScanlineOffset: Int64 = -1              		//mid-scanline rendering offset.
    var pixelEnd: Int64 = 0                        		//track the x-coord limit for line rendering (mid-scanline usage).
    var currentX: Int64 = 0                        		//The x-coord we left off at for mid-scanline rendering.
    // BG Tile Pointer Caches:
    var BGCHRBank1: ArrayObject = ArrayObject()
    var BGCHRBank2: ArrayObject = ArrayObject()
    var BGCHRCurrentBank: ?ArrayObject = None
    // Tile Data Cache:
    var tileCache: ArrayList<ArrayObject> = ArrayList<ArrayObject>()
    // Palettes:
    var colors: Array<Int64> = [0xEFFFDE, 0xADD794, 0x529273, 0x183442] // "Classic" GameBoy palette colors.
    var OBJPalette: Array<Int64> = []
    var BGPalette: Array<Int64> = []
    var gbcOBJRawPalette: Array<Int64> = []
    var gbcBGRawPalette: Array<Int64> = []
    var gbOBJPalette: Array<Int64> = []
    var gbBGPalette: Array<Int64> = []
    var gbcOBJPalette: Array<Int64> = []
    var gbcBGPalette: Array<Int64> = []
    var gbBGColorizedPalette: Array<Int64> = []
    var gbOBJColorizedPalette: Array<Int64> = []
    var cachedBGPaletteConversion: Array<Int64> = []
    var cachedOBJPaletteConversion: Array<Int64> = []
    var updateGBBGPalette:?((Int64)->Unit)= None
    var updateGBOBJPalette:?((Int64, Int64)->Unit)= None
    var colorizedGBPalettes: Bool = false
    var BGLayerRender:?((Int64)->Unit) = None            		//Reference to the BG rendering function.
    var WindowLayerRender:?((Int64)->Unit)  = None       		//Reference to the window rendering function.
    var SpriteLayerRender:?((Int64)->Unit)  = None       		//Reference to the OAM rendering function.
    var frameBuffer: Array<Int64> = []                  		//The internal frame-buffer.
    var swizzledFrame: Array<Int64> = []                		//The secondary gfx buffer that holds the converted RGBA values.
    var canvasBuffer: ?GameBoyContextImageDataResult =None      // imageData handle
    var pixelStart: Int64 = 0                                     // Temp variable for holding the current working framebuffer offset.

    var onscreenWidth: Int64 = 160
    var offscreenWidth: Int64 = 160
    var onscreenHeight: Int64 = 144
    var offscreenHeight: Int64 = 144
    var offscreenRGBCount: Int64 =onscreenWidth * onscreenHeight * 4 
    // Start of code changed for benchmarking (removed ROM):
    var GBBOOTROM: Array<Int64> = []
    var GBCBOOTROM: Array<Int64> = []
    // End of code changed for benchmarking.
    
    let ffxxDump: Array<Int64> = [  //Dump of the post-BOOT I/O register state (From gambatte):
        0x0F, 0x00, 0x7C, 0xFF, 0x00, 0x00, 0x00, 0xF8,   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01,
        0x80, 0xBF, 0xF3, 0xFF, 0xBF, 0xFF, 0x3F, 0x00,   0xFF, 0xBF, 0x7F, 0xFF, 0x9F, 0xFF, 0xBF, 0xFF,
        0xFF, 0x00, 0x00, 0xBF, 0x77, 0xF3, 0xF1, 0xFF,   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF,   0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF,
        0x91, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFC,   0x00, 0x00, 0x00, 0x00, 0xFF, 0x7E, 0xFF, 0xFE,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3E, 0xFF,   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,   0xC0, 0xFF, 0xC1, 0x00, 0xFE, 0xFF, 0xFF, 0xFF,
        0xF8, 0xFF, 0x00, 0x00, 0x00, 0x8F, 0x00, 0x00,   0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B,   0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,
        0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E,   0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99,
        0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC,   0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E,
        0x45, 0xEC, 0x52, 0xFA, 0x08, 0xB7, 0x07, 0x5D,   0x01, 0xFD, 0xC0, 0xFF, 0x08, 0xFC, 0x00, 0xE5,
        0x0B, 0xF8, 0xC2, 0xCE, 0xF4, 0xF9, 0x0F, 0x7F,   0x45, 0x6D, 0x3D, 0xFE, 0x46, 0x97, 0x33, 0x5E,
        0x08, 0xEF, 0xF1, 0xFF, 0x86, 0x83, 0x24, 0x74,   0x12, 0xFC, 0x00, 0x9F, 0xB4, 0xB7, 0x06, 0xD5,
        0xD0, 0x7A, 0x00, 0x9E, 0x04, 0x5F, 0x41, 0x2F,   0x1D, 0x77, 0x36, 0x75, 0x81, 0xAA, 0x70, 0x3A,
        0x98, 0xD1, 0x71, 0x02, 0x4D, 0x01, 0xC1, 0xFF,   0x0D, 0x00, 0xD3, 0x05, 0xF9, 0x00, 0x0B, 0x00
    ]
    
    // other perpty
    var channel1FrequencyTracker: Int64 = 0x2000
    var channel1DutyTracker: Int64 = 0
    var channel1CachedDuty: Array<Bool> = []
    var channel1totalLength: Int64 = 0
    var channel1envelopeVolume: Int64 = 0
    var channel1envelopeType: Bool = false
    var channel1envelopeSweeps: Int64 = 0
    var channel1envelopeSweepsLast: Int64 = 0
    var channel1consecutive: Bool = true
    var channel1frequency: Int64 = 1985
    var channel1SweepFault: Bool = true
    var channel1ShadowFrequency: Int64 = 1985
    var channel1timeSweep: Int64 = 1
    var channel1lastTimeSweep: Int64 = 0
    var channel1numSweep: Int64 = 0
    var channel1frequencySweepDivider: Int64 = 0
    var channel1decreaseSweep: Bool = false
    var channel2FrequencyTracker: Int64 = 0x2000
    var channel2DutyTracker: Int64 = 0
    var channel2CachedDuty: Array<Bool> = []
    var channel2totalLength: Int64 = 0
    var channel2envelopeVolume: Int64 = 0
    var channel2envelopeType: Bool = false
    var channel2envelopeSweeps: Int64 = 0
    var channel2envelopeSweepsLast: Int64 = 0
    var channel2consecutive: Bool = true
    var channel2frequency: Int64 = 0
    var channel3canPlay: Bool = false
    var channel3totalLength: Int64 = 0
    var channel3patternType: Int64 = 4
    var channel3frequency: Int64 = 0
    var channel3consecutive: Bool = true
    var channel3Counter: Int64 = 0x418
    var channel4FrequencyPeriod: Int64 = 8
    var channel4totalLength: Int64 = 0
    var channel4envelopeVolume: Int64 = 0
    var channel4currentVolume: Int64 = 0
    var channel4envelopeType: Bool = false
    var channel4envelopeSweeps: Int64 = 0
    var channel4envelopeSweepsLast: Int64 = 0
    var channel4consecutive: Bool = true
    var channel4BitRange: Int64 = 0x7FFF
    var channel4VolumeShifter: Int64 = 15
    var channel1FrequencyCounter: Int64 = 0x200
    var channel2FrequencyCounter: Int64 = 0x200
    var channel3FrequencyPeriod: Int64 = 0x800
    var channel3lastSampleLookup: Int64 = 0
    var channel4lastSampleLookup: Int64 = 0
    var sequencerClocks: Int64 = 0x2000
    var sequencePosition: Int64 = 0
    var channel4Counter: Int64 = 8
    var cachedChannel3Sample: Int64 = 0
    var cachedChannel4Sample: Int64 = 0
    var channel1Enabled: Bool = false
    var channel2Enabled: Bool = false
    var channel3Enabled: Bool = false
    var channel4Enabled: Bool = false
    var channel1canPlay: Bool = false
    var channel2canPlay: Bool = false
    var channel4canPlay: Bool = false
    var ROMBankEdge: Int64 = 0
    var cBATT = false
    var OAMAddressCache: Array<Int64> = []
    var sortBuffer: Array<Int64> = []
    var resizer: ?Resize = None
    var instructions: Int64 = 0
    var totalInstructions: Int64 = 0
    var drawContextOnscreen: ?GameBoyContext = None
    var drawContextOffscreen: ?GameBoyContext = None
    var canvasOffscreen: ?GameBoyCanvas = None
    var openMBC: ((String)->Array<Int64>) = {val =>
        return []}
    var openRTC: ((String)->Array<Int64>) = {val =>
        return []}
    var numROMBanks: Int64 = 0
    
    var OPCODE: Array<(GameBoyCore)->Unit> = [
        //NOP
        //#0x00:
        { parentObj =>
            //Do Nothing...
        },
        //LD BC, nn
        //#0x01:
        { parentObj =>
            parentObj.registerC = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.registerB = parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF)
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
        },
        //LD (BC), A
        //#0x02:
        { parentObj =>
            parentObj.memoryWrite((parentObj.registerB << 8) | parentObj.registerC, parentObj.registerA)
        },
        //INC BC
        //#0x03:
        { parentObj =>
            let temp_var = ((parentObj.registerB << 8) | parentObj.registerC) + 1
            parentObj.registerB = (temp_var >> 8) & 0xFF
            parentObj.registerC = temp_var & 0xFF
        },
        //INC B
        //#0x04:
        { parentObj =>
            parentObj.registerB = (parentObj.registerB + 1) & 0xFF
            parentObj.FZero = (parentObj.registerB == 0)
            parentObj.FHalfCarry = ((parentObj.registerB & 0xF) == 0)
            parentObj.FSubtract = false
        },
        //DEC B
        //#0x05:
        { parentObj =>
            parentObj.registerB = (parentObj.registerB - 1) & 0xFF
            parentObj.FZero = (parentObj.registerB == 0)
            parentObj.FHalfCarry = ((parentObj.registerB & 0xF) == 0xF)
            parentObj.FSubtract = true
        },
        //LD B, n
        //#0x06:
        { parentObj =>
            parentObj.registerB = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //RLCA
        //#0x07:
        { parentObj =>
            parentObj.FCarry = (parentObj.registerA > 0x7F)
            parentObj.registerA = ((parentObj.registerA << 1) & 0xFF) | (parentObj.registerA >> 7)
            parentObj.FZero = false
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
        },
        //LD (nn), SP
        //#0x08:
        { parentObj =>
            let temp_var = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            parentObj.memoryWrite(temp_var, parentObj.stackPointer & 0xFF)
            parentObj.memoryWrite((temp_var + 1) & 0xFFFF, parentObj.stackPointer >> 8)
        },
        //ADD HL, BC
        //#0x09:
        { parentObj =>
            let dirtySum = parentObj.registersHL + ((parentObj.registerB << 8) | parentObj.registerC)
            parentObj.FHalfCarry = ((parentObj.registersHL & 0xFFF) > (dirtySum & 0xFFF))
            parentObj.FCarry = (dirtySum > 0xFFFF)
            parentObj.registersHL = dirtySum & 0xFFFF
            parentObj.FSubtract = false
        },
        //LD A, (BC)
        //#0x0A:
        { parentObj =>
            parentObj.registerA = parentObj.memoryRead((parentObj.registerB << 8) | parentObj.registerC)
        },
        //DEC BC
        //#0x0B:
        { parentObj =>
            let temp_var = (((parentObj.registerB << 8) | parentObj.registerC) - 1) & 0xFFFF
            parentObj.registerB = temp_var >> 8
            parentObj.registerC = temp_var & 0xFF
        },
        //INC C
        //#0x0C:
        { parentObj =>
            parentObj.registerC = (parentObj.registerC + 1) & 0xFF
            parentObj.FZero = (parentObj.registerC == 0)
            parentObj.FHalfCarry = ((parentObj.registerC & 0xF) == 0)
            parentObj.FSubtract = false
        },
        //DEC C
        //#0x0D:
        { parentObj =>
            parentObj.registerC = (parentObj.registerC - 1) & 0xFF
            parentObj.FZero = (parentObj.registerC == 0)
            parentObj.FHalfCarry = ((parentObj.registerC & 0xF) == 0xF)
            parentObj.FSubtract = true
        },
        //LD C, n
        //#0x0E:
        { parentObj =>
            parentObj.registerC = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //RRCA
        //#0x0F:
        { parentObj =>
            parentObj.registerA = (parentObj.registerA >> 1) | ((parentObj.registerA & 1) << 7)
            parentObj.FCarry = (parentObj.registerA > 0x7F)
            parentObj.FZero = false
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
        },
        //STOP
        //#0x10:
        { parentObj =>
            if ( (parentObj.cGBC)) {
                if ( ((parentObj.memory[0xFF4D] & 0x01) == 0x01)) {    //Speed change requested.
                    if ( (parentObj.memory[0xFF4D] > 0x7F)) {        //Go back to single speed mode.
                        cout("Going into single clock speed mode.", 0)
                        parentObj.doubleSpeedShifter = 0
                        parentObj.memory[0xFF4D] &= 0x7F        //Clear the double speed mode flag.
                    }
                    else {                        //Go to double speed mode.
                        cout("Going into double clock speed mode.", 0)
                        parentObj.doubleSpeedShifter = 1
                        parentObj.memory[0xFF4D] |= 0x80        //Set the double speed mode flag.
                    }
                    parentObj.memory[0xFF4D] &= 0xFE          //Reset the request bit.
                }
                else {
                    parentObj.handleSTOP()
                }
            }
            else {
                parentObj.handleSTOP()
            }
        },
        //LD DE, nn
        //#0x11:
        { parentObj =>
            parentObj.registerE = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.registerD = parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF)
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
        },
        //LD (DE), A
        //#0x12:
        { parentObj =>
            parentObj.memoryWrite((parentObj.registerD << 8) | parentObj.registerE, parentObj.registerA)
        },
        //INC DE
        //#0x13:
        { parentObj =>
            let temp_var = ((parentObj.registerD << 8) | parentObj.registerE) + 1
            parentObj.registerD = (temp_var >> 8) & 0xFF
            parentObj.registerE = temp_var & 0xFF
        },
        //INC D
        //#0x14:
        { parentObj =>
            parentObj.registerD = (parentObj.registerD + 1) & 0xFF
            parentObj.FZero = (parentObj.registerD == 0)
            parentObj.FHalfCarry = ((parentObj.registerD & 0xF) == 0)
            parentObj.FSubtract = false
        },
        //DEC D
        //#0x15:
        { parentObj =>
            parentObj.registerD = (parentObj.registerD - 1) & 0xFF
            parentObj.FZero = (parentObj.registerD == 0)
            parentObj.FHalfCarry = ((parentObj.registerD & 0xF) == 0xF)
            parentObj.FSubtract = true
        },
        //LD D, n
        //#0x16:
        { parentObj =>
            parentObj.registerD = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //RLA
        //#0x17:
        { parentObj =>
            var carryflag = 0
            if(parentObj.FCarry){
                carryflag = 1
            }
            parentObj.FCarry = (parentObj.registerA > 0x7F)
            parentObj.registerA = ((parentObj.registerA << 1) & 0xFF) | carryflag
            parentObj.FZero = false
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
        },
        //JR n
        //#0x18:
        { parentObj =>
            parentObj.programCounter = (parentObj.programCounter + (Int64(Int32(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)) << 24) >> 24) + 1) & 0xFFFF
        },
        //ADD HL, DE
        //#0x19:
        { parentObj =>
            let dirtySum = parentObj.registersHL + ((parentObj.registerD << 8) | parentObj.registerE)
            parentObj.FHalfCarry = ((parentObj.registersHL & 0xFFF) > (dirtySum & 0xFFF))
            parentObj.FCarry = (dirtySum > 0xFFFF)
            parentObj.registersHL = dirtySum & 0xFFFF
            parentObj.FSubtract = false
        },
        //LD A, (DE)
        //#0x1A:
        { parentObj =>
            parentObj.registerA = parentObj.memoryRead((parentObj.registerD << 8) | parentObj.registerE)
        },
        //DEC DE
        //#0x1B:
        { parentObj =>
            let temp_var = (((parentObj.registerD << 8) | parentObj.registerE) - 1) & 0xFFFF
            parentObj.registerD = temp_var >> 8
            parentObj.registerE = temp_var & 0xFF
        },
        //INC E
        //#0x1C:
        { parentObj =>
            parentObj.registerE = (parentObj.registerE + 1) & 0xFF
            parentObj.FZero = (parentObj.registerE == 0)
            parentObj.FHalfCarry = ((parentObj.registerE & 0xF) == 0)
            parentObj.FSubtract = false
        },
        //DEC E
        //#0x1D:
        { parentObj =>
            parentObj.registerE = (parentObj.registerE - 1) & 0xFF
            parentObj.FZero = (parentObj.registerE == 0)
            parentObj.FHalfCarry = ((parentObj.registerE & 0xF) == 0xF)
            parentObj.FSubtract = true
        },
        //LD E, n
        //#0x1E:
        { parentObj =>
            parentObj.registerE = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //RRA
        //#0x1F:
        { parentObj =>
            var carryflag = 0
            if(parentObj.FCarry){carryflag=0x80}
            parentObj.FCarry = ((parentObj.registerA & 1) == 1)
            parentObj.registerA = (parentObj.registerA >> 1) | carryflag
            parentObj.FZero = false
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
        },
        //JR NZ, n
        //#0x20:
        { parentObj =>
            if ( (!parentObj.FZero)) {
                parentObj.programCounter = (parentObj.programCounter + (Int64(Int32(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)) << 24) >> 24) + 1) & 0xFFFF
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            }
        },
        //LD HL, nn
        //#0x21:
        { parentObj =>
            parentObj.registersHL = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
        },
        //LDI (HL), A
        //#0x22:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registerA)
            parentObj.registersHL = (parentObj.registersHL + 1) & 0xFFFF
        },
        //INC HL
        //#0x23:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL + 1) & 0xFFFF
        },
        //INC H
        //#0x24:
        { parentObj =>
            let H = ((parentObj.registersHL >> 8) + 1) & 0xFF
            parentObj.FZero = (H == 0)
            parentObj.FHalfCarry = ((H & 0xF) == 0)
            parentObj.FSubtract = false
            parentObj.registersHL = (H << 8) | (parentObj.registersHL & 0xFF)
        },
        //DEC H
        //#0x25:
        { parentObj =>
            let H = ((parentObj.registersHL >> 8) - 1) & 0xFF
            parentObj.FZero = (H == 0)
            parentObj.FHalfCarry = ((H & 0xF) == 0xF)
            parentObj.FSubtract = true
            parentObj.registersHL = (H << 8) | (parentObj.registersHL & 0xFF)
        },
        //LD H, n
        //#0x26:
        { parentObj =>
            parentObj.registersHL = (parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter) << 8) | (parentObj.registersHL & 0xFF)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //DAA
        //#0x27:
        { parentObj =>
            if ( (!parentObj.FSubtract)) {
                if ( (parentObj.FCarry || parentObj.registerA > 0x99)) {
                    parentObj.registerA = (parentObj.registerA + 0x60) & 0xFF
                    parentObj.FCarry = true
                }
                if ( (parentObj.FHalfCarry || (parentObj.registerA & 0xF) > 0x9)) {
                    parentObj.registerA = (parentObj.registerA + 0x06) & 0xFF
                    parentObj.FHalfCarry = false
                }
            }
            else if ( (parentObj.FCarry && parentObj.FHalfCarry)) {
                parentObj.registerA = (parentObj.registerA + 0x9A) & 0xFF
                parentObj.FHalfCarry = false
            }
            else if ( (parentObj.FCarry)) {
                parentObj.registerA = (parentObj.registerA + 0xA0) & 0xFF
            }
            else if ( (parentObj.FHalfCarry)) {
                parentObj.registerA = (parentObj.registerA + 0xFA) & 0xFF
                parentObj.FHalfCarry = false
            }
            parentObj.FZero = (parentObj.registerA == 0)
        },
        //JR Z, n
        //#0x28:
        { parentObj =>
            if ( (parentObj.FZero)) {
                parentObj.programCounter = (parentObj.programCounter + (Int64(Int32(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)) << 24) >> 24) + 1) & 0xFFFF
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            }
        },
        //ADD HL, HL
        //#0x29:
        { parentObj =>
            parentObj.FHalfCarry = ((parentObj.registersHL & 0xFFF) > 0x7FF)
            parentObj.FCarry = (parentObj.registersHL > 0x7FFF)
            parentObj.registersHL = (parentObj.registersHL << 1) & 0xFFFF
            parentObj.FSubtract = false
        },
        //LDI A, (HL)
        //#0x2A:
        { parentObj =>
            parentObj.registerA = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.registersHL = (parentObj.registersHL + 1) & 0xFFFF
        },
        //DEC HL
        //#0x2B:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL - 1) & 0xFFFF
        },
        //INC L
        //#0x2C:
        { parentObj =>
            let L = (parentObj.registersHL + 1) & 0xFF
            parentObj.FZero = (L == 0)
            parentObj.FHalfCarry = ((L & 0xF) == 0)
            parentObj.FSubtract = false
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | L
        },
        //DEC L
        //#0x2D:
        { parentObj =>
            let L = (parentObj.registersHL - 1) & 0xFF
            parentObj.FZero = (L == 0)
            parentObj.FHalfCarry = ((L & 0xF) == 0xF)
            parentObj.FSubtract = true
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | L
        },
        //LD L, n
        //#0x2E:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //CPL
        //#0x2F:
        { parentObj =>
            parentObj.registerA ^= 0xFF
            parentObj.FSubtract = true
            parentObj.FHalfCarry = true
        },
        //JR NC, n
        //#0x30:
        { parentObj =>
            if ( (!parentObj.FCarry)) {
                parentObj.programCounter = (parentObj.programCounter + (Int64(Int32(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)) << 24) >> 24) + 1) & 0xFFFF
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            }
        },
        //LD SP, nn
        //#0x31:
        { parentObj =>
            parentObj.stackPointer = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
        },
        //LDD (HL), A
        //#0x32:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registerA)
            parentObj.registersHL = (parentObj.registersHL - 1) & 0xFFFF
        },
        //INC SP
        //#0x33:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer + 1) & 0xFFFF
        },
        //INC (HL)
        //#0x34:
        { parentObj =>
            let temp_var = (parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) + 1) & 0xFF
            parentObj.FZero = (temp_var == 0)
            parentObj.FHalfCarry = ((temp_var & 0xF) == 0)
            parentObj.FSubtract = false
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
        },
        //DEC (HL)
        //#0x35:
        { parentObj =>
            let temp_var = (parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) - 1) & 0xFF
            parentObj.FZero = (temp_var == 0)
            parentObj.FHalfCarry = ((temp_var & 0xF) == 0xF)
            parentObj.FSubtract = true
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
        },
        //LD (HL), n
        //#0x36:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter))
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //SCF
        //#0x37:
        { parentObj =>
            parentObj.FCarry = true
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
        },
        //JR C, n
        //#0x38:
        { parentObj =>
            if ( (parentObj.FCarry)) {
                parentObj.programCounter = (parentObj.programCounter + (Int64(Int32(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)) << 24) >> 24) + 1) & 0xFFFF
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            }
        },
        //ADD HL, SP
        //#0x39:
        { parentObj =>
            let dirtySum = parentObj.registersHL + parentObj.stackPointer
            parentObj.FHalfCarry = ((parentObj.registersHL & 0xFFF) > (dirtySum & 0xFFF))
            parentObj.FCarry = (dirtySum > 0xFFFF)
            parentObj.registersHL = dirtySum & 0xFFFF
            parentObj.FSubtract = false
        },
        //LDD A, (HL)
        //#0x3A:
        { parentObj =>
            parentObj.registerA = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.registersHL = (parentObj.registersHL - 1) & 0xFFFF
        },
        //DEC SP
        //#0x3B:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
        },
        //INC A
        //#0x3C:
        { parentObj =>
            parentObj.registerA = (parentObj.registerA + 1) & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) == 0)
            parentObj.FSubtract = false
        },
        //DEC A
        //#0x3D:
        { parentObj =>
            parentObj.registerA = (parentObj.registerA - 1) & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) == 0xF)
            parentObj.FSubtract = true
        },
        //LD A, n
        //#0x3E:
        { parentObj =>
            parentObj.registerA = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //CCF
        //#0x3F:
        { parentObj =>
            parentObj.FCarry = !parentObj.FCarry
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
        },
        //LD B, B
        //#0x40:
        { parentObj =>
            //Do nothing...
        },
        //LD B, C
        //#0x41:
        { parentObj =>
            parentObj.registerB = parentObj.registerC
        },
        //LD B, D
        //#0x42:
        { parentObj =>
            parentObj.registerB = parentObj.registerD
        },
        //LD B, E
        //#0x43:
        { parentObj =>
            parentObj.registerB = parentObj.registerE
        },
        //LD B, H
        //#0x44:
        { parentObj =>
            parentObj.registerB = parentObj.registersHL >> 8
        },
        //LD B, L
        //#0x45:
        { parentObj =>
            parentObj.registerB = parentObj.registersHL & 0xFF
        },
        //LD B, (HL)
        //#0x46:
        { parentObj =>
            parentObj.registerB = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
        },
        //LD B, A
        //#0x47:
        { parentObj =>
            parentObj.registerB = parentObj.registerA
        },
        //LD C, B
        //#0x48:
        { parentObj =>
            parentObj.registerC = parentObj.registerB
        },
        //LD C, C
        //#0x49:
        { parentObj =>
            //Do nothing...
        },
        //LD C, D
        //#0x4A:
        { parentObj =>
            parentObj.registerC = parentObj.registerD
        },
        //LD C, E
        //#0x4B:
        { parentObj =>
            parentObj.registerC = parentObj.registerE
        },
        //LD C, H
        //#0x4C:
        { parentObj =>
            parentObj.registerC = parentObj.registersHL >> 8
        },
        //LD C, L
        //#0x4D:
        { parentObj =>
            parentObj.registerC = parentObj.registersHL & 0xFF
        },
        //LD C, (HL)
        //#0x4E:
        { parentObj =>
            parentObj.registerC = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
        },
        //LD C, A
        //#0x4F:
        { parentObj =>
            parentObj.registerC = parentObj.registerA
        },
        //LD D, B
        //#0x50:
        { parentObj =>
            parentObj.registerD = parentObj.registerB
        },
        //LD D, C
        //#0x51:
        { parentObj =>
            parentObj.registerD = parentObj.registerC
        },
        //LD D, D
        //#0x52:
        { parentObj =>
            //Do nothing...
        },
        //LD D, E
        //#0x53:
        { parentObj =>
            parentObj.registerD = parentObj.registerE
        },
        //LD D, H
        //#0x54:
        { parentObj =>
            parentObj.registerD = parentObj.registersHL >> 8
        },
        //LD D, L
        //#0x55:
        { parentObj =>
            parentObj.registerD = parentObj.registersHL & 0xFF
        },
        //LD D, (HL)
        //#0x56:
        { parentObj =>
            parentObj.registerD = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
        },
        //LD D, A
        //#0x57:
        { parentObj =>
            parentObj.registerD = parentObj.registerA
        },
        //LD E, B
        //#0x58:
        { parentObj =>
            parentObj.registerE = parentObj.registerB
        },
        //LD E, C
        //#0x59:
        { parentObj =>
            parentObj.registerE = parentObj.registerC
        },
        //LD E, D
        //#0x5A:
        { parentObj =>
            parentObj.registerE = parentObj.registerD
        },
        //LD E, E
        //#0x5B:
        { parentObj =>
            //Do nothing...
        },
        //LD E, H
        //#0x5C:
        { parentObj =>
            parentObj.registerE = parentObj.registersHL >> 8
        },
        //LD E, L
        //#0x5D:
        { parentObj =>
            parentObj.registerE = parentObj.registersHL & 0xFF
        },
        //LD E, (HL)
        //#0x5E:
        { parentObj =>
            parentObj.registerE = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
        },
        //LD E, A
        //#0x5F:
        { parentObj =>
            parentObj.registerE = parentObj.registerA
        },
        //LD H, B
        //#0x60:
        { parentObj =>
            parentObj.registersHL = (parentObj.registerB << 8) | (parentObj.registersHL & 0xFF)
        },
        //LD H, C
        //#0x61:
        { parentObj =>
            parentObj.registersHL = (parentObj.registerC << 8) | (parentObj.registersHL & 0xFF)
        },
        //LD H, D
        //#0x62:
        { parentObj =>
            parentObj.registersHL = (parentObj.registerD << 8) | (parentObj.registersHL & 0xFF)
        },
        //LD H, E
        //#0x63:
        { parentObj =>
            parentObj.registersHL = (parentObj.registerE << 8) | (parentObj.registersHL & 0xFF)
        },
        //LD H, H
        //#0x64:
        { parentObj =>
            //Do nothing...
        },
        //LD H, L
        //#0x65:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF) * 0x101
        },
        //LD H, (HL)
        //#0x66:
        { parentObj =>
            parentObj.registersHL = (parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) << 8) | (parentObj.registersHL & 0xFF)
        },
        //LD H, A
        //#0x67:
        { parentObj =>
            parentObj.registersHL = (parentObj.registerA << 8) | (parentObj.registersHL & 0xFF)
        },
        //LD L, B
        //#0x68:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | parentObj.registerB
        },
        //LD L, C
        //#0x69:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | parentObj.registerC
        },
        //LD L, D
        //#0x6A:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | parentObj.registerD
        },
        //LD L, E
        //#0x6B:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | parentObj.registerE
        },
        //LD L, H
        //#0x6C:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | (parentObj.registersHL >> 8)
        },
        //LD L, L
        //#0x6D:
        { parentObj =>
            //Do nothing...
        },
        //LD L, (HL)
        //#0x6E:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
        },
        //LD L, A
        //#0x6F:
        { parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | parentObj.registerA
        },
        //LD (HL), B
        //#0x70:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registerB)
        },
        //LD (HL), C
        //#0x71:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registerC)
        },
        //LD (HL), D
        //#0x72:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registerD)
        },
        //LD (HL), E
        //#0x73:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registerE)
        },
        //LD (HL), H
        //#0x74:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registersHL >> 8)
        },
        //LD (HL), L
        //#0x75:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registersHL & 0xFF)
        },
        //HALT
        //#0x76:
        { parentObj =>
            //See if there's already an IRQ match:
            if ( ((parentObj.interruptsEnabled & parentObj.interruptsRequested & 0x1F) > 0)) {
                if ( (!parentObj.cGBC && !parentObj.usedBootROM)) {
                    //HALT bug in the DMG CPU model (Program Counter fails to increment for one instruction after HALT):
                    parentObj.skipPCIncrement = true
                }
                else {
                    //CGB gets around the HALT PC bug by doubling the hidden NOP.
                    parentObj.CPUTicks += 4
                }
            }
            else {
                //CPU is stalled until the next IRQ match:
                parentObj.calculateHALTPeriod()
            }
        },
        //LD (HL), A
        //#0x77:
        { parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.registerA)
        },
        //LD A, B
        //#0x78:
        { parentObj =>
            parentObj.registerA = parentObj.registerB
        },
        //LD A, C
        //#0x79:
        { parentObj =>
            parentObj.registerA = parentObj.registerC
        },
        //LD A, D
        //#0x7A:
        { parentObj =>
            parentObj.registerA = parentObj.registerD
        },
        //LD A, E
        //#0x7B:
        { parentObj =>
            parentObj.registerA = parentObj.registerE
        },
        //LD A, H
        //#0x7C:
        { parentObj =>
            parentObj.registerA = parentObj.registersHL >> 8
        },
        //LD A, L
        //#0x7D:
        { parentObj =>
            parentObj.registerA = parentObj.registersHL & 0xFF
        },
        //LD, A, (HL)
        //#0x7E:
        { parentObj =>
            parentObj.registerA = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
        },
        //LD A, A
        //#0x7F:
        { parentObj =>
            //Do Nothing...
        },
        //ADD A, B
        //#0x80:
        { parentObj =>
            let dirtySum = parentObj.registerA + parentObj.registerB
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADD A, C
        //#0x81:
        { parentObj =>
            let dirtySum = parentObj.registerA + parentObj.registerC
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADD A, D
        //#0x82:
        { parentObj =>
            let dirtySum = parentObj.registerA + parentObj.registerD
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADD A, E
        //#0x83:
        { parentObj =>
            let dirtySum = parentObj.registerA + parentObj.registerE
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADD A, H
        //#0x84:
        { parentObj =>
            let dirtySum = parentObj.registerA + (parentObj.registersHL >> 8)
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADD A, L
        //#0x85:
        { parentObj =>
            let dirtySum = parentObj.registerA + (parentObj.registersHL & 0xFF)
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADD A, (HL)
        //#0x86:
        { parentObj =>
            let dirtySum = parentObj.registerA + parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADD A, A
        //#0x87:
        { parentObj =>
            parentObj.FHalfCarry = ((parentObj.registerA & 0x8) == 0x8)
            parentObj.FCarry = (parentObj.registerA > 0x7F)
            parentObj.registerA = (parentObj.registerA << 1) & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, B
        //#0x88:
        { parentObj =>
            var dirtySum  = parentObj.registerA + parentObj.registerB 
            if(parentObj.FCarry){
                dirtySum = parentObj.registerA + parentObj.registerB + 1
            }
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerB & 0xF) + ( 1 ) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerB & 0xF) + (0) > 0xF)
            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, C
        //#0x89:
        { parentObj =>
            var dirtySum = parentObj.registerA + parentObj.registerC
            if(parentObj.FCarry){dirtySum = parentObj.registerA + parentObj.registerC + 1}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerC & 0xF) + (1 ) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerC & 0xF) + ( 0) > 0xF)
            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, D
        //#0x8A:
        { parentObj =>
            var dirtySum = parentObj.registerA + parentObj.registerD +  0
            if(parentObj.FCarry){dirtySum = parentObj.registerA + parentObj.registerD +  1}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerD & 0xF) + (1 ) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerD & 0xF) +  0 > 0xF)
            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, E
        //#0x8B:
        { parentObj =>
            var dirtySum = parentObj.registerA + parentObj.registerE +  0
            if(parentObj.FCarry){dirtySum = parentObj.registerA + parentObj.registerE +  1}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerE & 0xF) + (1 ) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (parentObj.registerE & 0xF) +  0 > 0xF)
            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, H
        //#0x8C:
        { parentObj =>
            let tempValue = (parentObj.registersHL >> 8)
            var dirtySum = parentObj.registerA + tempValue+  0
            if(parentObj.FCarry){dirtySum = parentObj.registerA + tempValue+  1}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) + (1 ) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) +  0 > 0xF)
            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, L
        //#0x8D:
        { parentObj =>
            let tempValue = (parentObj.registersHL & 0xFF)
            var dirtySum = parentObj.registerA + tempValue +0
            if(parentObj.FCarry){dirtySum = parentObj.registerA + tempValue +1}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) + (1) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) + ( 0) > 0xF)

            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, (HL)
        //#0x8E:
        { parentObj =>
            let tempValue = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            var dirtySum = parentObj.registerA + tempValue +0
            if(parentObj.FCarry){dirtySum = parentObj.registerA + tempValue +1}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) + (1) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) + ( 0) > 0xF)

            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //ADC A, A
        //#0x8F:
        { parentObj =>
            //shift left register A one bit for some ops here as an optimization:
            var dirtySum = (parentObj.registerA << 1) | (0)
            if(parentObj.FCarry){dirtySum = (parentObj.registerA << 1) | (1)}
            if(parentObj.FCarry){
                parentObj.FHalfCarry =((((parentObj.registerA << 1) & 0x1E) |(1)) > 0xF)
            }else{
                parentObj.FHalfCarry = ((((parentObj.registerA << 1) & 0x1E) | ( 0)) > 0xF)

            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //SUB A, B
        //#0x90:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerB
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //SUB A, C
        //#0x91:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerC
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //SUB A, D
        //#0x92:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerD
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //SUB A, E
        //#0x93:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerE
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //SUB A, H
        //#0x94:
        { parentObj =>
            let dirtySum = parentObj.registerA - (parentObj.registersHL >> 8)
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //SUB A, L
        //#0x95:
        { parentObj =>
            let dirtySum = parentObj.registerA - (parentObj.registersHL & 0xFF)
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //SUB A, (HL)
        //#0x96:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //SUB A, A
        //#0x97:
        { parentObj =>
            //number - same number == 0
            parentObj.registerA = 0
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
            parentObj.FZero = true
            parentObj.FSubtract = true
        },
        //SBC A, B
        //#0x98:
        { parentObj =>
            var dirtySum = parentObj.registerA - parentObj.registerB - ( 0)
            if(parentObj.FCarry){dirtySum = parentObj.registerA - parentObj.registerB - ( 1)}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerB & 0xF) - ( 1 ) < 0)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerB & 0xF) - ( 0) < 0)
            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //SBC A, C
        //#0x99:
        { parentObj =>
            var dirtySum = parentObj.registerA - parentObj.registerC - ( 0)
            if(parentObj.FCarry){dirtySum = parentObj.registerA - parentObj.registerC - ( 1)}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerC & 0xF) - ( 1 ) < 0)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerC & 0xF) - ( 0) < 0)
            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //SBC A, D
        //#0x9A:
        { parentObj =>
            var dirtySum = parentObj.registerA - parentObj.registerD - ( 0)
            if(parentObj.FCarry){dirtySum = parentObj.registerA - parentObj.registerD - ( 1)}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerD & 0xF) - ( 1 ) < 0)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerD & 0xF) - ( 0) < 0)
            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //SBC A, E
        //#0x9B:
        { parentObj =>
            var dirtySum = parentObj.registerA - parentObj.registerE - ( 0)
            if(parentObj.FCarry){dirtySum = parentObj.registerA - parentObj.registerE - ( 1)}
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerE & 0xF) - ( 1 ) < 0)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registerE & 0xF) - ( 0) < 0)
            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //SBC A, H
        //#0x9C:
        { parentObj =>
            let temp_var = parentObj.registersHL >> 8
            var dirtySum = parentObj.registerA - temp_var - (0)
            if(parentObj.FCarry){dirtySum = parentObj.registerA - temp_var - ( 1)} 
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (temp_var & 0xF) - (1) < 0)

            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (temp_var & 0xF) - (0) < 0)

            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //SBC A, L
        //#0x9D:
        { parentObj =>
            var dirtySum = parentObj.registerA - (parentObj.registersHL & 0xFF) - 0
            if(parentObj.FCarry){dirtySum = parentObj.registerA - (parentObj.registersHL & 0xFF) - 1} 
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registersHL & 0xF) - (1) < 0)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (parentObj.registersHL & 0xF) - ( 0) < 0)
            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //SBC A, (HL)
        //#0x9E:
        { parentObj =>
            let temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            var dirtySum = parentObj.registerA - temp_var - (0)
            if(parentObj.FCarry){dirtySum = parentObj.registerA - temp_var - ( 1)} 
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (temp_var & 0xF) - (1) < 0)

            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (temp_var & 0xF) - (0) < 0)

            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //SBC A, A
        //#0x9F:
        { parentObj =>
            //Optimized SBC A:
            if ( (parentObj.FCarry)) {
                parentObj.FZero = false
                parentObj.FSubtract = true
                parentObj.FHalfCarry = true
                parentObj.FCarry = true
                parentObj.registerA = 0xFF
            }
            else {
                parentObj.FHalfCarry = false
                parentObj.FCarry = false
                parentObj.FSubtract = true
                parentObj.FZero = true
                parentObj.registerA = 0
            }
        },
        //AND B
        //#0xA0:
        { parentObj =>
            parentObj.registerA &= parentObj.registerB
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //AND C
        //#0xA1:
        { parentObj =>
            parentObj.registerA &= parentObj.registerC
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //AND D
        //#0xA2:
        { parentObj =>
            parentObj.registerA &= parentObj.registerD
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //AND E
        //#0xA3:
        { parentObj =>
            parentObj.registerA &= parentObj.registerE
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //AND H
        //#0xA4:
        { parentObj =>
            parentObj.registerA &= (parentObj.registersHL >> 8)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //AND L
        //#0xA5:
        { parentObj =>
            parentObj.registerA &= parentObj.registersHL
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //AND (HL)
        //#0xA6:
        { parentObj =>
            parentObj.registerA &= parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //AND A
        //#0xA7:
        { parentObj =>
            //number & same number = same number
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //XOR B
        //#0xA8:
        { parentObj =>
            parentObj.registerA ^= parentObj.registerB
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //XOR C
        //#0xA9:
        { parentObj =>
            parentObj.registerA ^= parentObj.registerC
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //XOR D
        //#0xAA:
        { parentObj =>
            parentObj.registerA ^= parentObj.registerD
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //XOR E
        //#0xAB:
        { parentObj =>
            parentObj.registerA ^= parentObj.registerE
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //XOR H
        //#0xAC:
        { parentObj =>
            parentObj.registerA ^= (parentObj.registersHL >> 8)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //XOR L
        //#0xAD:
        { parentObj =>
            parentObj.registerA ^= (parentObj.registersHL & 0xFF)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //XOR (HL)
        //#0xAE:
        { parentObj =>
            parentObj.registerA ^= parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //XOR A
        //#0xAF:
        { parentObj =>
            //number ^ same number == 0
            parentObj.registerA = 0
            parentObj.FZero = true
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //OR B
        //#0xB0:
        { parentObj =>
            parentObj.registerA |= parentObj.registerB
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //OR C
        //#0xB1:
        { parentObj =>
            parentObj.registerA |= parentObj.registerC
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //OR D
        //#0xB2:
        { parentObj =>
            parentObj.registerA |= parentObj.registerD
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //OR E
        //#0xB3:
        { parentObj =>
            parentObj.registerA |= parentObj.registerE
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //OR H
        //#0xB4:
        { parentObj =>
            parentObj.registerA |= (parentObj.registersHL >> 8)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //OR L
        //#0xB5:
        { parentObj =>
            parentObj.registerA |= (parentObj.registersHL & 0xFF)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //OR (HL)
        //#0xB6:
        { parentObj =>
            parentObj.registerA |= parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //OR A
        //#0xB7:
        { parentObj =>
            //number | same number == same number
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //CP B
        //#0xB8:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerB
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //CP C
        //#0xB9:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerC
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //CP D
        //#0xBA:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerD
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //CP E
        //#0xBB:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.registerE
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //CP H
        //#0xBC:
        { parentObj =>
            let dirtySum = parentObj.registerA - (parentObj.registersHL >> 8)
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //CP L
        //#0xBD:
        { parentObj =>
            let dirtySum = parentObj.registerA - (parentObj.registersHL & 0xFF)
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //CP (HL)
        //#0xBE:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //CP A
        //#0xBF:
        { parentObj =>
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
            parentObj.FZero = true
            parentObj.FSubtract = true
        },
        //RET !FZ
        //#0xC0:
        { parentObj =>
            if ( (!parentObj.FZero)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
                parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
                parentObj.CPUTicks += 12
            }
        },
        //POP BC
        //#0xC1:
        { parentObj =>
            parentObj.registerC = parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
            parentObj.registerB = parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF)
            parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
        },
        //JP !FZ, nn
        //#0xC2:
        { parentObj =>
            if ( (!parentObj.FZero)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //JP nn
        //#0xC3:
        { parentObj =>
            parentObj.programCounter = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
        },
        //CALL !FZ, nn
        //#0xC4:
        { parentObj =>
            if ( (!parentObj.FZero)) {
                let temp_pc = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
                parentObj.programCounter = temp_pc
                parentObj.CPUTicks += 12
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //PUSH BC
        //#0xC5:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.registerB)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.registerC)
        },
        //ADD, n
        //#0xC6:
        { parentObj =>
            let dirtySum = parentObj.registerA + parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            parentObj.FHalfCarry = ((dirtySum & 0xF) < (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //RST 0
        //#0xC7:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0
        },
        //RET FZ
        //#0xC8:
        { parentObj =>
            if ( (parentObj.FZero)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
                parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
                parentObj.CPUTicks += 12
            }
        },
        //RET
        //#0xC9:
        { parentObj =>
            parentObj.programCounter =  (parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
            parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
        },
        //JP FZ, nn
        //#0xCA:
        { parentObj =>
            if ( (parentObj.FZero)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //Secondary OP Code Set:
        //#0xCB:
        { parentObj =>
            let opcode = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            //Increment the program counter to the next instruction:
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            //Get how many CPU cycles the current 0xCBXX op code counts for:
            parentObj.CPUTicks += parentObj.SecondaryTICKTable[opcode]
            //Execute secondary OP codes for the 0xCB OP code call.
            parentObj.CBOPCODE[opcode](parentObj)
        },
        //CALL FZ, nn
        //#0xCC:
        { parentObj =>
            if ( (parentObj.FZero)) {
                let temp_pc = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
                parentObj.programCounter = temp_pc
                parentObj.CPUTicks += 12
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //CALL nn
        //#0xCD:
        { parentObj =>
            let temp_pc = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = temp_pc
        },
        //ADC A, n
        //#0xCE:
        { parentObj =>
            let tempValue = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            var dirtySum = parentObj.registerA + tempValue + 0
            if(parentObj.FCarry){
                dirtySum = parentObj.registerA + tempValue + 1
            }
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) + (1) > 0xF)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) + (tempValue & 0xF) + (0) > 0xF)
            }
            parentObj.FCarry = (dirtySum > 0xFF)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
        },
        //RST 0x8
        //#0xCF:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0x8
        },
        //RET !FC
        //#0xD0:
        { parentObj =>
            if ( (!parentObj.FCarry)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
                parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
                parentObj.CPUTicks += 12
            }
        },
        //POP DE
        //#0xD1:
        { parentObj =>
            parentObj.registerE = parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
            parentObj.registerD = parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF)
            parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
        },
        //JP !FC, nn
        //#0xD2:
        { parentObj =>
            if ( (!parentObj.FCarry)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //0xD3 - Illegal
        //#0xD3:
        { parentObj =>
            cout("Illegal op code 0xD3 called, pausing emulation.", 2)
            pausePlay()
        },
        //CALL !FC, nn
        //#0xD4:
        { parentObj =>
            if ( (!parentObj.FCarry)) {
                let temp_pc = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
                parentObj.programCounter = temp_pc
                parentObj.CPUTicks += 12
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //PUSH DE
        //#0xD5:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.registerD)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.registerE)
        },
        //SUB A, n
        //#0xD6:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            parentObj.FHalfCarry = ((parentObj.registerA & 0xF) < (dirtySum & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //RST 0x10
        //#0xD7:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0x10
        },
        //RET FC
        //#0xD8:
        { parentObj =>
            if ( (parentObj.FCarry)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
                parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
                parentObj.CPUTicks += 12
            }
        },
        //RETI
        //#0xD9:
        { parentObj =>
            parentObj.programCounter = (parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
            parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
            //Immediate for HALT:
            if(parentObj.IRQEnableDelay == 2 || parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter) == 0x76){
                parentObj.IRQEnableDelay = 1
            }else{
                parentObj.IRQEnableDelay = 2
            }
        },
        //JP FC, nn
        //#0xDA:
        { parentObj =>
            if ( (parentObj.FCarry)) {
                parentObj.programCounter = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.CPUTicks += 4
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //0xDB - Illegal
        //#0xDB:
        { parentObj =>
            cout("Illegal op code 0xDB called, pausing emulation.", 2)
            pausePlay()
        },
        //CALL FC, nn
        //#0xDC:
        { parentObj =>
            if ( (parentObj.FCarry)) {
                let temp_pc = (parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
                parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
                parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
                parentObj.programCounter = temp_pc
                parentObj.CPUTicks += 12
            }
            else {
                parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
            }
        },
        //0xDD - Illegal
        //#0xDD:
        { parentObj =>
            cout("Illegal op code 0xDD called, pausing emulation.", 2)
            pausePlay()
        },
        //SBC A, n
        //#0xDE:
        { parentObj =>
            let temp_var = parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            var dirtySum = parentObj.registerA - temp_var - 0
            if(parentObj.FCarry){
                dirtySum = parentObj.registerA - temp_var - 1
            }
            if(parentObj.FCarry){
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (temp_var & 0xF) - (1) < 0)
            }else{
                parentObj.FHalfCarry = ((parentObj.registerA & 0xF) - (temp_var & 0xF) - (0) < 0)

            }
            parentObj.FCarry = (dirtySum < 0)
            parentObj.registerA = dirtySum & 0xFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = true
        },
        //RST 0x18
        //#0xDF:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0x18
        },
        //LDH (n), A
        //#0xE0:
        { parentObj =>
            parentObj.memoryHighWrite(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter), parentObj.registerA)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //POP HL
        //#0xE1:
        { parentObj =>
            parentObj.registersHL = (parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
            parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
        },
        //LD (0xFF00 + C), A
        //#0xE2:
        { parentObj =>
            parentObj.memoryHighWriter[parentObj.registerC](parentObj, parentObj.registerC, parentObj.registerA)
        },
        //0xE3 - Illegal
        //#0xE3:
        { parentObj =>
            cout("Illegal op code 0xE3 called, pausing emulation.", 2)
            pausePlay()
        },
        //0xE4 - Illegal
        //#0xE4:
        { parentObj =>
            cout("Illegal op code 0xE4 called, pausing emulation.", 2)
            pausePlay()
        },
        //PUSH HL
        //#0xE5:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.registersHL >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.registersHL & 0xFF)
        },
        //AND n
        //#0xE6:
        { parentObj =>
            parentObj.registerA &= parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FCarry = false
        },
        //RST 0x20
        //#0xE7:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0x20
        },
        //ADD SP, n
        //#0xE8:
        { parentObj =>
            var temp_value2 = Int64(Int32(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)) << 24) >> 24
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            let temp_value = (parentObj.stackPointer + temp_value2) & 0xFFFF
            temp_value2 = parentObj.stackPointer ^ temp_value2 ^ temp_value
            parentObj.stackPointer = temp_value
            parentObj.FCarry = ((temp_value2 & 0x100) == 0x100)
            parentObj.FHalfCarry = ((temp_value2 & 0x10) == 0x10)
            parentObj.FZero = false
            parentObj.FSubtract = false
        },
        //JP, (HL)
        //#0xE9:
        { parentObj =>
            parentObj.programCounter = parentObj.registersHL
        },
        //LD n, A
        //#0xEA:
        { parentObj =>
            parentObj.memoryWrite((parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter), parentObj.registerA)
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
        },
        //0xEB - Illegal
        //#0xEB:
        { parentObj =>
            cout("Illegal op code 0xEB called, pausing emulation.", 2)
            pausePlay()
        },
        //0xEC - Illegal
        //#0xEC:
        { parentObj =>
            cout("Illegal op code 0xEC called, pausing emulation.", 2)
            pausePlay()
        },
        //0xED - Illegal
        //#0xED:
        { parentObj =>
            cout("Illegal op code 0xED called, pausing emulation.", 2)
            pausePlay()
        },
        //XOR n
        //#0xEE:
        { parentObj =>
            parentObj.registerA ^= parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FSubtract = false
            parentObj.FHalfCarry = false
            parentObj.FCarry = false
        },
        //RST 0x28
        //#0xEF:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0x28
        },
        //LDH A, (n)
        //#0xF0:
        { parentObj =>
            parentObj.registerA = parentObj.memoryHighRead(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter))
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
        },
        //POP AF
        //#0xF1:
        { parentObj =>
            let temp_var = parentObj.memoryReader[parentObj.stackPointer](parentObj, parentObj.stackPointer)
            parentObj.FZero = (temp_var > 0x7F)
            parentObj.FSubtract = ((temp_var & 0x40) == 0x40)
            parentObj.FHalfCarry = ((temp_var & 0x20) == 0x20)
            parentObj.FCarry = ((temp_var & 0x10) == 0x10)
            parentObj.registerA = parentObj.memoryRead((parentObj.stackPointer + 1) & 0xFFFF)
            parentObj.stackPointer = (parentObj.stackPointer + 2) & 0xFFFF
        },
        //LD A, (0xFF00 + C)
        //#0xF2:
        { parentObj =>
            parentObj.registerA = parentObj.memoryHighReader[parentObj.registerC](parentObj, parentObj.registerC)
        },
        //DI
        //#0xF3:
        { parentObj =>
            parentObj.IME = false
            parentObj.IRQEnableDelay = 0
        },
        //0xF4 - Illegal
        //#0xF4:
        { parentObj =>
            cout("Illegal op code 0xF4 called, pausing emulation.", 2)
            pausePlay()
        },
        //PUSH AF
        //#0xF5:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.registerA)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            var temp1 = 0
            if(parentObj.FZero){temp1 = 0x80}
            var temp2 = 0
            if(parentObj.FSubtract){temp2 =0x40}
            var temp3 = 0
            if(parentObj.FHalfCarry){temp3 =0x20}
            var temp4 = 0
            if(parentObj.FCarry){temp4 =0x10}
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, temp1 | temp2 | temp3 | temp4)
        },
        //OR n
        //#0xF6:
        { parentObj =>
            parentObj.registerA |= parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            parentObj.FSubtract = false
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
        },
        //RST 0x30
        //#0xF7:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0x30
        },
        //LDHL SP, n
        //#0xF8:
        { parentObj =>
            var temp_var = Int64(Int32(parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)) << 24) >> 24
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            parentObj.registersHL = (parentObj.stackPointer + temp_var) & 0xFFFF
            temp_var = parentObj.stackPointer ^ temp_var ^ parentObj.registersHL
            parentObj.FCarry = ((temp_var & 0x100) == 0x100)
            parentObj.FHalfCarry = ((temp_var & 0x10) == 0x10)
            parentObj.FZero = false
            parentObj.FSubtract = false
        },
        //LD SP, HL
        //#0xF9:
        { parentObj =>
            parentObj.stackPointer = parentObj.registersHL
        },
        //LD A, (nn)
        //#0xFA:
        { parentObj =>
            parentObj.registerA = parentObj.memoryRead((parentObj.memoryRead((parentObj.programCounter + 1) & 0xFFFF) << 8) | parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter))
            parentObj.programCounter = (parentObj.programCounter + 2) & 0xFFFF
        },
        //EI
        //#0xFB:
        { parentObj =>
            //Immediate for HALT:
            if(parentObj.IRQEnableDelay == 2 || parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter) == 0x76){
                parentObj.IRQEnableDelay =1
            }else{
                parentObj.IRQEnableDelay = 2
            }
        },
        //0xFC - Illegal
        //#0xFC:
        { parentObj =>
            cout("Illegal op code 0xFC called, pausing emulation.", 2)
            pausePlay()
        },
        //0xFD - Illegal
        //#0xFD:
        { parentObj =>
            cout("Illegal op code 0xFD called, pausing emulation.", 2)
            pausePlay()
        },
        //CP n
        //#0xFE:
        { parentObj =>
            let dirtySum = parentObj.registerA - parentObj.memoryReader[parentObj.programCounter](parentObj, parentObj.programCounter)
            parentObj.programCounter = (parentObj.programCounter + 1) & 0xFFFF
            parentObj.FHalfCarry = ((dirtySum & 0xF) > (parentObj.registerA & 0xF))
            parentObj.FCarry = (dirtySum < 0)
            parentObj.FZero = (dirtySum == 0)
            parentObj.FSubtract = true
        },
        //RST 0x38
        //#0xFF:
        { parentObj =>
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter >> 8)
            parentObj.stackPointer = (parentObj.stackPointer - 1) & 0xFFFF
            parentObj.memoryWriter[parentObj.stackPointer](parentObj, parentObj.stackPointer, parentObj.programCounter & 0xFF)
            parentObj.programCounter = 0x38
        }
    ]
    var CBOPCODE: Array<(GameBoyCore)->Unit> = [
        //RLC B
        //#0x00:
        { parentObj =>
            parentObj.FCarry = (parentObj.registerB > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerB = ((parentObj.registerB << 1) & 0xFF) | ( 1)
            }else{
                parentObj.registerB = ((parentObj.registerB << 1) & 0xFF) | ( 0)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerB == 0)
        }
        //RLC C
        //#0x01:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerC > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerC = ((parentObj.registerC << 1) & 0xFF) | ( 1)
            }else{
                parentObj.registerC = ((parentObj.registerC << 1) & 0xFF) | ( 0)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerC == 0)
        }
        //RLC D
        //#0x02:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerD > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerD = ((parentObj.registerD << 1) & 0xFF) | ( 1)
            }else{
                parentObj.registerD = ((parentObj.registerD << 1) & 0xFF) | ( 0)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerD == 0)
        }
        //RLC E
        //#0x03:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerE > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerE = ((parentObj.registerE << 1) & 0xFF) | ( 1)
            }else{
                parentObj.registerE = ((parentObj.registerE << 1) & 0xFF) | ( 0)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerE == 0)
        }
        //RLC H
        //#0x04:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registersHL > 0x7FFF)
            if(parentObj.FCarry){
                parentObj.registersHL = ((parentObj.registersHL << 1) & 0xFE00) | (0x100 ) | (parentObj.registersHL & 0xFF)
            }else{
                parentObj.registersHL = ((parentObj.registersHL << 1) & 0xFE00) | (0) | (parentObj.registersHL & 0xFF)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registersHL < 0x100)
        }
        //RLC L
        //#0x05:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x80) == 0x80)
            if(parentObj.FCarry){
                parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ((parentObj.registersHL << 1) & 0xFF) | (1)
            }else{
                parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ((parentObj.registersHL << 1) & 0xFF) | (0)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
        }
        //RLC (HL)
        //#0x06:
        ,{ parentObj =>
            var temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FCarry = (temp_var > 0x7F)
            if(parentObj.FCarry){
                temp_var = ((temp_var << 1) & 0xFF) | (1)
            }else{
                temp_var = ((temp_var << 1) & 0xFF) | ( 0)
            }
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (temp_var == 0)
        }
        //RLC A
        //#0x07:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerA > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerA = ((parentObj.registerA << 1) & 0xFF) | (1)
            }else{
                parentObj.registerA = ((parentObj.registerA << 1) & 0xFF) | ( 0)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerA == 0)
        }
        //RRC B
        //#0x08:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerB & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerB = (0x80 ) | (parentObj.registerB >> 1)
            }else{
                parentObj.registerB = ( 0) | (parentObj.registerB >> 1)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerB == 0)
        }
        //RRC C
        //#0x09:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerC & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerC = (0x80 ) | (parentObj.registerC >> 1)
            }else{
                parentObj.registerC = ( 0) | (parentObj.registerC >> 1)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerC == 0)
        }
        //RRC D
        //#0x0A:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerD & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerD = (0x80 ) | (parentObj.registerD >> 1)
            }else{
                parentObj.registerD = ( 0) | (parentObj.registerD >> 1)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerD == 0)
        }
        //RRC E
        //#0x0B:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerE & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerE = (0x80 ) | (parentObj.registerE >> 1)
            }else{
                parentObj.registerE = ( 0) | (parentObj.registerE >> 1)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerE == 0)
        }
        //RRC H
        //#0x0C:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x0100) == 0x0100)
            if(parentObj.FCarry){
                parentObj.registersHL = (0x8000 ) | ((parentObj.registersHL >> 1) & 0xFF00) | (parentObj.registersHL & 0xFF)
            }else{
                parentObj.registersHL = ( 0) | ((parentObj.registersHL >> 1) & 0xFF00) | (parentObj.registersHL & 0xFF)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registersHL < 0x100)
        }
        //RRC L
        //#0x0D:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registersHL =(parentObj.registersHL & 0xFF00) | ( 0x80 ) | ((parentObj.registersHL & 0xFF) >> 1)
            }else{
                parentObj.registersHL =(parentObj.registersHL & 0xFF00) | (0) | ((parentObj.registersHL & 0xFF) >> 1)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
        }
        //RRC (HL)
        //#0x0E:
        ,{ parentObj =>
            var temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FCarry = ((temp_var & 0x01) == 0x01)
            if(parentObj.FCarry){
                temp_var = ( 0x80 ) | (temp_var >> 1)
            }else{
                temp_var = ( 0) | (temp_var >> 1)
            }
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (temp_var == 0)
        }
        //RRC A
        //#0x0F:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerA & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerA = ( 0x80 ) | (parentObj.registerA >> 1)
            }else{
                parentObj.registerA = ( 0) | (parentObj.registerA >> 1)
            }
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerA == 0)
        }
        //RL B
        //#0x10:
        ,{ parentObj =>
            let newFCarry = (parentObj.registerB > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerB = ((parentObj.registerB << 1) & 0xFF) | (1)
            }else{
                parentObj.registerB = ((parentObj.registerB << 1) & 0xFF) | ( 0)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerB == 0)
        }
        //RL C
        //#0x11:
        ,{ parentObj =>
            let newFCarry = (parentObj.registerC > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerC = ((parentObj.registerC << 1) & 0xFF) | (1)
            }else{
                parentObj.registerC = ((parentObj.registerC << 1) & 0xFF) | ( 0)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerC == 0)
        }
        //RL D
        //#0x12:
        ,{ parentObj =>
            let newFCarry = (parentObj.registerD > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerD = ((parentObj.registerD << 1) & 0xFF) | (1)
            }else{
                parentObj.registerD = ((parentObj.registerD << 1) & 0xFF) | ( 0)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerD == 0)
        }
        //RL E
        //#0x13:
        ,{ parentObj =>
            let newFCarry = (parentObj.registerE > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerE = ((parentObj.registerE << 1) & 0xFF) | (1)
            }else{
                parentObj.registerE = ((parentObj.registerE << 1) & 0xFF) | ( 0)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerE == 0)
        }
        //RL H
        //#0x14:
        ,{ parentObj =>
            let newFCarry = (parentObj.registersHL > 0x7FFF)
            if(parentObj.FCarry){
                parentObj.registersHL = ((parentObj.registersHL << 1) & 0xFE00) | ( 0x100 ) | (parentObj.registersHL & 0xFF)
            }else{
                parentObj.registersHL = ((parentObj.registersHL << 1) & 0xFE00) | (0) | (parentObj.registersHL & 0xFF)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registersHL < 0x100)
        }
        //RL L
        //#0x15:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registersHL & 0x80) == 0x80)
            if(parentObj.FCarry){
                parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ((parentObj.registersHL << 1) & 0xFF) | (1)
            }else{
                parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ((parentObj.registersHL << 1) & 0xFF) | (0)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
        }
        //RL (HL)
        //#0x16:
        ,{ parentObj =>
            var temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            let newFCarry = (temp_var > 0x7F)
            if(parentObj.FCarry){
                temp_var = ((temp_var << 1) & 0xFF) | (1)
            }else{
                temp_var = ((temp_var << 1) & 0xFF) | (0)
            }
            parentObj.FCarry = newFCarry
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (temp_var == 0)
        }
        //RL A
        //#0x17:
        ,{ parentObj =>
            let newFCarry = (parentObj.registerA > 0x7F)
            if(parentObj.FCarry){
                parentObj.registerA = ((parentObj.registerA << 1) & 0xFF) | (1)
            }else{
                parentObj.registerA = ((parentObj.registerA << 1) & 0xFF) | ( 0)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerA == 0)
        }
        //RR B
        //#0x18:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registerB & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerB = (0x80 ) | (parentObj.registerB >> 1)
            }else{
                parentObj.registerB = (0) | (parentObj.registerB >> 1)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerB == 0)
        }
        //RR C
        //#0x19:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registerC & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerC = (0x80 ) | (parentObj.registerC >> 1)
            }else{
                parentObj.registerC = (0) | (parentObj.registerC >> 1)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerC == 0)
        }
        //RR D
        //#0x1A:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registerD & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerD = (0x80 ) | (parentObj.registerD >> 1)
            }else{
                parentObj.registerD = (0) | (parentObj.registerD >> 1)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerD == 0)
        }
        //RR E
        //#0x1B:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registerE & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerE = (0x80 ) | (parentObj.registerE >> 1)
            }else{
                parentObj.registerE = (0) | (parentObj.registerE >> 1)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerE == 0)
        }
        //RR H
        //#0x1C:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registersHL & 0x0100) == 0x0100)
            if(parentObj.FCarry){
                parentObj.registersHL = (0x8000 ) | ((parentObj.registersHL >> 1) & 0xFF00) | (parentObj.registersHL & 0xFF)
            }else{
                parentObj.registersHL = ( 0) | ((parentObj.registersHL >> 1) & 0xFF00) | (parentObj.registersHL & 0xFF)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registersHL < 0x100)
        }
        //RR L
        //#0x1D:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registersHL & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ( 0x80 ) | ((parentObj.registersHL & 0xFF) >> 1)
            }else{
                parentObj.registersHL = (parentObj.registersHL & 0xFF00) | (  0) | ((parentObj.registersHL & 0xFF) >> 1)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
        }
        //RR (HL)
        //#0x1E:
        ,{ parentObj =>
            var temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            let newFCarry = ((temp_var & 0x01) == 0x01)
            if(parentObj.FCarry){
                temp_var = (0x80) | (temp_var >> 1)
            }else{
                temp_var = (0) | (temp_var >> 1)
            }
            parentObj.FCarry = newFCarry
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (temp_var == 0)
        }
        //RR A
        //#0x1F:
        ,{ parentObj =>
            let newFCarry = ((parentObj.registerA & 0x01) == 0x01)
            if(parentObj.FCarry){
                parentObj.registerA = ( 0x80 ) | (parentObj.registerA >> 1)
            }else{
                parentObj.registerA = ( 0) | (parentObj.registerA >> 1)
            }
            parentObj.FCarry = newFCarry
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerA == 0)
        }
        //SLA B
        //#0x20:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerB > 0x7F)
            parentObj.registerB = (parentObj.registerB << 1) & 0xFF
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerB == 0)
        }
        //SLA C
        //#0x21:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerC > 0x7F)
            parentObj.registerC = (parentObj.registerC << 1) & 0xFF
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerC == 0)
        }
        //SLA D
        //#0x22:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerD > 0x7F)
            parentObj.registerD = (parentObj.registerD << 1) & 0xFF
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerD == 0)
        }
        //SLA E
        //#0x23:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerE > 0x7F)
            parentObj.registerE = (parentObj.registerE << 1) & 0xFF
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerE == 0)
        }
        //SLA H
        //#0x24:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registersHL > 0x7FFF)
            parentObj.registersHL = ((parentObj.registersHL << 1) & 0xFE00) | (parentObj.registersHL & 0xFF)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registersHL < 0x100)
        }
        //SLA L
        //#0x25:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x0080) == 0x0080)
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ((parentObj.registersHL << 1) & 0xFF)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
        }
        //SLA (HL)
        //#0x26:
        ,{ parentObj =>
            var temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FCarry = (temp_var > 0x7F)
            temp_var = (temp_var << 1) & 0xFF
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (temp_var == 0)
        }
        //SLA A
        //#0x27:
        ,{ parentObj =>
            parentObj.FCarry = (parentObj.registerA > 0x7F)
            parentObj.registerA = (parentObj.registerA << 1) & 0xFF
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerA == 0)
        }
        //SRA B
        //#0x28:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerB & 0x01) == 0x01)
            parentObj.registerB = (parentObj.registerB & 0x80) | (parentObj.registerB >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerB == 0)
        }
        //SRA C
        //#0x29:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerC & 0x01) == 0x01)
            parentObj.registerC = (parentObj.registerC & 0x80) | (parentObj.registerC >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerC == 0)
        }
        //SRA D
        //#0x2A:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerD & 0x01) == 0x01)
            parentObj.registerD = (parentObj.registerD & 0x80) | (parentObj.registerD >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerD == 0)
        }
        //SRA E
        //#0x2B:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerE & 0x01) == 0x01)
            parentObj.registerE = (parentObj.registerE & 0x80) | (parentObj.registerE >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerE == 0)
        }
        //SRA H
        //#0x2C:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x0100) == 0x0100)
            parentObj.registersHL = ((parentObj.registersHL >> 1) & 0xFF00) | (parentObj.registersHL & 0x80FF)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registersHL < 0x100)
        }
        //SRA L
        //#0x2D:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x0001) == 0x0001)
            parentObj.registersHL = (parentObj.registersHL & 0xFF80) | ((parentObj.registersHL & 0xFF) >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
        }
        //SRA (HL)
        //#0x2E:
        ,{ parentObj =>
            var temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FCarry = ((temp_var & 0x01) == 0x01)
            temp_var = (temp_var & 0x80) | (temp_var >> 1)
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (temp_var == 0)
        }
        //SRA A
        //#0x2F:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerA & 0x01) == 0x01)
            parentObj.registerA = (parentObj.registerA & 0x80) | (parentObj.registerA >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerA == 0)
        }
        //SWAP B
        //#0x30:
        ,{ parentObj =>
            parentObj.registerB = ((parentObj.registerB & 0xF) << 4) | (parentObj.registerB >> 4)
            parentObj.FZero = (parentObj.registerB == 0)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SWAP C
        //#0x31:
        ,{ parentObj =>
            parentObj.registerC = ((parentObj.registerC & 0xF) << 4) | (parentObj.registerC >> 4)
            parentObj.FZero = (parentObj.registerC == 0)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SWAP D
        //#0x32:
        ,{ parentObj =>
            parentObj.registerD = ((parentObj.registerD & 0xF) << 4) | (parentObj.registerD >> 4)
            parentObj.FZero = (parentObj.registerD == 0)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SWAP E
        //#0x33:
        ,{ parentObj =>
            parentObj.registerE = ((parentObj.registerE & 0xF) << 4) | (parentObj.registerE >> 4)
            parentObj.FZero = (parentObj.registerE == 0)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SWAP H
        //#0x34:
        ,{ parentObj =>
            parentObj.registersHL = ((parentObj.registersHL & 0xF00) << 4) | ((parentObj.registersHL & 0xF000) >> 4) | (parentObj.registersHL & 0xFF)
            parentObj.FZero = (parentObj.registersHL < 0x100)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SWAP L
        //#0x35:
        ,{ parentObj =>
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ((parentObj.registersHL & 0xF) << 4) | ((parentObj.registersHL & 0xF0) >> 4)
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SWAP (HL)
        //#0x36:
        ,{ parentObj =>
            var temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            temp_var = ((temp_var & 0xF) << 4) | (temp_var >> 4)
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var)
            parentObj.FZero = (temp_var == 0)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SWAP A
        //#0x37:
        ,{ parentObj =>
            parentObj.registerA = ((parentObj.registerA & 0xF) << 4) | (parentObj.registerA >> 4)
            parentObj.FZero = (parentObj.registerA == 0)
            parentObj.FCarry = false
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
        }
        //SRL B
        //#0x38:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerB & 0x01) == 0x01)
            parentObj.registerB >>= 1
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerB == 0)
        }
        //SRL C
        //#0x39:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerC & 0x01) == 0x01)
            parentObj.registerC >>= 1
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerC == 0)
        }
        //SRL D
        //#0x3A:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerD & 0x01) == 0x01)
            parentObj.registerD >>= 1
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerD == 0)
        }
        //SRL E
        //#0x3B:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerE & 0x01) == 0x01)
            parentObj.registerE >>= 1
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerE == 0)
        }
        //SRL H
        //#0x3C:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x0100) == 0x0100)
            parentObj.registersHL = ((parentObj.registersHL >> 1) & 0xFF00) | (parentObj.registersHL & 0xFF)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registersHL < 0x100)
        }
        //SRL L
        //#0x3D:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registersHL & 0x0001) == 0x0001)
            parentObj.registersHL = (parentObj.registersHL & 0xFF00) | ((parentObj.registersHL & 0xFF) >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0xFF) == 0)
        }
        //SRL (HL)
        //#0x3E:
        ,{ parentObj =>
            let temp_var = parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL)
            parentObj.FCarry = ((temp_var & 0x01) == 0x01)
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, temp_var >> 1)
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (temp_var < 2)
        }
        //SRL A
        //#0x3F:
        ,{ parentObj =>
            parentObj.FCarry = ((parentObj.registerA & 0x01) == 0x01)
            parentObj.registerA >>= 1
            parentObj.FHalfCarry = false
            parentObj.FSubtract = false
            parentObj.FZero = (parentObj.registerA == 0)
        }
        //BIT 0, B
        //#0x40:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x01) == 0)
        }
        //BIT 0, C
        //#0x41:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x01) == 0)
        }
        //BIT 0, D
        //#0x42:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x01) == 0)
        }
        //BIT 0, E
        //#0x43:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x01) == 0)
        }
        //BIT 0, H
        //#0x44:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0100) == 0)
        }
        //BIT 0, L
        //#0x45:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0001) == 0)
        }
        //BIT 0, (HL)
        //#0x46:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x01) == 0)
        }
        //BIT 0, A
        //#0x47:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x01) == 0)
        }
        //BIT 1, B
        //#0x48:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x02) == 0)
        }
        //BIT 1, C
        //#0x49:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x02) == 0)
        }
        //BIT 1, D
        //#0x4A:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x02) == 0)
        }
        //BIT 1, E
        //#0x4B:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x02) == 0)
        }
        //BIT 1, H
        //#0x4C:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0200) == 0)
        }
        //BIT 1, L
        //#0x4D:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0002) == 0)
        }
        //BIT 1, (HL)
        //#0x4E:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x02) == 0)
        }
        //BIT 1, A
        //#0x4F:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x02) == 0)
        }
        //BIT 2, B
        //#0x50:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x04) == 0)
        }
        //BIT 2, C
        //#0x51:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x04) == 0)
        }
        //BIT 2, D
        //#0x52:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x04) == 0)
        }
        //BIT 2, E
        //#0x53:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x04) == 0)
        }
        //BIT 2, H
        //#0x54:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0400) == 0)
        }
        //BIT 2, L
        //#0x55:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0004) == 0)
        }
        //BIT 2, (HL)
        //#0x56:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x04) == 0)
        }
        //BIT 2, A
        //#0x57:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x04) == 0)
        }
        //BIT 3, B
        //#0x58:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x08) == 0)
        }
        //BIT 3, C
        //#0x59:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x08) == 0)
        }
        //BIT 3, D
        //#0x5A:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x08) == 0)
        }
        //BIT 3, E
        //#0x5B:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x08) == 0)
        }
        //BIT 3, H
        //#0x5C:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0800) == 0)
        }
        //BIT 3, L
        //#0x5D:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0008) == 0)
        }
        //BIT 3, (HL)
        //#0x5E:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x08) == 0)
        }
        //BIT 3, A
        //#0x5F:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x08) == 0)
        }
        //BIT 4, B
        //#0x60:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x10) == 0)
        }
        //BIT 4, C
        //#0x61:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x10) == 0)
        }
        //BIT 4, D
        //#0x62:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x10) == 0)
        }
        //BIT 4, E
        //#0x63:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x10) == 0)
        }
        //BIT 4, H
        //#0x64:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x1000) == 0)
        }
        //BIT 4, L
        //#0x65:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0010) == 0)
        }
        //BIT 4, (HL)
        //#0x66:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x10) == 0)
        }
        //BIT 4, A
        //#0x67:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x10) == 0)
        }
        //BIT 5, B
        //#0x68:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x20) == 0)
        }
        //BIT 5, C
        //#0x69:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x20) == 0)
        }
        //BIT 5, D
        //#0x6A:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x20) == 0)
        }
        //BIT 5, E
        //#0x6B:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x20) == 0)
        }
        //BIT 5, H
        //#0x6C:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x2000) == 0)
        }
        //BIT 5, L
        //#0x6D:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0020) == 0)
        }
        //BIT 5, (HL)
        //#0x6E:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x20) == 0)
        }
        //BIT 5, A
        //#0x6F:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x20) == 0)
        }
        //BIT 6, B
        //#0x70:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x40) == 0)
        }
        //BIT 6, C
        //#0x71:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x40) == 0)
        }
        //BIT 6, D
        //#0x72:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x40) == 0)
        }
        //BIT 6, E
        //#0x73:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x40) == 0)
        }
        //BIT 6, H
        //#0x74:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x4000) == 0)
        }
        //BIT 6, L
        //#0x75:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0040) == 0)
        }
        //BIT 6, (HL)
        //#0x76:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x40) == 0)
        }
        //BIT 6, A
        //#0x77:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x40) == 0)
        }
        //BIT 7, B
        //#0x78:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerB & 0x80) == 0)
        }
        //BIT 7, C
        //#0x79:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerC & 0x80) == 0)
        }
        //BIT 7, D
        //#0x7A:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerD & 0x80) == 0)
        }
        //BIT 7, E
        //#0x7B:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerE & 0x80) == 0)
        }
        //BIT 7, H
        //#0x7C:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x8000) == 0)
        }
        //BIT 7, L
        //#0x7D:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registersHL & 0x0080) == 0)
        }
        //BIT 7, (HL)
        //#0x7E:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x80) == 0)
        }
        //BIT 7, A
        //#0x7F:
        ,{ parentObj =>
            parentObj.FHalfCarry = true
            parentObj.FSubtract = false
            parentObj.FZero = ((parentObj.registerA & 0x80) == 0)
        }
        //RES 0, B
        //#0x80:
        ,{ parentObj =>
            parentObj.registerB &= 0xFE
        }
        //RES 0, C
        //#0x81:
        ,{ parentObj =>
            parentObj.registerC &= 0xFE
        }
        //RES 0, D
        //#0x82:
        ,{ parentObj =>
            parentObj.registerD &= 0xFE
        }
        //RES 0, E
        //#0x83:
        ,{ parentObj =>
            parentObj.registerE &= 0xFE
        }
        //RES 0, H
        //#0x84:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFEFF
        }
        //RES 0, L
        //#0x85:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFFFE
        }
        //RES 0, (HL)
        //#0x86:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0xFE)
        }
        //RES 0, A
        //#0x87:
        ,{ parentObj =>
            parentObj.registerA &= 0xFE
        }
        //RES 1, B
        //#0x88:
        ,{ parentObj =>
            parentObj.registerB &= 0xFD
        }
        //RES 1, C
        //#0x89:
        ,{ parentObj =>
            parentObj.registerC &= 0xFD
        }
        //RES 1, D
        //#0x8A:
        ,{ parentObj =>
            parentObj.registerD &= 0xFD
        }
        //RES 1, E
        //#0x8B:
        ,{ parentObj =>
            parentObj.registerE &= 0xFD
        }
        //RES 1, H
        //#0x8C:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFDFF
        }
        //RES 1, L
        //#0x8D:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFFFD
        }
        //RES 1, (HL)
        //#0x8E:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0xFD)
        }
        //RES 1, A
        //#0x8F:
        ,{ parentObj =>
            parentObj.registerA &= 0xFD
        }
        //RES 2, B
        //#0x90:
        ,{ parentObj =>
            parentObj.registerB &= 0xFB
        }
        //RES 2, C
        //#0x91:
        ,{ parentObj =>
            parentObj.registerC &= 0xFB
        }
        //RES 2, D
        //#0x92:
        ,{ parentObj =>
            parentObj.registerD &= 0xFB
        }
        //RES 2, E
        //#0x93:
        ,{ parentObj =>
            parentObj.registerE &= 0xFB
        }
        //RES 2, H
        //#0x94:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFBFF
        }
        //RES 2, L
        //#0x95:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFFFB
        }
        //RES 2, (HL)
        //#0x96:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0xFB)
        }
        //RES 2, A
        //#0x97:
        ,{ parentObj =>
            parentObj.registerA &= 0xFB
        }
        //RES 3, B
        //#0x98:
        ,{ parentObj =>
            parentObj.registerB &= 0xF7
        }
        //RES 3, C
        //#0x99:
        ,{ parentObj =>
            parentObj.registerC &= 0xF7
        }
        //RES 3, D
        //#0x9A:
        ,{ parentObj =>
            parentObj.registerD &= 0xF7
        }
        //RES 3, E
        //#0x9B:
        ,{ parentObj =>
            parentObj.registerE &= 0xF7
        }
        //RES 3, H
        //#0x9C:
        ,{ parentObj =>
            parentObj.registersHL &= 0xF7FF
        }
        //RES 3, L
        //#0x9D:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFFF7
        }
        //RES 3, (HL)
        //#0x9E:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0xF7)
        }
        //RES 3, A
        //#0x9F:
        ,{ parentObj =>
            parentObj.registerA &= 0xF7
        }
        //RES 3, B
        //#0xA0:
        ,{ parentObj =>
            parentObj.registerB &= 0xEF
        }
        //RES 4, C
        //#0xA1:
        ,{ parentObj =>
            parentObj.registerC &= 0xEF
        }
        //RES 4, D
        //#0xA2:
        ,{ parentObj =>
            parentObj.registerD &= 0xEF
        }
        //RES 4, E
        //#0xA3:
        ,{ parentObj =>
            parentObj.registerE &= 0xEF
        }
        //RES 4, H
        //#0xA4:
        ,{ parentObj =>
            parentObj.registersHL &= 0xEFFF
        }
        //RES 4, L
        //#0xA5:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFFEF
        }
        //RES 4, (HL)
        //#0xA6:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0xEF)
        }
        //RES 4, A
        //#0xA7:
        ,{ parentObj =>
            parentObj.registerA &= 0xEF
        }
        //RES 5, B
        //#0xA8:
        ,{ parentObj =>
            parentObj.registerB &= 0xDF
        }
        //RES 5, C
        //#0xA9:
        ,{ parentObj =>
            parentObj.registerC &= 0xDF
        }
        //RES 5, D
        //#0xAA:
        ,{ parentObj =>
            parentObj.registerD &= 0xDF
        }
        //RES 5, E
        //#0xAB:
        ,{ parentObj =>
            parentObj.registerE &= 0xDF
        }
        //RES 5, H
        //#0xAC:
        ,{ parentObj =>
            parentObj.registersHL &= 0xDFFF
        }
        //RES 5, L
        //#0xAD:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFFDF
        }
        //RES 5, (HL)
        //#0xAE:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0xDF)
        }
        //RES 5, A
        //#0xAF:
        ,{ parentObj =>
            parentObj.registerA &= 0xDF
        }
        //RES 6, B
        //#0xB0:
        ,{ parentObj =>
            parentObj.registerB &= 0xBF
        }
        //RES 6, C
        //#0xB1:
        ,{ parentObj =>
            parentObj.registerC &= 0xBF
        }
        //RES 6, D
        //#0xB2:
        ,{ parentObj =>
            parentObj.registerD &= 0xBF
        }
        //RES 6, E
        //#0xB3:
        ,{ parentObj =>
            parentObj.registerE &= 0xBF
        }
        //RES 6, H
        //#0xB4:
        ,{ parentObj =>
            parentObj.registersHL &= 0xBFFF
        }
        //RES 6, L
        //#0xB5:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFFBF
        }
        //RES 6, (HL)
        //#0xB6:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0xBF)
        }
        //RES 6, A
        //#0xB7:
        ,{ parentObj =>
            parentObj.registerA &= 0xBF
        }
        //RES 7, B
        //#0xB8:
        ,{ parentObj =>
            parentObj.registerB &= 0x7F
        }
        //RES 7, C
        //#0xB9:
        ,{ parentObj =>
            parentObj.registerC &= 0x7F
        }
        //RES 7, D
        //#0xBA:
        ,{ parentObj =>
            parentObj.registerD &= 0x7F
        }
        //RES 7, E
        //#0xBB:
        ,{ parentObj =>
            parentObj.registerE &= 0x7F
        }
        //RES 7, H
        //#0xBC:
        ,{ parentObj =>
            parentObj.registersHL &= 0x7FFF
        }
        //RES 7, L
        //#0xBD:
        ,{ parentObj =>
            parentObj.registersHL &= 0xFF7F
        }
        //RES 7, (HL)
        //#0xBE:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) & 0x7F)
        }
        //RES 7, A
        //#0xBF:
        ,{ parentObj =>
            parentObj.registerA &= 0x7F
        }
        //SET 0, B
        //#0xC0:
        ,{ parentObj =>
            parentObj.registerB |= 0x01
        }
        //SET 0, C
        //#0xC1:
        ,{ parentObj =>
            parentObj.registerC |= 0x01
        }
        //SET 0, D
        //#0xC2:
        ,{ parentObj =>
            parentObj.registerD |= 0x01
        }
        //SET 0, E
        //#0xC3:
        ,{ parentObj =>
            parentObj.registerE |= 0x01
        }
        //SET 0, H
        //#0xC4:
        ,{ parentObj =>
            parentObj.registersHL |= 0x0100
        }
        //SET 0, L
        //#0xC5:
        ,{ parentObj =>
            parentObj.registersHL |= 0x01
        }
        //SET 0, (HL)
        //#0xC6:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x01)
        }
        //SET 0, A
        //#0xC7:
        ,{ parentObj =>
            parentObj.registerA |= 0x01
        }
        //SET 1, B
        //#0xC8:
        ,{ parentObj =>
            parentObj.registerB |= 0x02
        }
        //SET 1, C
        //#0xC9:
        ,{ parentObj =>
            parentObj.registerC |= 0x02
        }
        //SET 1, D
        //#0xCA:
        ,{ parentObj =>
            parentObj.registerD |= 0x02
        }
        //SET 1, E
        //#0xCB:
        ,{ parentObj =>
            parentObj.registerE |= 0x02
        }
        //SET 1, H
        //#0xCC:
        ,{ parentObj =>
            parentObj.registersHL |= 0x0200
        }
        //SET 1, L
        //#0xCD:
        ,{ parentObj =>
            parentObj.registersHL |= 0x02
        }
        //SET 1, (HL)
        //#0xCE:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x02)
        }
        //SET 1, A
        //#0xCF:
        ,{ parentObj =>
            parentObj.registerA |= 0x02
        }
        //SET 2, B
        //#0xD0:
        ,{ parentObj =>
            parentObj.registerB |= 0x04
        }
        //SET 2, C
        //#0xD1:
        ,{ parentObj =>
            parentObj.registerC |= 0x04
        }
        //SET 2, D
        //#0xD2:
        ,{ parentObj =>
            parentObj.registerD |= 0x04
        }
        //SET 2, E
        //#0xD3:
        ,{ parentObj =>
            parentObj.registerE |= 0x04
        }
        //SET 2, H
        //#0xD4:
        ,{ parentObj =>
            parentObj.registersHL |= 0x0400
        }
        //SET 2, L
        //#0xD5:
        ,{ parentObj =>
            parentObj.registersHL |= 0x04
        }
        //SET 2, (HL)
        //#0xD6:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x04)
        }
        //SET 2, A
        //#0xD7:
        ,{ parentObj =>
            parentObj.registerA |= 0x04
        }
        //SET 3, B
        //#0xD8:
        ,{ parentObj =>
            parentObj.registerB |= 0x08
        }
        //SET 3, C
        //#0xD9:
        ,{ parentObj =>
            parentObj.registerC |= 0x08
        }
        //SET 3, D
        //#0xDA:
        ,{ parentObj =>
            parentObj.registerD |= 0x08
        }
        //SET 3, E
        //#0xDB:
        ,{ parentObj =>
            parentObj.registerE |= 0x08
        }
        //SET 3, H
        //#0xDC:
        ,{ parentObj =>
            parentObj.registersHL |= 0x0800
        }
        //SET 3, L
        //#0xDD:
        ,{ parentObj =>
            parentObj.registersHL |= 0x08
        }
        //SET 3, (HL)
        //#0xDE:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x08)
        }
        //SET 3, A
        //#0xDF:
        ,{ parentObj =>
            parentObj.registerA |= 0x08
        }
        //SET 4, B
        //#0xE0:
        ,{ parentObj =>
            parentObj.registerB |= 0x10
        }
        //SET 4, C
        //#0xE1:
        ,{ parentObj =>
            parentObj.registerC |= 0x10
        }
        //SET 4, D
        //#0xE2:
        ,{ parentObj =>
            parentObj.registerD |= 0x10
        }
        //SET 4, E
        //#0xE3:
        ,{ parentObj =>
            parentObj.registerE |= 0x10
        }
        //SET 4, H
        //#0xE4:
        ,{ parentObj =>
            parentObj.registersHL |= 0x1000
        }
        //SET 4, L
        //#0xE5:
        ,{ parentObj =>
            parentObj.registersHL |= 0x10
        }
        //SET 4, (HL)
        //#0xE6:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x10)
        }
        //SET 4, A
        //#0xE7:
        ,{ parentObj =>
            parentObj.registerA |= 0x10
        }
        //SET 5, B
        //#0xE8:
        ,{ parentObj =>
            parentObj.registerB |= 0x20
        }
        //SET 5, C
        //#0xE9:
        ,{ parentObj =>
            parentObj.registerC |= 0x20
        }
        //SET 5, D
        //#0xEA:
        ,{ parentObj =>
            parentObj.registerD |= 0x20
        }
        //SET 5, E
        //#0xEB:
        ,{ parentObj =>
            parentObj.registerE |= 0x20
        }
        //SET 5, H
        //#0xEC:
        ,{ parentObj =>
            parentObj.registersHL |= 0x2000
        }
        //SET 5, L
        //#0xED:
        ,{ parentObj =>
            parentObj.registersHL |= 0x20
        }
        //SET 5, (HL)
        //#0xEE:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x20)
        }
        //SET 5, A
        //#0xEF:
        ,{ parentObj =>
            parentObj.registerA |= 0x20
        }
        //SET 6, B
        //#0xF0:
        ,{ parentObj =>
            parentObj.registerB |= 0x40
        }
        //SET 6, C
        //#0xF1:
        ,{ parentObj =>
            parentObj.registerC |= 0x40
        }
        //SET 6, D
        //#0xF2:
        ,{ parentObj =>
            parentObj.registerD |= 0x40
        }
        //SET 6, E
        //#0xF3:
        ,{ parentObj =>
            parentObj.registerE |= 0x40
        }
        //SET 6, H
        //#0xF4:
        ,{ parentObj =>
            parentObj.registersHL |= 0x4000
        }
        //SET 6, L
        //#0xF5:
        ,{ parentObj =>
            parentObj.registersHL |= 0x40
        }
        //SET 6, (HL)
        //#0xF6:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x40)
        }
        //SET 6, A
        //#0xF7:
        ,{ parentObj =>
            parentObj.registerA |= 0x40
        }
        //SET 7, B
        //#0xF8:
        ,{ parentObj =>
            parentObj.registerB |= 0x80
        }
        //SET 7, C
        //#0xF9:
        ,{ parentObj =>
            parentObj.registerC |= 0x80
        }
        //SET 7, D
        //#0xFA:
        ,{ parentObj =>
            parentObj.registerD |= 0x80
        }
        //SET 7, E
        //#0xFB:
        ,{ parentObj =>
            parentObj.registerE |= 0x80
        }
        //SET 7, H
        //#0xFC:
        ,{ parentObj =>
            parentObj.registersHL |= 0x8000
        }
        //SET 7, L
        //#0xFD:
        ,{ parentObj =>
            parentObj.registersHL |= 0x80
        }
        //SET 7, (HL)
        //#0xFE:
        ,{ parentObj =>
            parentObj.memoryWriter[parentObj.registersHL](parentObj, parentObj.registersHL, parentObj.memoryReader[parentObj.registersHL](parentObj, parentObj.registersHL) | 0x80)
        }
        //SET 7, A
        //#0xFF:
        ,{ parentObj =>
            parentObj.registerA |= 0x80
        }
    ]
    var TICKTable: Array<Int64> = [ //Number of machine cycles for each instruction:
        4, 12,  8,  8,  4,  4,  8,  4,     20,  8,  8, 8,  4,  4, 8,  4,	//0
        4, 12,  8,  8,  4,  4,  8,  4,     12,  8,  8, 8,  4,  4, 8,  4,  	//1
        8, 12,  8,  8,  4,  4,  8,  4,      8,  8,  8, 8,  4,  4, 8,  4,  	//2
        8, 12,  8,  8, 12, 12, 12,  4,      8,  8,  8, 8,  4,  4, 8,  4,  	//3
        
        4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4, 4,  4,  4, 8,  4,  	//4
        4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4, 4,  4,  4, 8,  4,  	//5
        4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4, 4,  4,  4, 8,  4,  	//6
        8,  8,  8,  8,  8,  8,  4,  8,      4,  4,  4, 4,  4,  4, 8,  4,  	//7
        
        4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4, 4,  4,  4, 8,  4,  	//8
        4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4, 4,  4,  4, 8,  4,  	//9
        4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4, 4,  4,  4, 8,  4,  	//A
        4,  4,  4,  4,  4,  4,  8,  4,      4,  4,  4, 4,  4,  4, 8,  4,  	//B
        
        8, 12, 12, 16, 12, 16,  8, 16,      8, 16, 12, 0, 12, 24, 8, 16,  	//C
        8, 12, 12,  4, 12, 16,  8, 16,      8, 16, 12, 4, 12,  4, 8, 16,  	//D
        12, 12,  8,  4,  4, 16,  8, 16,     16,  4, 16, 4,  4,  4, 8, 16,  	//E
        12, 12,  8,  4,  4, 16,  8, 16,     12,  8, 16, 4,  0,  4, 8, 16   	//F
    ]
    var SecondaryTICKTable: Array<Int64> = [  //Number of machine cycles for each 0xCBXX instruction:
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//0
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//1
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//2
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//3
        
        8, 8, 8, 8, 8, 8, 12, 8,        8, 8, 8, 8, 8, 8, 12, 8,  		//4
        8, 8, 8, 8, 8, 8, 12, 8,        8, 8, 8, 8, 8, 8, 12, 8,  		//5
        8, 8, 8, 8, 8, 8, 12, 8,        8, 8, 8, 8, 8, 8, 12, 8,  		//6
        8, 8, 8, 8, 8, 8, 12, 8,        8, 8, 8, 8, 8, 8, 12, 8,  		//7
        
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//8
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//9
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//A
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//B
        
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//C
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//D
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8,  		//E
        8, 8, 8, 8, 8, 8, 16, 8,        8, 8, 8, 8, 8, 8, 16, 8   		//F
    ]
    
    public init( canvas: GameBoyCanvas,  ROMImage: String) {
        this.canvas = canvas                                            //Canvas DOM object for drawing out the graphics to.
        this.ROMImage = ROMImage
        updateGBBGPalette = updateGBColorizedBGPalette
        updateGBOBJPalette = updateGBRegularOBJPalette
        //Compile the LCD controller functions.
        initializeLCDController()
        initializeAudioStartState()
        initializeTiming()
        //Initialize the white noise cache tables ahead of time:
        intializeWhiteNoise()
    }
    func returnFromRTCState() {
        
        if ( cTIMER) {
            let rtcData = this.openRTC(name)
            var index = 0
            lastIteration = (rtcData[index] as Int64).getOrThrow()
            index++
            RTCisLatched = (rtcData[index] as Bool).getOrThrow()
            index++
            latchedSeconds = (rtcData[index] as Int64).getOrThrow()
            index++
            latchedMinutes =( rtcData[index] as Int64).getOrThrow()
            index++
            latchedHours =( rtcData[index] as Int64).getOrThrow()
            index++
            latchedLDays = (rtcData[index] as Int64).getOrThrow()
            index++
            latchedHDays = (rtcData[index] as Int64).getOrThrow()
            index++
            RTCSeconds = (rtcData[index] as Int64).getOrThrow()
            index++
            RTCMinutes = (rtcData[index] as Int64).getOrThrow()
            index++
            RTCHours = (rtcData[index] as Int64).getOrThrow()
            index++
            RTCDays = (rtcData[index] as Int64).getOrThrow()
            index++
            RTCDayOverFlow = (rtcData[index] as Bool).getOrThrow()
            index++
            RTCHALT = (rtcData[index] as Bool).getOrThrow()
        }
    }
    func start() {

        this.initMemory()   //Write the startup memory.
        this.ROMLoad()      //Load the ROM into memory and get cartridge information from it.
        this.initLCD()      //Initialize the graphics.
        this.initSound()    //Sound object initialization.
        this.run()         //Start the emulation.
    }
    func initMemory() {

        //Initialize the RAM:
        memory = Array<Int64>(0x10000,repeat:0)
        frameBuffer =Array<Int64>(23040, repeat:0xF8F8F8)
        BGCHRBank1.array =Array<Int64>(0x800,repeat: 0)
        TICKTable = (toTypedArray(TICKTable, "uint8") as Array<Int64>).getOrThrow()
        SecondaryTICKTable = (toTypedArray(SecondaryTICKTable, "uint8") as Array<Int64>).getOrThrow()
        channel3PCM = Array<Int64>(0x20, repeat:0)
    }
    func generateCacheArray( tileAmount: Int64) : ArrayList<ArrayObject> {
    
        var tileArray: ArrayList<ArrayObject> = ArrayList<ArrayObject> ()
        var tileNumber: Int64 = 0
        while ( tileNumber < tileAmount) {
            let object = ArrayObject()
            object.array =  Array<Int64>(64,repeat: 0)
            tileArray.add(object)
            tileNumber += 1
        }
        return tileArray
    }
    func initSkipBootstrap() {
 
        var index: Int64 = 0xFF
        while ( index >= 0) {
            if ( index >= 0x30 && index < 0x40) {
                memoryWrite(0xFF00 | index, ffxxDump[index])
            }
            else {
                match (index) {
                case 0x00|0x01|0x02|0x05|0x07|0x0F|0xFF =>memoryWrite(0xFF00 | index, ffxxDump[index])
                case _=>
                    memory[0xFF00 | index] = ffxxDump[index]
                }
            }
            index -= 1
        }
        if ( cGBC) {
            memory[0xFF6C] = 0xFE
            memory[0xFF74] = 0xFE
        }
        else {
            memory[0xFF48] = 0xFF
            memory[0xFF49] = 0xFF
            memory[0xFF6C] = 0xFF
            memory[0xFF74] = 0xFF
        }
        //Start as an unset device:
        cout("Starting without the GBC boot ROM.", 0)
        registerA = 0x1
        if(cGBC){registerA = 0x11}
        registerB = 0
        registerC = 0x13
        registerD = 0
        registerE = 0xD8
        FZero = true
        FSubtract = false
        FHalfCarry = true
        FCarry = true
        registersHL = 0x014D
        LCDCONTROL = LINECONTROL
        IME = false
        IRQLineMatched = 0
        interruptsRequested = 225
        interruptsEnabled = 0
        hdmaRunning = false
        CPUTicks = 12
        STATTracker = 0
        modeSTAT = 1
        spriteCount = 252
        LYCMatchTriggerSTAT = false
        mode2TriggerSTAT = false
        mode1TriggerSTAT = false
        mode0TriggerSTAT = false
        LCDisOn = true
        channel1FrequencyTracker = 0x2000
        channel1DutyTracker = 0
        channel1CachedDuty = dutyLookup[2]
        channel1totalLength = 0
        channel1envelopeVolume = 0
        channel1envelopeType = false
        channel1envelopeSweeps = 0
        channel1envelopeSweepsLast = 0
        channel1consecutive = true
        channel1frequency = 1985
        channel1SweepFault = true
        channel1ShadowFrequency = 1985
        channel1timeSweep = 1
        channel1lastTimeSweep = 0
        channel1numSweep = 0
        channel1frequencySweepDivider = 0
        channel1decreaseSweep = false
        channel2FrequencyTracker = 0x2000
        channel2DutyTracker = 0
        channel2CachedDuty = dutyLookup[2]
        channel2totalLength = 0
        channel2envelopeVolume = 0
        channel2envelopeType = false
        channel2envelopeSweeps = 0
        channel2envelopeSweepsLast = 0
        channel2consecutive = true
        channel2frequency = 0
        channel3canPlay = false
        channel3totalLength = 0
        channel3patternType = 4
        channel3frequency = 0
        channel3consecutive = true
        channel3Counter = 0x418
        channel4FrequencyPeriod = 8
        channel4totalLength = 0
        channel4envelopeVolume = 0
        channel4currentVolume = 0
        channel4envelopeType = false
        channel4envelopeSweeps = 0
        channel4envelopeSweepsLast = 0
        channel4consecutive = true
        channel4BitRange = 0x7FFF
        channel4VolumeShifter = 15
        channel1FrequencyCounter = 0x200
        channel2FrequencyCounter = 0x200
        channel3Counter = 0x800
        channel3FrequencyPeriod = 0x800
        channel3lastSampleLookup = 0
        channel4lastSampleLookup = 0
        VinLeftChannelMasterVolume = 1
        VinRightChannelMasterVolume = 1
        soundMasterEnabled = true
        leftChannel1 = true
        leftChannel2 = true
        leftChannel3 = true
        leftChannel4 = true
        rightChannel1 = true
        rightChannel2 = true
        rightChannel3 = false
        rightChannel4 = false
        DIVTicks = 27044
        LCDTicks = 160
        timerTicks = 0
        TIMAEnabled = false
        TACClocker = 1024
        serialTimer = 0
        serialShiftTimer = 0
        serialShiftTimerAllocated = 0
        IRQEnableDelay = 0
        actualScanLine = 144
        lastUnrenderedLine = 0
        gfxWindowDisplay = false
        gfxSpriteShow = false
        gfxSpriteNormalHeight = true
        bgEnabled = true
        BGPriorityEnabled = true
        gfxWindowCHRBankPosition = 0
        gfxBackgroundCHRBankPosition = 0
        gfxBackgroundBankOffset = 0
        windowY = 0
        windowX = 0
        drewBlank = 0
        midScanlineOffset = -1
        currentX = 0
    }
    func initBootstrap() {
    
        //Start as an unset device:
        cout("Starting the selected boot ROM.", 0)
        programCounter = 0
        stackPointer = 0
        IME = false
        LCDTicks = 0
        DIVTicks = 0
        registerA = 0
        registerB = 0
        registerC = 0
        registerD = 0
        registerE = 0
        FZero = false
        FSubtract = false
        FHalfCarry = false
        FCarry = false
        registersHL = 0
        leftChannel1 = false
        leftChannel2 = false
        leftChannel3 = false
        leftChannel4 = false
        rightChannel1 = false
        rightChannel2 = false
        rightChannel3 = false
        rightChannel4 = false
        channel2frequency = 0
        channel1frequency = 0
        channel4consecutive = false
        channel2consecutive = false
        channel1consecutive = false
        VinLeftChannelMasterVolume = 8
        VinRightChannelMasterVolume = 8
        memory[0xFF00] = 0xF  //Set the joypad state.
    }
    func ROMLoad() {
     
        //Load the first two ROM banks (0x0000 - 0x7FFF) into regular gameboy memory:
        ROM = []
        usedBootROM = (settings[1] as Bool).getOrThrow()
        let maxLength = ROMImage.toRuneArray().size
        if ( (maxLength < 0x4000)) {
            return
        }
        ROM =  Array<Int64>(maxLength,repeat: 0)
        let ROMImageArray = ROMImage.toRuneArray()
        var romIndex = 0
        if ( (usedBootROM)) {
            if (!((settings[11] as Bool).getOrThrow())) {
                //Patch in the GBC boot ROM into the memory map:
                while ( romIndex < 0x100) {
                    memory[romIndex] = GBCBOOTROM[romIndex]                      //Load in the GameBoy Color BOOT ROM.
                    ROM[romIndex] = Int64(String(ROMImageArray[romIndex]).toArray()[0] & 0xFF)            //Decode the ROM binary for the switch out.
                    romIndex += 1
                }
                while ( romIndex < 0x200) {
                    ROM[romIndex] = Int64((String(ROMImageArray[romIndex]).toArray()[0]) & 0xFF)  //Load in the game ROM.
                    memory[romIndex] = ROM[romIndex]
                    romIndex += 1
                }
                while ( romIndex < 0x900) {
                    memory[romIndex] = GBCBOOTROM[romIndex - 0x100]                  //Load in the GameBoy Color BOOT ROM.
                    ROM[romIndex] = Int64((String(ROMImageArray[romIndex]).toArray()[0]) & 0xFF)              //Decode the ROM binary for the switch out.
                    romIndex += 1
                }
                usedGBCBootROM = true
            }
            else {
                //Patch in the GBC boot ROM into the memory map:
                while ( romIndex < 0x100) {
                    memory[romIndex] = GBBOOTROM[romIndex]                      //Load in the GameBoy Color BOOT ROM.
                    ROM[romIndex] = Int64((String(ROMImageArray[romIndex]).toArray()[0]) & 0xFF)              //Decode the ROM binary for the switch out.
                    romIndex += 1
                }
            }
            while ( romIndex < 0x4000) {
                ROM[romIndex] = Int64((String(ROMImageArray[romIndex]).toArray()[0]) & 0xFF)  //Load in the game ROM.
                memory[romIndex] = ROM[romIndex]
                romIndex += 1
            }
        }
        else {
            //Don't load in the boot ROM:
            while ( romIndex < 0x4000) {
                ROM[romIndex] = Int64((String(ROMImageArray[romIndex]).toArray()[0]) & 0xFF)  //Load in the game ROM.
                memory[romIndex] = ROM[romIndex]
                romIndex += 1
            }
        }
        //Finish the decoding of the ROM binary:
        while ( romIndex < maxLength) {
            ROM[romIndex] = Int64((String(ROMImageArray[romIndex]).toArray()[0]) & 0xFF)
            romIndex += 1
        }
        ROMBankEdge = Int64(floor(Float64(ROM.size / 0x4000)))
        //Set up the emulator for the cartidge specifics:
        interpretCartridge()
        //Check for IRQ matching upon initialization:
        checkIRQMatching()
    }
    func getROMImage() : Any {
        
        if ( ROMImage.size > 0) {
            return ROMImage.size
        }
        let length = ROM.size
        for ( index in 0..length) {
            ROMImage += String(Rune(ROM[index]))
        }
        return ROMImage
    }
    func interpretCartridge() {
        
        // ROM name
        for ( index in 0x134..0x13F) {
            if (String(ROMImage.toRuneArray()[index]).toArray()[0] > 0) {
                name += String(ROMImage.toRuneArray()[index])
            }
        }
        // ROM game code (for newer games)
        for ( index in 0x13F..0x143) {
            if ( String(ROMImage.toRuneArray()[index]).toArray()[0]   > 0) {
                gameCode += String(ROMImage.toRuneArray()[index])
            }
        }
        cout("Game Code: " + gameCode, 0)
        // Cartridge type
        cartridgeType = ROM[0x147]
        cout("Cartridge type #" + String(Rune(cartridgeType)), 0)
        //Map out ROM cartridge sub-types.
        var MBCType = ""
        match ( (cartridgeType)) {
        case 0x00=>
            //ROM w/o bank switching
            if ( !((settings[9] as Bool).getOrThrow())) {
                MBCType = "ROM"
                
            }
        case 0x01=>
            cMBC1 = true
            MBCType = "MBC1"
            
        case 0x02=>
            cMBC1 = true
            cSRAM = true
            MBCType = "MBC1 + SRAM"
            
        case 0x03=>
            cMBC1 = true
            cSRAM = true
            cBATT = true
            MBCType = "MBC1 + SRAM + BATT"
            
        case 0x05=>
            cMBC2 = true
            MBCType = "MBC2"
            
        case 0x06=>
            cMBC2 = true
            cBATT = true
            MBCType = "MBC2 + BATT"
            
        case 0x08=>
            cSRAM = true
            MBCType = "ROM + SRAM"
            
        case 0x09=>
            cSRAM = true
            cBATT = true
            MBCType = "ROM + SRAM + BATT"
            
        case 0x0B=>
            cMMMO1 = true
            MBCType = "MMMO1"
          
        case 0x0C=>
            cMMMO1 = true
            cSRAM = true
            MBCType = "MMMO1 + SRAM"
            
        case 0x0D=>
            cMMMO1 = true
            cSRAM = true
            cBATT = true
            MBCType = "MMMO1 + SRAM + BATT"
            
        case 0x0F=>
            cMBC3 = true
            cTIMER = true
            cBATT = true
            MBCType = "MBC3 + TIMER + BATT"
            
        case 0x10=>
            cMBC3 = true
            cTIMER = true
            cBATT = true
            cSRAM = true
            MBCType = "MBC3 + TIMER + BATT + SRAM"
           
        case 0x11=>
            cMBC3 = true
            MBCType = "MBC3"
           
        case 0x12=>
            cMBC3 = true
            cSRAM = true
            MBCType = "MBC3 + SRAM"
            
        case 0x13=>
            cMBC3 = true
            cSRAM = true
            cBATT = true
            MBCType = "MBC3 + SRAM + BATT"
           
        case 0x19=>
            cMBC5 = true
            MBCType = "MBC5"
            
        case 0x1A=>
            cMBC5 = true
            cSRAM = true
            MBCType = "MBC5 + SRAM"
            
        case 0x1B=>
            cMBC5 = true
            cSRAM = true
            cBATT = true
            MBCType = "MBC5 + SRAM + BATT"
            
        case 0x1C=>
            cRUMBLE = true
            MBCType = "RUMBLE"
            
        case 0x1D=>
            cRUMBLE = true
            cSRAM = true
            MBCType = "RUMBLE + SRAM"
            
        case 0x1E=>
            cRUMBLE = true
            cSRAM = true
            cBATT = true
            MBCType = "RUMBLE + SRAM + BATT"
            
        case 0x1F=>
            cCamera = true
            MBCType = "GameBoy Camera"
            
        case 0x22=>
            cMBC7 = true
            cSRAM = true
            cBATT = true
            MBCType = "MBC7 + SRAM + BATT"
            
        case 0xFD=>
            cTAMA5 = true
            MBCType = "TAMA5"
            
        case 0xFE=>
            cHuC3 = true
            MBCType = "HuC3"
            
        case 0xFF=>
            cHuC1 = true
            MBCType = "HuC1"
            
        case _ =>
            MBCType = "Unknown"
            cout("Cartridge type is unknown.", 2)
            pausePlay()
        }
        cout("Cartridge Type: " + MBCType + ".", 0)
        // ROM and RAM banks
        if(ROMBanks.contains(ROM[0x148])){
            numROMBanks = ROMBanks[ROM[0x148]]
        }else{
            numROMBanks = 0
        }
        cout(String(Rune(numROMBanks)) + " ROM banks.", 0)
        if(ROM[0x149]<RAMBanks.size){
            match ( (RAMBanks[ROM[0x149]])) {
                case 0=>
                    cout("No RAM banking requested for allocation or MBC is of type 2.", 0)
            
                case 2=>
                    cout("1 RAM bank requested for allocation.", 0)
            
                case 3=>
                    cout("4 RAM banks requested for allocation.", 0)
            
                case 4=>
                    cout("16 RAM banks requested for allocation.", 0)
            
                case _ =>
                    cout("RAM bank amount requested is unknown, will use maximum allowed by specified MBC type.", 0)
            }
          
        }

        //Check the GB/GBC mode byte:
        if ( (!usedBootROM)) {
            match ( (ROM[0x143])) {
            case 0x00=>  //Only GB mode
                cGBC = false
                cout("Only GB mode detected.", 0)
                
            case 0x32=> //Exception to the GBC identifying code:
                if ( (!(settings[2] as Bool).getOrThrow() && name + gameCode + String(Rune(ROM[0x143])) == "Game and Watch 50")) {
                    cGBC = true
                    cout("Created a boot exception for Game and Watch Gallery 2 (GBC ID byte is wrong on the cartridge).", 1)
                }
                else {
                    cGBC = false
                }
                
            case 0x80=> //Both GB + GBC modes
                cGBC = !(settings[2] as Bool).getOrThrow()
                cout("GB and GBC mode detected.", 0)
                
            case 0xC0=> //Only GBC mode
                cGBC = true
                cout("Only GBC mode detected.", 0)
                
            case _ =>
                cGBC = false
                cout("Unknown GameBoy game type code #" + String(Rune(ROM[0x143])) + ", defaulting to GB mode (Old games don't have a type code).", 1)
            }
            inBootstrap = false
            setupRAM()  //CPU/(V)RAM initialization.
            initSkipBootstrap()
            initializeAudioStartState() // Line added for benchmarking.
        }
        else {
            cGBC = usedGBCBootROM  //Allow the GBC boot ROM to run in GBC mode...
            setupRAM()  //CPU/(V)RAM initialization.
            initBootstrap()
        }
        initializeModeSpecificArrays()
        //License Code Lookup:
        let cOldLicense = ROM[0x14B]
        let cNewLicense = (ROM[0x144] & 0xFF00) | (ROM[0x145] & 0xFF)
        if ( (cOldLicense != 0x33)) {
            //Old Style License Header
            cout("Old style license code: " + String(Rune(cOldLicense)), 0)
        }
        else {
            //New Style License Header
            cout("New style license code: " + String(Rune(cNewLicense)), 0)
        }
        ROMImage = ""  //Memory consumption reduction.
    }
    func initializeTiming() {
        
        //Emulator Timing:
        baseCPUCyclesPerIteration = Float64(0x80000) / Float64(0x7D) * Float64((settings[6] as Int64).getOrThrow())
        CPUCyclesTotalRoundoff = Float64(Int64(baseCPUCyclesPerIteration) % 4)
        CPUCyclesTotal = Float64(Int64(baseCPUCyclesPerIteration - CPUCyclesTotalRoundoff) | 0)
        CPUCyclesTotalBase = CPUCyclesTotal
        CPUCyclesTotalCurrent = 0.0
    }
    func setupRAM() {
        
        //Setup the auxilliary/switchable RAM:
        if ( (cMBC2)) {
            numRAMBanks = 1 / 16
        }
        else if ( (cMBC1 || cRUMBLE || cMBC3 || cHuC3)) {
            numRAMBanks = 4
        }
        else if ( (cMBC5)) {
            numRAMBanks = 16
        }
        else if ( (cSRAM)) {
            numRAMBanks = 1
        }
        if ( (numRAMBanks > 0)) {
            if ( (!MBCRAMUtilized())) {
                //For ROM and unknown MBC cartridges using the external RAM:
                MBCRAMBanksEnabled = true
            }
            //Switched RAM Used
            var MBCRam: Array<Int64> = []
            MBCRam=this.openMBC(name)
            if ( (MBCRam.size > 0)) {
                //Flash the SRAM into memory:
                this.MBCRam = (toTypedArray(MBCRam, "uint8") as Array<Int64>).getOrThrow()
            }
            else {
                this.MBCRam =Array<Int64>(numRAMBanks * 0x2000, repeat:0)
            }
        }
        cout("Actual bytes of MBC RAM allocated: " + String(Rune(numRAMBanks * 0x2000)), 0)
        returnFromRTCState()
        //Setup the RAM for GBC mode.
        if ( (cGBC)) {
            VRAM =  Array<Int64>(0x2000, repeat:0)
            GBCMemory = Array<Int64>(0x7000, repeat:0)
        }
        memoryReadJumpCompile()
        memoryWriteJumpCompile()
    }
    func MBCRAMUtilized() : Bool {
        
        return cMBC1 || cMBC2 || cMBC3 || cMBC5 || cMBC7 || cRUMBLE
    }
    func recomputeDimension() {
        
        initNewCanvas()
        //Cache some dimension info:
        onscreenWidth = canvas.getOrThrow().width
        onscreenHeight = canvas.getOrThrow().height
        // The following line was modified for benchmarking:
        if ( (GameBoyWindow.mozRequestAnimationFrame)) {
            //Firefox slowness hack:
            if(!(settings[12] as Bool).getOrThrow()){
                onscreenWidth =  160 
            }else{
                onscreenWidth = canvas.getOrThrow().width
            }
            canvas.getOrThrow().width = onscreenWidth
            if(!(settings[12] as Bool).getOrThrow()){
                onscreenHeight =  144 
            }else{
                onscreenHeight =  canvas.getOrThrow().height
            }
            canvas.getOrThrow().height = onscreenHeight
        }
        else {
            onscreenWidth = canvas.getOrThrow().width
            onscreenHeight = canvas.getOrThrow().height
        }
        if(!(settings[12] as Bool).getOrThrow()){
            offscreenWidth =  160 
        }else{
            offscreenWidth = canvas.getOrThrow().width
        }
        if(!(settings[12] as Bool).getOrThrow()){
            offscreenHeight =144 
        } else{
            offscreenHeight =  canvas.getOrThrow().height
        }
        offscreenRGBCount = offscreenWidth * offscreenHeight * 4
    }
    func initLCD() {
        
        recomputeDimension()
        if ( (offscreenRGBCount != 92160)) {
            //Only create the resizer handle if we need it:
            compileResizeFrameBufferFunction()
        }
        else {
            //Resizer not needed:
            resizer = None
        }
        canvasOffscreen = GameBoyCanvas()  // Line modified for benchmarking.
        canvasOffscreen.getOrThrow().width = offscreenWidth
        canvasOffscreen.getOrThrow().height = offscreenHeight
        drawContextOffscreen = canvasOffscreen.getOrThrow().getContext("2d")
        drawContextOnscreen = canvas.getOrThrow().getContext("2d")
        //Get a CanvasPixelArray buffer:
        canvasBuffer = drawContextOffscreen.getOrThrow().createImageData(offscreenWidth, offscreenHeight)
        var index = offscreenRGBCount
        while ( (index > 0)) {
            index -= 4
            canvasBuffer.getOrThrow().data[index] = 0xF8
            canvasBuffer.getOrThrow().data[index + 1] = 0xF8
            canvasBuffer.getOrThrow().data[index + 2] = 0xF8
            canvasBuffer.getOrThrow().data[index + 3] = 0xFF
        }
        graphicsBlit()
        canvas.getOrThrow().style.visibility = "visible"
        if ( (swizzledFrame.size == 0)) {
            swizzledFrame = Array<Int64>(69120, repeat:0xFF)
        }
        //Test the draw system and browser vblank latching:
        drewFrame = true                    //Copy the latest graphics to buffer.
        requestDraw()
    }
    func graphicsBlit() {
        
        if ( (offscreenWidth == onscreenWidth && offscreenHeight == onscreenHeight)) {
            drawContextOnscreen.getOrThrow().putImageData(canvasBuffer.getOrThrow(), 0, 0)
        }
        else {
            drawContextOffscreen.getOrThrow().putImageData(canvasBuffer.getOrThrow(), 0, 0)
            drawContextOnscreen.getOrThrow().drawImage(canvasOffscreen.getOrThrow(), 0, 0, onscreenWidth, onscreenHeight)
        }
    }
    func JoyPadEvent( key: Int64,  down: Bool) {
        if ( (down)) {
            JoyPad &= 0xFF ^ (1 << key)
            if ( (!cGBC && (!usedBootROM || !usedGBCBootROM))) {
                interruptsRequested |= 0x10  //A real GBC doesn't set this!
                remainingClocks = 0
                checkIRQMatching()
            }
        }
        else {
            JoyPad |= (1 << key)
        }
        // (((memory[0xFF00] & 0x20) == 0) ? Int64((JoyPad >> 4)) : 0xF)
        var temp1 = 0xF
        if((memory[0xFF00] & 0x20) == 0){
            temp1 = Int64((JoyPad >> 4))
        }
        //(((memory[0xFF00] & 0x10) == 0) ? Int64((JoyPad & 0xF)) : 0xF)
        var temp2 = 0xF
        if((memory[0xFF00] & 0x10) == 0){
            temp2 = Int64((JoyPad & 0xF))
        }
        memory[0xFF00] = (memory[0xFF00] & 0x30) + ( temp1 & temp2)
        CPUStopped = false
    }
    func GyroEvent( xTemp: Int64,  yTemp: Int64) {
        var x = xTemp
        var y = yTemp
        x *= -100
        x += 2047
        highX = x >> 8
        lowX = x & 0xFF
        y *= -100
        y += 2047
        highY = y >> 8
        lowY = y & 0xFF
    }
    func initSound() {
       
        sampleSize = Float64(0x400000) / 1000.0 * Float64((settings[6] as Int64).getOrThrow())
        machineOut = (settings[13] as Int64).getOrThrow()
        if ( (settings[0] as Bool).getOrThrow()) {
            _ = this
            audioHandle = XAudioServer(channels:2, sampleRate:0x400000 / (settings[13] as Int64).getOrThrow(), minBufferSize:0, maxBufferSize:Int64(max(sampleSize * Float64((settings[8] as Int64).getOrThrow()) / Float64((settings[13] as Int64).getOrThrow()), 8192.0)) << 1,underRunCallback: None,volume: (settings[14] as Int64).getOrThrow())
            initAudioBuffer()
        }
        else if ( (audioHandle.isSome())) {
            //Mute the audio output, as it has an immediate silencing effect:
            audioHandle?.changeVolume(0)
        }
    }
    func changeVolume() {
        if ( ((settings[0] as Bool).getOrThrow() && audioHandle.isSome())) {
            audioHandle?.changeVolume((settings[14] as Int64).getOrThrow())
        }
    }
    func initAudioBuffer() {
      
        audioIndex = 0
        bufferContainAmount = max(Int64(sampleSize * Float64((settings[7] as Int64).getOrThrow()) / Float64((settings[13] as Int64).getOrThrow())), 4096) << 1
        numSamplesTotal = (Int64(sampleSize) - (Int64(sampleSize) % (settings[13] as Int64).getOrThrow())) | 0
        currentBuffer =  Array<Int64>(numSamplesTotal,repeat: 0xF0F0)
        secondaryBuffer = Array<Float32>((numSamplesTotal << 1) / (settings[13] as Int64).getOrThrow(), repeat:0.0)
    }
    func intializeWhiteNoise() {
    
        //Noise Sample Tables:
        var randomFactor = 1
        //15-bit LSFR Cache Generation:
        LSFR15Table = Array<Int64>(0x80000,repeat:0)
        var LSFR = 0x7FFF  //Seed value has all its bits set.
        var LSFRShifted = 0x3FFF
        for ( index in 0..0x8000) {
            //Normalize the last LSFR value for usage:
            randomFactor = 1 - (LSFR & 1)  //Docs say it's the inverse.
            //Cache the different volume level results:
            LSFR15Table[0x08000 | index] = randomFactor
            LSFR15Table[0x10000 | index] = randomFactor * 0x2
            LSFR15Table[0x18000 | index] = randomFactor * 0x3
            LSFR15Table[0x20000 | index] = randomFactor * 0x4
            LSFR15Table[0x28000 | index] = randomFactor * 0x5
            LSFR15Table[0x30000 | index] = randomFactor * 0x6
            LSFR15Table[0x38000 | index] = randomFactor * 0x7
            LSFR15Table[0x40000 | index] = randomFactor * 0x8
            LSFR15Table[0x48000 | index] = randomFactor * 0x9
            LSFR15Table[0x50000 | index] = randomFactor * 0xA
            LSFR15Table[0x58000 | index] = randomFactor * 0xB
            LSFR15Table[0x60000 | index] = randomFactor * 0xC
            LSFR15Table[0x68000 | index] = randomFactor * 0xD
            LSFR15Table[0x70000 | index] = randomFactor * 0xE
            LSFR15Table[0x78000 | index] = randomFactor * 0xF
            //Recompute the LSFR algorithm:
            LSFRShifted = LSFR >> 1
            LSFR = LSFRShifted | (((LSFRShifted ^ LSFR) & 0x1) << 14)
        }
        //7-bit LSFR Cache Generation:
        LSFR7Table = Array<Int64>(0x800,repeat:0)
        LSFR = 0x7F  //Seed value has all its bits set.
        for ( index in 0..0x80) {
            //Normalize the last LSFR value for usage:
            randomFactor = 1 - (LSFR & 1)  //Docs say it's the inverse.
            //Cache the different volume level results:
            LSFR7Table[0x080 | index] = randomFactor
            LSFR7Table[0x100 | index] = randomFactor * 0x2
            LSFR7Table[0x180 | index] = randomFactor * 0x3
            LSFR7Table[0x200 | index] = randomFactor * 0x4
            LSFR7Table[0x280 | index] = randomFactor * 0x5
            LSFR7Table[0x300 | index] = randomFactor * 0x6
            LSFR7Table[0x380 | index] = randomFactor * 0x7
            LSFR7Table[0x400 | index] = randomFactor * 0x8
            LSFR7Table[0x480 | index] = randomFactor * 0x9
            LSFR7Table[0x500 | index] = randomFactor * 0xA
            LSFR7Table[0x580 | index] = randomFactor * 0xB
            LSFR7Table[0x600 | index] = randomFactor * 0xC
            LSFR7Table[0x680 | index] = randomFactor * 0xD
            LSFR7Table[0x700 | index] = randomFactor * 0xE
            LSFR7Table[0x780 | index] = randomFactor * 0xF
            //Recompute the LSFR algorithm:
            LSFRShifted = LSFR >> 1
            LSFR = LSFRShifted | (((LSFRShifted ^ LSFR) & 0x1) << 6)
        }
        if ( (noiseSampleTable.size == 0 && memory.size == 0x10000)) {
            //If enabling audio for the first time after a game is already running, set up the internal table reference:
            if((memory[0xFF22] & 0x8) == 0x8){
                noiseSampleTable =   LSFR15Table
            }else{
                noiseSampleTable = LSFR15Table
            }
        }
    }
    func audioUnderrunAdjustment() {
        
        if ( (settings[0] as Bool).getOrThrow()) {
            var underrunAmount = bufferContainAmount - audioHandle.getOrThrow().remainingBuffer() 
            if ( (underrunAmount > 0)) {
                CPUCyclesTotalCurrent += Float64((underrunAmount >> 1) * machineOut)
                recalculateIterationClockLimit()
            }
        }
    }
    func initializeAudioStartState() {
        
        channel1FrequencyTracker = 0x2000
        channel1DutyTracker = 0
        channel1CachedDuty = dutyLookup[2]
        channel1totalLength = 0
        channel1envelopeVolume = 0
        channel1envelopeType = false
        channel1envelopeSweeps = 0
        channel1envelopeSweepsLast = 0
        channel1consecutive = true
        channel1frequency = 0
        channel1SweepFault = false
        channel1ShadowFrequency = 0
        channel1timeSweep = 1
        channel1lastTimeSweep = 0
        channel1numSweep = 0
        channel1frequencySweepDivider = 0
        channel1decreaseSweep = false
        channel2FrequencyTracker = 0x2000
        channel2DutyTracker = 0
        channel2CachedDuty = dutyLookup[2]
        channel2totalLength = 0
        channel2envelopeVolume = 0
        channel2envelopeType = false
        channel2envelopeSweeps = 0
        channel2envelopeSweepsLast = 0
        channel2consecutive = true
        channel2frequency = 0
        channel3canPlay = false
        channel3totalLength = 0
        channel3patternType = 4
        channel3frequency = 0
        channel3consecutive = true
        channel3Counter = 0x800
        channel4FrequencyPeriod = 8
        channel4totalLength = 0
        channel4envelopeVolume = 0
        channel4currentVolume = 0
        channel4envelopeType = false
        channel4envelopeSweeps = 0
        channel4envelopeSweepsLast = 0
        channel4consecutive = true
        channel4BitRange = 0x7FFF
        noiseSampleTable = LSFR15Table
        channel4VolumeShifter = 15
        channel1FrequencyCounter = 0x2000
        channel2FrequencyCounter = 0x2000
        channel3Counter = 0x800
        channel3FrequencyPeriod = 0x800
        channel3lastSampleLookup = 0
        channel4lastSampleLookup = 0
        VinLeftChannelMasterVolume = 8
        VinRightChannelMasterVolume = 8
        mixerOutputCache = 0
        sequencerClocks = 0x2000
        sequencePosition = 0
        channel4FrequencyPeriod = 8
        channel4Counter = 8
        cachedChannel3Sample = 0
        cachedChannel4Sample = 0
        channel1Enabled = false
        channel2Enabled = false
        channel3Enabled = false
        channel4Enabled = false
        channel1canPlay = false
        channel2canPlay = false
        channel4canPlay = false
        channel1OutputLevelCache()
        channel2OutputLevelCache()
        channel3OutputLevelCache()
        channel4OutputLevelCache()
    }
    func outputAudio() {
        
        var sampleFactor: Int64 = 0
        var dirtySample: Int64 = 0
        var averageL: Float32 = 0.0
        var averageR: Float32 = 0.0
        var destinationPosition: Int64 = 0
        let divisor1: Int64 = (settings[13] as Int64).getOrThrow()
        let divisor2: Float32 = Float32(divisor1 * 0xF0)
        var sourcePosition: Int64 = 0
        while ( sourcePosition < numSamplesTotal) {
            sampleFactor = 0
            averageL = 0.0
            averageR = 0.0
            while ( sampleFactor < divisor1) {
                dirtySample = currentBuffer[sourcePosition]
                sourcePosition++
                averageL += Float32(dirtySample >> 9)
                averageR += Float32(dirtySample & 0x1FF)
                sampleFactor += 1
            }
            secondaryBuffer[destinationPosition] = Float32(averageL / divisor2 - 1.0)
            destinationPosition++
            secondaryBuffer[destinationPosition] = Float32(averageR / divisor2 - 1.0)
            destinationPosition++
        }
        audioHandle?.writeAudioNoCallback(secondaryBuffer)
    }
    //Below are the audio generation functions timed against the CPU:
    func generateAudio( numSamplesTemp: Int64) {
        
        var numSamples = numSamplesTemp
        if ( (soundMasterEnabled && !CPUStopped)) {
            var samplesToGenerate = 0
            while ( numSamples > 0) {
                if(numSamples < sequencerClocks){
                    samplesToGenerate = numSamples 
                }else{
                    samplesToGenerate = sequencerClocks
                }
                sequencerClocks -= samplesToGenerate
                numSamples -= samplesToGenerate
                samplesToGenerate -= 1
                while ( samplesToGenerate > -1) {
                    computeAudioChannels()
                    currentBuffer[audioIndex] = mixerOutputCache
                    audioIndex++
                    if ( (audioIndex == numSamplesTotal)) {
                        audioIndex = 0
                        outputAudio()
                    }
                    samplesToGenerate -= 1
                }
                if ( (sequencerClocks == 0)) {
                    audioComputeSequencer()
                    sequencerClocks = 0x2000
                }
            }
        }
        else {
            //SILENT OUTPUT:
            numSamples -= 1
            while ( (numSamples > -1)) {
                numSamples -= 1
                currentBuffer[audioIndex] = 0xF0F0
                audioIndex++
                if ( (audioIndex == numSamplesTotal)) {
                    audioIndex = 0
                    outputAudio()
                }
            }
        }
    }
    //Generate audio, but don't actually output it (Used for when sound is disabled by user/browser):
    func generateAudioFake( numSamples: Int64) {
        
        if ( (soundMasterEnabled && !CPUStopped)) {
            var numSamples = numSamples - 1
            while ( (numSamples > -1)) {
                computeAudioChannels()
                sequencerClocks -= 1
                if ( (sequencerClocks == 0)) {
                    audioComputeSequencer()
                    sequencerClocks = 0x2000
                }
                numSamples -= 1
            }
        }
    }
    func audioJIT() {
        
        //Audio Sample Generation Timing:
        if ( (settings[0] as Bool).getOrThrow()) {
            generateAudio(Int64(audioTicks))
        }
        else {
            generateAudioFake(Int64(audioTicks))
        }
        audioTicks = 0.0
    }
    func audioComputeSequencer() {
        
        match ( (sequencePosition)) {
        case 0=>
            clockAudioLength()
            sequencePosition++
            
        case 2=>
            clockAudioLength()
            clockAudioSweep()
            sequencePosition++
            
        case 4=>
            clockAudioLength()
            sequencePosition++
            
        case 6=>
            clockAudioLength()
            clockAudioSweep()
            sequencePosition++
            
        case 7=>
            clockAudioEnvelope()
            sequencePosition = 0
        case _ =>
            clockAudioDefault()
            
        }
    }
    func clockAudioLength() {
        //Channel 1:
        if ( (channel1totalLength > 1)) {
            channel1totalLength -= 1
        }
        else if ( (channel1totalLength == 1)) {
            channel1totalLength = 0
            channel1EnableCheck()
            memory[0xFF26] &= 0xFE  //Channel #1 On Flag Off
        }
        //Channel 2:
        if ( (channel2totalLength > 1)) {
            channel2totalLength -= 1
        }
        else if ( (channel2totalLength == 1)) {
            channel2totalLength = 0
            channel2EnableCheck()
            memory[0xFF26] &= 0xFD  //Channel #2 On Flag Off
        }
        //Channel 3:
        if ( (channel3totalLength > 1)) {
            channel3totalLength -= 1
        }
        else if ( (channel3totalLength == 1)) {
            channel3totalLength = 0
            channel3EnableCheck()
            memory[0xFF26] &= 0xFB  //Channel #3 On Flag Off
        }
        //Channel 4:
        if ( (channel4totalLength > 1)) {
            channel4totalLength -= 1
        }
        else if ( (channel4totalLength == 1)) {
            channel4totalLength = 0
            channel4EnableCheck()
            memory[0xFF26] &= 0xF7  //Channel #4 On Flag Off
        }
    }
    func clockAudioDefault() {}
    func clockAudioSweep() {
        //Channel 1:
        if ( (!channel1SweepFault && channel1timeSweep > 0)) {
            channel1timeSweep -= 1
            if ( (channel1timeSweep == 0)) {
                runAudioSweep()
            }
        }
    }
    func runAudioSweep() {
   
        //Channel 1:
        if ( (channel1lastTimeSweep > 0)) {
            if ( (channel1frequencySweepDivider > 0)) {
                if ( (channel1numSweep > 0)) {
                    channel1numSweep -= 1
                    if ( (channel1decreaseSweep)) {
                        channel1ShadowFrequency -= channel1ShadowFrequency >> channel1frequencySweepDivider
                        channel1frequency = channel1ShadowFrequency & 0x7FF
                        channel1FrequencyTracker = (0x800 - channel1frequency) << 2
                    }
                    else {
                        channel1ShadowFrequency += channel1ShadowFrequency >> channel1frequencySweepDivider
                        channel1frequency = channel1ShadowFrequency
                        if ( (channel1ShadowFrequency <= 0x7FF)) {
                            channel1FrequencyTracker = (0x800 - channel1frequency) << 2
                            //Run overflow check twice:
                            if ( ((channel1ShadowFrequency + (channel1ShadowFrequency >> channel1frequencySweepDivider)) > 0x7FF)) {
                                channel1SweepFault = true
                                channel1EnableCheck()
                                memory[0xFF26] &= 0xFE  //Channel #1 On Flag Off
                            }
                        }
                        else {
                            channel1frequency &= 0x7FF
                            channel1SweepFault = true
                            channel1EnableCheck()
                            memory[0xFF26] &= 0xFE  //Channel #1 On Flag Off
                        }
                    }
                }
                channel1timeSweep = channel1lastTimeSweep
            }
            else {
                //Channel has sweep disabled and timer becomes a length counter:
                channel1SweepFault = true
                channel1EnableCheck()
            }
        }
    }
    func clockAudioEnvelope() {
        
        //Channel 1:
        if ( (channel1envelopeSweepsLast > -1)) {
            if ( (channel1envelopeSweeps > 0)) {
                channel1envelopeSweeps -= 1
            }
            else {
                if ( (!channel1envelopeType)) {
                    if ( (channel1envelopeVolume > 0)) {
                        channel1envelopeVolume -= 1
                        channel1envelopeSweeps = channel1envelopeSweepsLast
                        channel1OutputLevelCache()
                    }
                    else {
                        channel1envelopeSweepsLast = -1
                    }
                }
                else if ( (channel1envelopeVolume < 0xF)) {
                    channel1envelopeVolume += 1
                    channel1envelopeSweeps = channel1envelopeSweepsLast
                    channel1OutputLevelCache()
                }
                else {
                    channel1envelopeSweepsLast = -1
                }
            }
        }
        //Channel 2:
        if ( (channel2envelopeSweepsLast > -1)) {
            if ( (channel2envelopeSweeps > 0)) {
                channel2envelopeSweeps -= 1
            }
            else {
                if ( (!channel2envelopeType)) {
                    if ( (channel2envelopeVolume > 0)) {
                        channel2envelopeVolume -= 1
                        channel2envelopeSweeps = channel2envelopeSweepsLast
                        channel2OutputLevelCache()
                    }
                    else {
                        channel2envelopeSweepsLast = -1
                    }
                }
                else if ( (channel2envelopeVolume < 0xF)) {
                    channel2envelopeVolume += 1
                    channel2envelopeSweeps = channel2envelopeSweepsLast
                    channel2OutputLevelCache()
                }
                else {
                    channel2envelopeSweepsLast = -1
                }
            }
        }
        //Channel 4:
        if ( (channel4envelopeSweepsLast > -1)) {
            if ( (channel4envelopeSweeps > 0)) {
                channel4envelopeSweeps -= 1
            }
            else {
                if ( (!channel4envelopeType)) {
                    if ( (channel4envelopeVolume > 0)) {
                        channel4envelopeVolume -= 1
                        channel4currentVolume = channel4envelopeVolume << channel4VolumeShifter
                        channel4envelopeSweeps = channel4envelopeSweepsLast
                        channel4UpdateCache()
                    }
                    else {
                        channel4envelopeSweepsLast = -1
                    }
                }
                else if ( (channel4envelopeVolume < 0xF)) {
                    channel4envelopeVolume += 1
                    channel4currentVolume = channel4envelopeVolume << channel4VolumeShifter
                    channel4envelopeSweeps = channel4envelopeSweepsLast
                    channel4UpdateCache()
                }
                else {
                    channel4envelopeSweepsLast = -1
                }
            }
        }
    }
    func computeAudioChannels() {
        //Channel 1 counter:
        channel1FrequencyCounter -= 1
        if ( (channel1FrequencyCounter == 0)) {
            channel1FrequencyCounter = channel1FrequencyTracker
            channel1DutyTracker = (channel1DutyTracker + 1) & 0x7
            channel1OutputLevelTrimaryCache()
        }
        //Channel 2 counter:
        channel2FrequencyCounter -= 1
        if ( (channel2FrequencyCounter == 0)) {
            channel2FrequencyCounter = channel2FrequencyTracker
            channel2DutyTracker = (channel2DutyTracker + 1) & 0x7
            channel2OutputLevelTrimaryCache()
        }
        //Channel 3 counter:
        channel3Counter -= 1
        if ( (channel3Counter == 0)) {
            if ( (channel3canPlay)) {
                channel3lastSampleLookup = (channel3lastSampleLookup + 1) & 0x1F
            }
            channel3Counter = channel3FrequencyPeriod
            channel3UpdateCache()
        }
        //Channel 4 counter:
        channel4Counter -= 1
        if ( (channel4Counter == 0)) {
            channel4lastSampleLookup = (channel4lastSampleLookup + 1) & channel4BitRange
            channel4Counter = channel4FrequencyPeriod
            channel4UpdateCache()
        }
    }
    func channel1EnableCheck() {
        channel1Enabled = ((channel1consecutive || channel1totalLength > 0) && !channel1SweepFault && channel1canPlay)
        channel1OutputLevelSecondaryCache()
    }
    func channel1VolumeEnableCheck() {
        channel1canPlay = memory[0xFF12] > 7
        channel1EnableCheck()
        channel1OutputLevelSecondaryCache()
    }
    func channel1OutputLevelCache() {
      
        if(leftChannel1){
            channel1currentSampleLeft = channel1envelopeVolume 
        }else{
            channel1currentSampleLeft = 0
        }
        if(rightChannel1){
            channel1currentSampleRight = channel1envelopeVolume 
        }else{
            channel1currentSampleRight = 0
        }
        channel1OutputLevelSecondaryCache()
    }
    func channel1OutputLevelSecondaryCache() {
      
        if ( (channel1Enabled)) {
            channel1currentSampleLeftSecondary = channel1currentSampleLeft
            channel1currentSampleRightSecondary = channel1currentSampleRight
        }
        else {
            channel1currentSampleLeftSecondary = 0
            channel1currentSampleRightSecondary = 0
        }
        channel1OutputLevelTrimaryCache()
    }
    func channel1OutputLevelTrimaryCache() {
      
        if ( (channel1CachedDuty[channel1DutyTracker])) {
            channel1currentSampleLeftTrimary = channel1currentSampleLeftSecondary
            channel1currentSampleRightTrimary = channel1currentSampleRightSecondary
        }
        else {
            channel1currentSampleLeftTrimary = 0
            channel1currentSampleRightTrimary = 0
        }
        mixerOutputLevelCache()
    }
    func channel2EnableCheck() {
        channel2Enabled = ((channel2consecutive || channel2totalLength > 0) && channel2canPlay)
        channel2OutputLevelSecondaryCache()
    }
    func channel2VolumeEnableCheck() {
        channel2canPlay = (memory[0xFF17] > 7)
        channel2EnableCheck()
        channel2OutputLevelSecondaryCache()
    }
    func channel2OutputLevelCache() {
      
        if(leftChannel2){
            channel2currentSampleLeft = channel2envelopeVolume 
        }else{
            channel2currentSampleLeft =  0
        }
        if(rightChannel2){
            channel2currentSampleRight = channel2envelopeVolume 
        }else{
            channel2currentSampleRight =  0
        }
        channel2OutputLevelSecondaryCache()
    }
    func channel2OutputLevelSecondaryCache() {
       
        if ( (channel2Enabled)) {
            channel2currentSampleLeftSecondary = channel2currentSampleLeft
            channel2currentSampleRightSecondary = channel2currentSampleRight
        }
        else {
            channel2currentSampleLeftSecondary = 0
            channel2currentSampleRightSecondary = 0
        }
        channel2OutputLevelTrimaryCache()
    }
    func channel2OutputLevelTrimaryCache() {
       
        if ( (channel2CachedDuty[channel2DutyTracker])) {
            channel2currentSampleLeftTrimary = channel2currentSampleLeftSecondary
            channel2currentSampleRightTrimary = channel2currentSampleRightSecondary
        }
        else {
            channel2currentSampleLeftTrimary = 0
            channel2currentSampleRightTrimary = 0
        }
        mixerOutputLevelCache()
    }
    func channel3EnableCheck() {
        channel3Enabled = (/*channel3canPlay && */(channel3consecutive || channel3totalLength > 0))
        channel3OutputLevelSecondaryCache()
    }
    func channel3OutputLevelCache() {
        if(leftChannel3){
            channel3currentSampleLeft = cachedChannel3Sample 
        }else{
            channel3currentSampleLeft =  0
        }
        if(rightChannel3){
            channel3currentSampleRight = cachedChannel3Sample 
        }else{
            channel3currentSampleRight =  0
        }
        channel3OutputLevelSecondaryCache()
    }
    func channel3OutputLevelSecondaryCache() {
        if ( (channel3Enabled)) {
            channel3currentSampleLeftSecondary = channel3currentSampleLeft
            channel3currentSampleRightSecondary = channel3currentSampleRight
        }
        else {
            channel3currentSampleLeftSecondary = 0
            channel3currentSampleRightSecondary = 0
        }
        mixerOutputLevelCache()
    }
    func channel4EnableCheck() {
        channel4Enabled = ((channel4consecutive || channel4totalLength > 0) && channel4canPlay)
        channel4OutputLevelSecondaryCache()
    }
    func channel4VolumeEnableCheck() {
        channel4canPlay = (memory[0xFF21] > 7)
        channel4EnableCheck()
        channel4OutputLevelSecondaryCache()
    }
    func channel4OutputLevelCache() {
        if(leftChannel4){
            channel4currentSampleLeft = cachedChannel4Sample 
        }else{
            channel4currentSampleLeft =  0
        }
        if(rightChannel4){
            channel4currentSampleRight = cachedChannel4Sample 
        }else{
            channel4currentSampleRight =  0
        }
        channel4OutputLevelSecondaryCache()
    }
    func channel4OutputLevelSecondaryCache() {
        if ( (channel4Enabled)) {
            channel4currentSampleLeftSecondary = channel4currentSampleLeft
            channel4currentSampleRightSecondary = channel4currentSampleRight
        }
        else {
            channel4currentSampleLeftSecondary = 0
            channel4currentSampleRightSecondary = 0
        }
        mixerOutputLevelCache()
    }
    func mixerOutputLevelCache() {
        mixerOutputCache = ((((channel1currentSampleLeftTrimary + channel2currentSampleLeftTrimary + channel3currentSampleLeftSecondary + channel4currentSampleLeftSecondary) * VinLeftChannelMasterVolume) << 9) +
                            ((channel1currentSampleRightTrimary + channel2currentSampleRightTrimary + channel3currentSampleRightSecondary + channel4currentSampleRightSecondary) * VinRightChannelMasterVolume))
    }
    func channel3UpdateCache() {
        cachedChannel3Sample = channel3PCM[channel3lastSampleLookup] >> channel3patternType
        channel3OutputLevelCache()
    }
    func channel3WriteRAM( address: Int64,  data: Int64) {
        if ( (channel3canPlay)) {
            audioJIT()
            //address = channel3lastSampleLookup >> 1
        }
        memory[0xFF30 | address] = data
        var temp = address << 1
        channel3PCM[temp] = data >> 4
        channel3PCM[temp | 1] = data & 0xF
    }
    func channel4UpdateCache() {
        cachedChannel4Sample = noiseSampleTable[channel4currentVolume | channel4lastSampleLookup]
        channel4OutputLevelCache()
    }
    func run() {
        
        //The preprocessing before the actual iteration loop:
        if ( ((stopEmulator & 2) == 0)) {
            if ( ((stopEmulator & 1) == 1)) {
                if ( (!CPUStopped)) {
                    stopEmulator = 0
                    drewFrame = false
                    audioUnderrunAdjustment()
                    clockUpdate()      //RTC clocking.
                    if ( (!halt)) {
                        executeIteration()
                    }
                    else {            //Finish the HALT rundown execution.
                        CPUTicks = 0
                        calculateHALTPeriod()
                        if ( (halt)) {
                            updateCoreFull()
                        }
                        else {
                            executeIteration()
                        }
                    }
                    //Request the graphics target to be updated:
                    requestDraw()
                }
                else {
                    audioUnderrunAdjustment()
                    audioTicks += CPUCyclesTotal
                    audioJIT()
                    stopEmulator |= 1      //End current loop.
                }
            }
            else {
                //We can only get here if there was an internal error, but the loop was restarted.
                cout("Iterator restarted a faulted core.", 2)
                pausePlay()
            }
        }
    }
    func executeIteration() {
        
        //Iterate the interpreter loop:
        var opcodeToExecute = 0
        var timedTicks = 0
        while ( (stopEmulator == 0)) {
            //Int64errupt Arming:
            if(IRQEnableDelay == 1){
                IME = true
                checkIRQMatching();
                IRQEnableDelay -= 1
            }else if(IRQEnableDelay == 2){
                IRQEnableDelay -= 1
            }else{
                
            }
            //Is an IRQ set to fire?:
            if ( (IRQLineMatched > 0)) {
                //IME is true and and interrupt was matched:
                launchIRQ()
            }

            //Fetch the current opcode:
            opcodeToExecute = memoryReader[programCounter](this, programCounter)
            //Increment the program counter to the next instruction:
            programCounter = (programCounter + 1) & 0xFFFF
            //Check for the program counter quirk:
            if ( (skipPCIncrement)) {
                programCounter = (programCounter - 1) & 0xFFFF
                skipPCIncrement = false
            }
            //Get how many CPU cycles the current instruction counts for:
            CPUTicks = TICKTable[opcodeToExecute]
            //Execute the current instruction:
            OPCODE[opcodeToExecute](this)
            //Update the state (Inlined updateCoreFull manually here):
            //Update the clocking for the LCD emulation:
            LCDTicks += CPUTicks >> doubleSpeedShifter  //LCD Timing
            LCDCONTROL[actualScanLine](this)          //Scan Line and STAT Mode Control
            //Single-speed relative timing for A/V emulation:
            timedTicks = CPUTicks >> doubleSpeedShifter    //CPU clocking can be updated from the LCD handling.
            audioTicks += Float64(timedTicks)                //Audio Timing
            emulatorTicks += Float64(timedTicks)              //Emulator Timing
            //CPU Timers:
            DIVTicks += CPUTicks                //DIV Timing
            if ( (TIMAEnabled)) {                    //TIMA Timing
                timerTicks += CPUTicks
                while ( (timerTicks >= TACClocker)) {
                    timerTicks -= TACClocker
                    memory[0xFF05] += 1
                    if ( (memory[0xFF05] == 0x100)) {
                        memory[0xFF05] = memory[0xFF06]
                        interruptsRequested |= 0x4
                        checkIRQMatching()
                    }
                }
            }
            if ( (serialTimer > 0)) {                    //Serial Timing
                //IRQ Counter:
                serialTimer -= CPUTicks
                if ( (serialTimer <= 0)) {
                    interruptsRequested |= 0x8
                    checkIRQMatching()
                }
                //Bit Shit Counter:
                serialShiftTimer -= CPUTicks
                if ( serialShiftTimer <= 0) {
                    serialShiftTimer = serialShiftTimerAllocated
                    memory[0xFF01] = ((memory[0xFF01] << 1) & 0xFE) | 0x01  //We could shift in actual link data here if we were to implement such!!!
                }
            }
            //End of iteration routine:
            if ( (emulatorTicks >= CPUCyclesTotal)) {
                iterationEndRoutine()
            }
            // Start of code added for benchmarking:
            instructions += 1

            if ( (instructions > totalInstructions)) {
                iterationEndRoutine()
                stopEmulator |= 2
                checkFinalState()
            }
            // End of code added for benchmarking.
        }
    }
    func iterationEndRoutine() {
   
        if ( ((stopEmulator & 0x1) == 0)) {
            audioJIT()  //Make sure we at least output once per iteration.
            //Update DIV Alignment (Int64eger overflow safety):
            memory[0xFF04] = (memory[0xFF04] + (DIVTicks >> 8)) & 0xFF
            DIVTicks &= 0xFF
            //Update emulator flags:
            stopEmulator |= 1      //End current loop.
            emulatorTicks -= CPUCyclesTotal
            CPUCyclesTotalCurrent += CPUCyclesTotalRoundoff
            recalculateIterationClockLimit()
        }
    }
    func handleSTOP() {
    
        CPUStopped = true            //Stop CPU until joypad input changes.
        iterationEndRoutine()
        if ( (emulatorTicks < 0.0)) {
            audioTicks -= emulatorTicks
            audioJIT()
        }
    }
    func recalculateIterationClockLimit() {
       
        let endModulus = Float64(Int64(CPUCyclesTotalCurrent) % 4)
        CPUCyclesTotal = CPUCyclesTotalBase + CPUCyclesTotalCurrent - endModulus
        CPUCyclesTotalCurrent = endModulus
    }
    func scanLineMode2() {  //OAM Search Period
        if ( (STATTracker != 1)) {
            if ( (mode2TriggerSTAT)) {
                interruptsRequested |= 0x2
                checkIRQMatching()
            }
            STATTracker = 1
            modeSTAT = 2
        }
    }
    func scanLineMode3() {  //Scan Line Drawing Period
        if ( (modeSTAT != 3)) {
            if ( (STATTracker == 0 && mode2TriggerSTAT)) {
                interruptsRequested |= 0x2
                checkIRQMatching()
            }
            STATTracker = 1
            modeSTAT = 3
        }
    }
    func scanLineMode0() {  //Horizontal Blanking Period
        if ( (modeSTAT != 0)) {
            if ( (STATTracker != 2)) {
                if ( (STATTracker == 0)) {
                    if ( (mode2TriggerSTAT)) {
                        interruptsRequested |= 0x2
                        checkIRQMatching()
                    }
                    modeSTAT = 3
                }
                incrementScanLineQueue()
                updateSpriteCount(actualScanLine)
                STATTracker = 2
            }
            if ( (LCDTicks >= spriteCount)) {
                if ( (hdmaRunning)) {
                    executeHDMA()
                }
                if ( (mode0TriggerSTAT)) {
                    interruptsRequested |= 0x2
                    checkIRQMatching()
                }
                STATTracker = 3
                modeSTAT = 0
            }
        }
    }
    func clocksUntilLYCMatch() : Int64 {
   
        if ( (memory[0xFF45] != 0)) {
            if ( memory[0xFF45] > actualScanLine) {
                return 456 * (memory[0xFF45] - actualScanLine)
            }
            return 456 * (154 - actualScanLine + memory[0xFF45])
        }
        if(actualScanLine == 153 && memory[0xFF44] == 0){
            return (456 * (154)) + 8
        }else{
            return (456 * ((153 - actualScanLine))) + 8
        }
    }
    func clocksUntilMode0() : Int64 {

        match ( (modeSTAT)) {
        case 0=>
            if ( (actualScanLine == 143)) {
                updateSpriteCount(0)
                return spriteCount + 5016
            }
            updateSpriteCount(actualScanLine + 1)
            return spriteCount + 456
        case 2=>
            updateSpriteCount(actualScanLine)
            return spriteCount
        case 3=>
            updateSpriteCount(actualScanLine)
            return spriteCount
        case 1=>
            updateSpriteCount(0)
            return spriteCount + (456 * (154 - actualScanLine))
        case _ =>
            return 0
        }
    }
    func updateSpriteCount( line: Int64) {
        spriteCount = 252
        if ( (cGBC && gfxSpriteShow)) {                    //Is the window enabled and are we in CGB mode?
            let lineAdjusted = line + 0x10
            var yoffset = 0
            var yCap = 0x10
            if(gfxSpriteNormalHeight){
                yCap = 0x8
            }
            var OAMAddress = 0xFE00
            while ( OAMAddress < 0xFEA0 && spriteCount < 312) {
                yoffset = lineAdjusted - memory[OAMAddress]
                if ( (yoffset > -1 && yoffset < yCap)) {
                    spriteCount += 6
                }
                OAMAddress += 4
            }
        }
    }
    func matchLYC() {  //LYC Register Compare

        if ( (memory[0xFF44] == memory[0xFF45])) {
            memory[0xFF41] |= 0x04
            if ( (LYCMatchTriggerSTAT)) {
                interruptsRequested |= 0x2
                checkIRQMatching()
            }
        }
        else {
            memory[0xFF41] &= 0x7B
        }
    }
    func updateCore() {
   
        //Update the clocking for the LCD emulation:
        LCDTicks += CPUTicks >> doubleSpeedShifter  //LCD Timing
        LCDCONTROL[actualScanLine](this)          //Scan Line and STAT Mode Control
        //Single-speed relative timing for A/V emulation:
        let timedTicks = CPUTicks >> doubleSpeedShifter  //CPU clocking can be updated from the LCD handling.
        audioTicks += Float64(timedTicks)                //Audio Timing
        emulatorTicks += Float64(timedTicks)              //Emulator Timing
        //CPU Timers:
        DIVTicks += CPUTicks                //DIV Timing
        if ( (TIMAEnabled)) {                    //TIMA Timing
            timerTicks += CPUTicks
            while ( (timerTicks >= TACClocker)) {
                timerTicks -= TACClocker
                memory[0xFF05] += 1
                if ( (memory[0xFF05] == 0x100)) {
                    memory[0xFF05] = memory[0xFF06]
                    interruptsRequested |= 0x4
                    checkIRQMatching()
                }
            }
        }
        if ( (serialTimer > 0)) {                    //Serial Timing
            //IRQ Counter:
            serialTimer -= CPUTicks
            if ( (serialTimer <= 0)) {
                interruptsRequested |= 0x8
                checkIRQMatching()
            }
            //Bit Shit Counter:
            serialShiftTimer -= CPUTicks
            if (serialShiftTimer <= 0) {
                serialShiftTimer = serialShiftTimerAllocated
                memory[0xFF01] = ((memory[0xFF01] << 1) & 0xFE) | 0x01  //We could shift in actual link data here if we were to implement such!!!
            }
        }
    }
    func updateCoreFull() {
    
        //Update the state machine:
        updateCore()
        //End of iteration routine:
        if ( (emulatorTicks >= CPUCyclesTotal)) {
            iterationEndRoutine()
        }
    }
    func initializeLCDController() {
       
        //Display on hanlding:
        var line = 0
        while ( (line < 154)) {
            if ( (line < 143)) {
                //We're on a normal scan line:
                LINECONTROL[line] = { parentObj =>
                    if ( (parentObj.LCDTicks < 80)) {
                        parentObj.scanLineMode2()
                    }
                    else if ( (parentObj.LCDTicks < 252)) {
                        parentObj.scanLineMode3()
                    }
                    else if ( (parentObj.LCDTicks < 456)) {
                        parentObj.scanLineMode0()
                    }
                    else {
                        //We're on a new scan line:
                        parentObj.LCDTicks -= 456
                        if ( (parentObj.STATTracker != 3)) {
                            //Make sure the mode 0 handler was run at least once per scan line:
                            if ( (parentObj.STATTracker != 2)) {
                                if ( (parentObj.STATTracker == 0 && parentObj.mode2TriggerSTAT)) {
                                    parentObj.interruptsRequested |= 0x2
                                }
                                parentObj.incrementScanLineQueue()
                            }
                            if ( (parentObj.hdmaRunning)) {
                                parentObj.executeHDMA()
                            }
                            if ( (parentObj.mode0TriggerSTAT)) {
                                parentObj.interruptsRequested |= 0x2
                            }
                        }
                        //Update the scanline registers and assert the LYC counter:
                        parentObj.memory[0xFF44] += 1
                        parentObj.actualScanLine = parentObj.memory[0xFF44]
                        //Perform a LYC counter assert:
                        if ( (parentObj.actualScanLine == parentObj.memory[0xFF45])) {
                            parentObj.memory[0xFF41] |= 0x04
                            if ( (parentObj.LYCMatchTriggerSTAT)) {
                                parentObj.interruptsRequested |= 0x2
                            }
                        }
                        else {
                            parentObj.memory[0xFF41] &= 0x7B
                        }
                        parentObj.checkIRQMatching()
                        //Reset our mode contingency variables:
                        parentObj.STATTracker = 0
                        parentObj.modeSTAT = 2
                        parentObj.LINECONTROL[parentObj.actualScanLine](parentObj)  //Scan Line and STAT Mode Control.
                    }
                }
            }
            else if ( (line == 143)) {
                //We're on the last visible scan line of the LCD screen:
                LINECONTROL[143] = { parentObj =>
                    if ( (parentObj.LCDTicks < 80)) {
                        parentObj.scanLineMode2()
                    }
                    else if ( (parentObj.LCDTicks < 252)) {
                        parentObj.scanLineMode3()
                    }
                    else if ( (parentObj.LCDTicks < 456)) {
                        parentObj.scanLineMode0()
                    }
                    else {
                        //Starting V-Blank:
                        //Just finished the last visible scan line:
                        parentObj.LCDTicks -= 456
                        if ( (parentObj.STATTracker != 3)) {
                            //Make sure the mode 0 handler was run at least once per scan line:
                            if ( (parentObj.STATTracker != 2)) {
                                if ( (parentObj.STATTracker == 0 && parentObj.mode2TriggerSTAT)) {
                                    parentObj.interruptsRequested |= 0x2
                                }
                                parentObj.incrementScanLineQueue()
                            }
                            if ( (parentObj.hdmaRunning)) {
                                parentObj.executeHDMA()
                            }
                            if ( (parentObj.mode0TriggerSTAT)) {
                                parentObj.interruptsRequested |= 0x2
                            }
                        }
                        //Update the scanline registers and assert the LYC counter:
                        parentObj.actualScanLine = 144
                        parentObj.memory[0xFF44] = 144
                        //Perform a LYC counter assert:
                        if ( (parentObj.memory[0xFF45] == 144)) {
                            parentObj.memory[0xFF41] |= 0x04
                            if ( (parentObj.LYCMatchTriggerSTAT)) {
                                parentObj.interruptsRequested |= 0x2
                            }
                        }
                        else {
                            parentObj.memory[0xFF41] &= 0x7B
                        }
                        //Reset our mode contingency variables:
                        parentObj.STATTracker = 0
                        //Update our state for v-blank:
                        parentObj.modeSTAT = 1
                        if(parentObj.mode1TriggerSTAT){
                            parentObj.interruptsRequested |=  0x3 
                        }else{
                            parentObj.interruptsRequested |=  0x1
                        }
                        parentObj.checkIRQMatching()
                        //Attempt to blit out to our canvas:
                        if ( (parentObj.drewBlank == 0)) {
                            //Ensure JIT framing alignment:
                            if ( (parentObj.totalLinesPassed < 144 || (parentObj.totalLinesPassed == 144 && parentObj.midScanlineOffset > -1))) {
                                //Make sure our gfx are up-to-date:
                                parentObj.graphicsJITVBlank()
                                //Draw the frame:
                                parentObj.prepareFrame()
                            }
                        }
                        else {
                            //LCD off takes at least 2 frames:
                            parentObj.drewBlank -= 1
                        }
                        parentObj.LINECONTROL[144](parentObj)  //Scan Line and STAT Mode Control.
                    }
                }
            }
            else if ( (line < 153)) {
                //In VBlank
                LINECONTROL[line] = { parentObj =>
                    if ( (parentObj.LCDTicks >= 456)) {
                        //We're on a new scan line:
                        parentObj.LCDTicks -= 456
                        parentObj.memory[0xFF44] += 1
                        parentObj.actualScanLine = parentObj.memory[0xFF44]
                        //Perform a LYC counter assert:
                        if ( (parentObj.actualScanLine == parentObj.memory[0xFF45])) {
                            parentObj.memory[0xFF41] |= 0x04
                            if ( (parentObj.LYCMatchTriggerSTAT)) {
                                parentObj.interruptsRequested |= 0x2
                                parentObj.checkIRQMatching()
                            }
                        }
                        else {
                            parentObj.memory[0xFF41] &= 0x7B
                        }
                        parentObj.LINECONTROL[parentObj.actualScanLine](parentObj)  //Scan Line and STAT Mode Control.
                    }
                }
            }
            else {
                //VBlank Ending (We're on the last actual scan line)
                LINECONTROL[153] = { parentObj =>
                    if ( (parentObj.LCDTicks >= 8)) {
                        if ( (parentObj.STATTracker != 4 && parentObj.memory[0xFF44] == 153)) {
                            parentObj.memory[0xFF44] = 0  //LY register resets to 0 early.
                            //Perform a LYC counter assert:
                            if ( (parentObj.memory[0xFF45] == 0)) {
                                parentObj.memory[0xFF41] |= 0x04
                                if ( (parentObj.LYCMatchTriggerSTAT)) {
                                    parentObj.interruptsRequested |= 0x2
                                    parentObj.checkIRQMatching()
                                }
                            }
                            else {
                                parentObj.memory[0xFF41] &= 0x7B
                            }
                            parentObj.STATTracker = 4
                        }
                        if ( (parentObj.LCDTicks >= 456)) {
                            //We reset back to the beginning:
                            parentObj.LCDTicks -= 456
                            parentObj.STATTracker = 0
                            parentObj.actualScanLine = 0
                            parentObj.LINECONTROL[0](parentObj)  //Scan Line and STAT Mode Control.
                        }
                    }
                }
            }
            line += 1
        }
    }
    func DisplayShowOff() {
        
        if ( (drewBlank == 0)) {
            //Output a blank screen to the output framebuffer:
            clearFrameBuffer()
            drewFrame = true
        }
        drewBlank = 2
    }
    func executeHDMA() {
        DMAWrite(1)
        if ( (halt)) {
            if ((LCDTicks - spriteCount) < ((4 >> doubleSpeedShifter) | 0x20)){
                //HALT clocking correction:
                CPUTicks = 4 + ((0x20 + spriteCount) << doubleSpeedShifter)
                LCDTicks = spriteCount + ((4 >> doubleSpeedShifter) | 0x20)
            }
        }
        else {
            LCDTicks += (4 >> doubleSpeedShifter) | 0x20      //LCD Timing Update For HDMA.
        }
        if ( (memory[0xFF55] == 0)) {
            hdmaRunning = false
            memory[0xFF55] = 0xFF  //Transfer completed ("Hidden last step," since some ROMs don't imply this, but most do).
        }
        else {
            memory[0xFF55] -= 1
        }
    }
    func clockUpdate() {
    
        if ( (cTIMER)) {
            let dateObj = new_Date() // The line is changed for benchmarking.
            let newTime = dateObj.getTime()
            let timeElapsed = newTime - lastIteration  //Get the numnber of milliseconds since this last executed.
            lastIteration = newTime
            if ( (cTIMER && !RTCHALT)) {
                //Update the MBC3 RTC:
                RTCSeconds += timeElapsed / 1000
                while ( (RTCSeconds >= 60)) {  //System can stutter, so the seconds difference can get large, thus the "while (".
                    RTCSeconds -= 60
                    RTCMinutes += 1
                    if ( (RTCMinutes >= 60)) {
                        RTCMinutes -= 60
                        RTCHours += 1
                        if ( (RTCHours >= 24)) {
                            RTCHours -= 24
                            RTCDays += 1
                            if ( (RTCDays >= 512)) {
                                RTCDays -= 512
                                RTCDayOverFlow = true
                            }
                        }
                    }
                }
            }
        }
    }
    func prepareFrame() {
        //Copy the internal frame buffer to the output buffer:
        swizzleFrameBuffer()
        drewFrame = true
    }
    func requestDraw() {

        if ( (drewFrame)) {
            dispatchDraw()
        }
    }
    func dispatchDraw() {

        let canvasRGBALength = offscreenRGBCount
        if ( (canvasRGBALength > 0)) {
            //We actually updated the graphics internally, so copy out:
            var frameBuffer =  swizzledFrame
            var canvasData = canvasBuffer.getOrThrow().data
            var bufferIndex = 0
            var canvasIndex = 0
            while ( canvasIndex < canvasRGBALength) {
                canvasData[canvasIndex] = frameBuffer[bufferIndex]
                bufferIndex++
                canvasIndex++
                canvasData[canvasIndex] = frameBuffer[bufferIndex]
                bufferIndex++
                canvasIndex++
                canvasData[canvasIndex] = frameBuffer[bufferIndex]
                bufferIndex++
                canvasIndex++
                canvasIndex += 1
            }
            graphicsBlit()
        }
    }
    func swizzleFrameBuffer() {
        
        //Convert our dirty 24-bit (24-bit, with internal render flags above it) framebuffer to an 8-bit buffer with separate indices for the RGB channels:
        let frameBuffer = frameBuffer
        var bufferIndex = 0
        var canvasIndex = 0
        while ( canvasIndex < 69120) {
            swizzledFrame[canvasIndex] = (frameBuffer[bufferIndex] >> 16) & 0xFF    //Red
            canvasIndex++
            swizzledFrame[canvasIndex] = (frameBuffer[bufferIndex] >> 8) & 0xFF    //Green
            canvasIndex++
            swizzledFrame[canvasIndex] = frameBuffer[bufferIndex] & 0xFF      //Blue
            bufferIndex++
            canvasIndex++
        }
    }
    func clearFrameBuffer() {
        
        var bufferIndex = 0
        if ( (cGBC || colorizedGBPalettes)) {
            while ( (bufferIndex < 69120)) {
                swizzledFrame[bufferIndex] = 248
                bufferIndex++
            }
        }
        else {
            while ( (bufferIndex < 69120)) {
                swizzledFrame[bufferIndex] = 239
                bufferIndex++
                swizzledFrame[bufferIndex] = 255
                bufferIndex++
                swizzledFrame[bufferIndex] = 222
                bufferIndex++
            }
        }
    }
    func resizeFrameBuffer() : Array<Int64> {
        
        
        var t1 : Array<Float32> = []

        if((resizer.getOrThrow().resize(t1) as Array<Int64>).isSome()){
            var t2 = resizer.getOrThrow().resize(t1)
            var t3 = Array<Int64>(t2.size,repeat:0)
            for(i in 0..t2.size){
                t3[i] = Int64(t2[i])
            }
            return t3
        }else{
            return []
        }
    }
    func compileResizeFrameBufferFunction() {
        
        if ( (offscreenRGBCount > 0)) {
            resizer = Resize(widthOriginal:160,heightOriginal: 144, targetWidth:offscreenWidth, targetHeight:offscreenHeight, blendAlpha:false, interpolationPass:true)
        }
    }
    func renderScanLine( scanlineToRender: Int64) {
        pixelStart = scanlineToRender * 160
        if ( (bgEnabled)) {
            pixelEnd = 160
            BGLayerRender.getOrThrow()(scanlineToRender)
            WindowLayerRender.getOrThrow()(scanlineToRender)
        }
        else {
            let pixelLine = (scanlineToRender + 1) * 160
            var defaultColor =  0xEFFFDE
            if(cGBC || colorizedGBPalettes) {
                defaultColor = 0xF8F8F8 
            }
            var pixelPosition = (scanlineToRender * 160) + currentX
            while ( pixelPosition < pixelLine) {
                frameBuffer[pixelPosition] = defaultColor
                pixelPosition += 1
            }
        }
        SpriteLayerRender.getOrThrow()(scanlineToRender)
        currentX = 0
        midScanlineOffset = -1
    }
    func renderMidScanLine() {
        if ( (actualScanLine < 144 && modeSTAT == 3)) {
            //TODO: Get this accurate:
            if ( (midScanlineOffset == -1)) {
                midScanlineOffset = backgroundX & 0x7
            }
            if ( (LCDTicks >= 82)) {
                pixelEnd = LCDTicks - 74
                pixelEnd = min(pixelEnd - midScanlineOffset - (pixelEnd % 0x8), 160)
                if ( (bgEnabled)) {
                    pixelStart = lastUnrenderedLine * 160
                    BGLayerRender.getOrThrow()(lastUnrenderedLine)
                    WindowLayerRender.getOrThrow()(lastUnrenderedLine)
                    //TODO: Do midscanline JIT for sprites...
                }
                else {
                    let pixelLine = (lastUnrenderedLine * 160) + pixelEnd
                    var defaultColor =  0xEFFFDE
                    if(cGBC || colorizedGBPalettes){
                        defaultColor =  0xF8F8F8 
                    }
                    var pixelPosition = (lastUnrenderedLine * 160) + currentX
                    while ( pixelPosition < pixelLine) {
                        frameBuffer[pixelPosition] = defaultColor
                        pixelPosition += 1
                    }
                }
                currentX = pixelEnd
            }
        }
    }
    func initializeModeSpecificArrays(){
        
        if(LCDisOn){
            LCDCONTROL = LINECONTROL 
        }else{
            LCDCONTROL = DISPLAYOFFCONTROL
        }
        if ( (cGBC)) {
            gbcOBJRawPalette =  Array<Int64>(0x40, repeat:0)
            gbcBGRawPalette = Array<Int64>(0x40, repeat:0)
            gbcOBJPalette = Array<Int64>(0x20, repeat:0x1000000)
            gbcBGPalette = Array<Int64>(0x40, repeat:0)
            BGCHRBank2.array = Array<Int64>(0x800, repeat:0)
            if(currVRAMBank > 0){
                BGCHRCurrentBank =  BGCHRBank2 
            }else{
                BGCHRCurrentBank =   BGCHRBank1
            }
            tileCache = generateCacheArray(0xF80)
        }
        else {
            gbOBJPalette = Array<Int64>(8, repeat:0)
            gbBGPalette = Array<Int64>(4, repeat:0)
            BGPalette = gbBGPalette
            OBJPalette = gbOBJPalette
            tileCache = generateCacheArray(0x700)
            sortBuffer = Array<Int64>(0x100, repeat:0)
            OAMAddressCache =  Array<Int64>(10,repeat: 0)
        }
        renderPathBuild()
    }
    func GBCtoGBModeAdjust() {
      
        cout("Stepping down from GBC mode.", 0)
        BGCHRBank2.array = []
        VRAM = []
        GBCMemory = []
        BGCHRCurrentBank.getOrThrow().array = []
        tileCache = ArrayList<ArrayObject>()
        if ( (settings[4] as Bool).getOrThrow()) {
            gbBGColorizedPalette =  Array<Int64>(4,repeat: 0)
            gbOBJColorizedPalette =  Array<Int64>(8, repeat:0)
            cachedBGPaletteConversion =  Array<Int64>(4, repeat:0)
            cachedOBJPaletteConversion =Array<Int64>(8, repeat:0)
            BGPalette = gbBGColorizedPalette
            OBJPalette = gbOBJColorizedPalette
            gbOBJPalette = []
            gbBGPalette = []
            getGBCColor()
        }
        else {
            gbOBJPalette =  Array<Int64>(8, repeat:0)
            gbBGPalette =  Array<Int64>(4, repeat:0)
            BGPalette = gbBGPalette
            OBJPalette = gbOBJPalette
        }
        sortBuffer = Array<Int64>(0x100, repeat:0)
        OAMAddressCache =  Array<Int64>(10, repeat:0)
        renderPathBuild()
        memoryReadJumpCompile()
        memoryWriteJumpCompile()
    }
    func renderPathBuild() {
    
        if ( (!cGBC)) {
            BGLayerRender = BGGBLayerRender
            WindowLayerRender = WindowGBLayerRender
            SpriteLayerRender = SpriteGBLayerRender
        }
        else {
            priorityFlaggingPathRebuild()
            SpriteLayerRender = SpriteGBCLayerRender
        }
    }
    func priorityFlaggingPathRebuild() {
    
        if ( (BGPriorityEnabled)) {
            BGLayerRender = BGGBCLayerRender
            WindowLayerRender = WindowGBCLayerRender
        }
        else {
            BGLayerRender = BGGBCLayerRenderNoPriorityFlagging
            WindowLayerRender = WindowGBCLayerRenderNoPriorityFlagging
        }
    }
    func RGBTint( value: Int64) : Int64 {
        //Adjustment for the GBC's tinting (According to Gambatte):
        let r = value & 0x1F
        let g = (value >> 5) & 0x1F
        let b = (value >> 10) & 0x1F
        return ((r * 13 + g * 2 + b) >> 1) << 16 | (g * 3 + b) << 9 | (r * 3 + g * 2 + b * 11) >> 1
    }
    func updateGBColorizedBGPalette( data: Int64) {
    
        //GB colorization:
        gbBGColorizedPalette[0] = cachedBGPaletteConversion[data & 0x03] | 0x2000000
        gbBGColorizedPalette[1] = cachedBGPaletteConversion[(data >> 2) & 0x03]
        gbBGColorizedPalette[2] = cachedBGPaletteConversion[(data >> 4) & 0x03]
        gbBGColorizedPalette[3] = cachedBGPaletteConversion[data >> 6]
    }
    func updateGBColorizedOBJPalette( index: Int64,  data: Int64) {
  
        //GB colorization:
        gbOBJColorizedPalette[index | 1] = cachedOBJPaletteConversion[index | ((data >> 2) & 0x03)]
        gbOBJColorizedPalette[index | 2] = cachedOBJPaletteConversion[index | ((data >> 4) & 0x03)]
        gbOBJColorizedPalette[index | 3] = cachedOBJPaletteConversion[index | (data >> 6)]
    }
    func getGBCColor() {
     
        //GBC Colorization of DMG ROMs:
        //BG
        var counter: Int64 = 0
        while ( counter < 4) {
            let adjustedIndex = counter << 1
            //BG
            cachedBGPaletteConversion[counter] = RGBTint((gbcBGRawPalette[adjustedIndex | 1] << 8) | gbcBGRawPalette[adjustedIndex])
            //OBJ 1
            cachedOBJPaletteConversion[counter] = RGBTint((gbcOBJRawPalette[adjustedIndex | 1] << 8) | gbcOBJRawPalette[adjustedIndex])
            counter += 1
        }
        //OBJ 2
        counter = 4
        while ( counter < 8) {
            let adjustedIndex = counter << 1
            cachedOBJPaletteConversion[counter] = RGBTint((gbcOBJRawPalette[adjustedIndex | 1] << 8) | gbcOBJRawPalette[adjustedIndex])
            counter += 1
        }
        //Update the palette entries:
        updateGBBGPalette = updateGBColorizedBGPalette
        updateGBOBJPalette = updateGBColorizedOBJPalette
        updateGBBGPalette.getOrThrow()(memory[0xFF47])
        updateGBOBJPalette.getOrThrow()(0, memory[0xFF48])
        updateGBOBJPalette.getOrThrow()(1, memory[0xFF49])
        colorizedGBPalettes = true
    }
    func updateGBRegularBGPalette( data: Int64) {
   
        gbBGPalette[0] = colors[data & 0x03] | 0x2000000
        gbBGPalette[1] = colors[(data >> 2) & 0x03]
        gbBGPalette[2] = colors[(data >> 4) & 0x03]
        gbBGPalette[3] = colors[data >> 6]
    }
    func updateGBRegularOBJPalette( index: Int64,  data: Int64) {
     
        gbOBJPalette[index | 1] = colors[(data >> 2) & 0x03]
        gbOBJPalette[index | 2] = colors[(data >> 4) & 0x03]
        gbOBJPalette[index | 3] = colors[data >> 6]
    }
    func updateGBCBGPalette( indexTemp: Int64,  dataTemp: Int64) {
        var index = indexTemp
        var data = dataTemp
        if ( (gbcBGRawPalette[index] != data)) {
            midScanLineJIT()
            //Update the color palette for BG tiles since it changed:
            gbcBGRawPalette[index] = data
            if ( ((index & 0x06) == 0)) {
                //Palette 0 (Special tile Priority stuff)
                data = 0x2000000 | RGBTint((gbcBGRawPalette[index | 1] << 8) | gbcBGRawPalette[index & 0x3E])
                index >>= 1
                gbcBGPalette[index] = data
                gbcBGPalette[0x20 | index] = 0x1000000 | data
            }
            else {
                //Regular Palettes (No special crap)
                data = RGBTint((gbcBGRawPalette[index | 1] << 8) | gbcBGRawPalette[index & 0x3E])
                index >>= 1
                gbcBGPalette[index] = data
                gbcBGPalette[0x20 | index] = 0x1000000 | data
            }
        }
    }
    func updateGBCOBJPalette( index: Int64,  data: Int64) {
        if ( (gbcOBJRawPalette[index] != data)) {
            //Update the color palette for OBJ tiles since it changed:
            gbcOBJRawPalette[index] = data
            if ( ((index & 0x06) > 0)) {
                //Regular Palettes (No special crap)
                midScanLineJIT()
                gbcOBJPalette[index >> 1] = 0x1000000 | RGBTint((gbcOBJRawPalette[index | 1] << 8) | gbcOBJRawPalette[index & 0x3E])
            }
        }
    }
    func BGGBLayerRender( scanlineToRender: Int64) {
      
        let scrollYAdjusted = (backgroundY + scanlineToRender) & 0xFF            //The line of the BG we're at.
        let tileYLine = (scrollYAdjusted & 7) << 3
        var tileYDown = gfxBackgroundCHRBankPosition | ((scrollYAdjusted & 0xF8) << 2)  //The row of cached tiles we're fetching from.
        var scrollXAdjusted = (backgroundX + currentX) & 0xFF            //The scroll amount of the BG.
        var pixelPosition = pixelStart + currentX                  //Current pixel we're working on.
        var pixelPositionEnd = pixelStart + ( pixelEnd) 
        if(gfxWindowDisplay && (scanlineToRender - windowY) >= 0){
            pixelPositionEnd = pixelStart + (min(max(windowX, 0) + currentX, pixelEnd) )
        }
        var tileNumber = tileYDown + (scrollXAdjusted >> 3)
        var chrCode = BGCHRBank1.array[tileNumber]
        if ( (chrCode < gfxBackgroundBankOffset)) {
            chrCode |= 0x100
        }
        var tile = tileCache[chrCode].array
        var texel = (scrollXAdjusted & 0x7)
        while ( texel < 8 && pixelPosition < pixelPositionEnd && scrollXAdjusted < 0x100) {
            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine | texel]]
            texel++
            pixelPosition++
            scrollXAdjusted += 1
        }
        var scrollXAdjustedAligned = min(pixelPositionEnd - pixelPosition, 0x100 - scrollXAdjusted) >> 3
        scrollXAdjusted += scrollXAdjustedAligned << 3
        scrollXAdjustedAligned += tileNumber
        while ( (tileNumber < scrollXAdjustedAligned)) {
            tileNumber += 1
            chrCode = BGCHRBank1.array[tileNumber]
            if ( (chrCode < gfxBackgroundBankOffset)) {
                chrCode |= 0x100
            }
            tile = tileCache[chrCode].array
            texel = tileYLine
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = BGPalette[tile[texel]]
            pixelPosition++
        }
        if ( (pixelPosition < pixelPositionEnd)) {
            if ( (scrollXAdjusted < 0x100)) {
                tileNumber += 1
                chrCode = BGCHRBank1.array[tileNumber]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                tile = tileCache[chrCode].array
                texel = tileYLine - 1
                while ( pixelPosition < pixelPositionEnd && scrollXAdjusted < 0x100) {
                    texel += 1
                    frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                    pixelPosition++
                    scrollXAdjusted += 1
                }
            }
            scrollXAdjustedAligned = ((pixelPositionEnd - pixelPosition) >> 3) + tileYDown
            while ( (tileYDown < scrollXAdjustedAligned)) {
                chrCode = BGCHRBank1.array[tileYDown]
                pixelPosition++
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                tile = tileCache[chrCode].array
                texel = tileYLine
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                pixelPosition++
            }
            if ( (pixelPosition < pixelPositionEnd)) {
                chrCode = BGCHRBank1.array[tileYDown]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                tile = tileCache[chrCode].array
                if(pixelPositionEnd - pixelPosition == 7){
                    frameBuffer[pixelPosition + 6] = BGPalette[tile[tileYLine | 6]]
                    frameBuffer[pixelPosition + 5] = BGPalette[tile[tileYLine | 5]]
                    frameBuffer[pixelPosition + 4] = BGPalette[tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 6){
                    frameBuffer[pixelPosition + 5] = BGPalette[tile[tileYLine | 5]]
                    frameBuffer[pixelPosition + 4] = BGPalette[tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 5){
                    frameBuffer[pixelPosition + 4] = BGPalette[tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 4){
                    frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 3){
                    frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 2){
                    frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 1){
                    frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                }
            }
        }
    }
    func BGGBCLayerRender( scanlineToRender: Int64) {
        let scrollYAdjusted = (backgroundY + scanlineToRender) & 0xFF            //The line of the BG we're at.
        let tileYLine = (scrollYAdjusted & 7) << 3
        var tileYDown = gfxBackgroundCHRBankPosition | ((scrollYAdjusted & 0xF8) << 2)  //The row of cached tiles we're fetching from.
        var scrollXAdjusted = (backgroundX + currentX) & 0xFF            //The scroll amount of the BG.
        var pixelPosition = pixelStart + currentX                  //Current pixel we're working on.
        var pixelPositionEnd = pixelStart + ( pixelEnd)
        if(gfxWindowDisplay && (scanlineToRender - windowY) >= 0){
            pixelPositionEnd = pixelStart + (  min(max(windowX, 0) + currentX, pixelEnd) ) 
        }
        //Make sure we do at most 160 pixels a scanline.
        var tileNumber = tileYDown + (scrollXAdjusted >> 3)
        var chrCode = BGCHRBank1.array[tileNumber]
        if ( (chrCode < gfxBackgroundBankOffset)) {
            chrCode |= 0x100
        }
        var attrCode = BGCHRBank2.array[tileNumber]
        var tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
        var palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
        var texel: Int64 = (scrollXAdjusted & 0x7)
        while ( texel < 8 && pixelPosition < pixelPositionEnd && scrollXAdjusted < 0x100) {
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine | texel]]
            texel++
            pixelPosition++
            scrollXAdjusted += 1
        }
        var scrollXAdjustedAligned = min(pixelPositionEnd - pixelPosition, 0x100 - scrollXAdjusted) >> 3
        scrollXAdjusted += scrollXAdjustedAligned << 3
        scrollXAdjustedAligned += tileNumber
        while ( (tileNumber < scrollXAdjustedAligned)) {
            tileNumber += 1
            chrCode = BGCHRBank1.array[tileNumber]
            if ( (chrCode < gfxBackgroundBankOffset)) {
                chrCode |= 0x100
            }
            attrCode = BGCHRBank2.array[tileNumber]
            tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
            palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
            texel = tileYLine
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            pixelPosition++
        }
        if ( (pixelPosition < pixelPositionEnd)) {
            if ( (scrollXAdjusted < 0x100)) {
                tileNumber += 1
                chrCode = BGCHRBank1.array[tileNumber]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                attrCode = BGCHRBank2.array[tileNumber]
                tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
                texel = tileYLine - 1
                while ( pixelPosition < pixelPositionEnd && scrollXAdjusted < 0x100) {
                    texel += 1
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                    pixelPosition++
                    scrollXAdjusted += 1
                }
            }
            scrollXAdjustedAligned = ((pixelPositionEnd - pixelPosition) >> 3) + tileYDown
            while ( (tileYDown < scrollXAdjustedAligned)) {
                chrCode = BGCHRBank1.array[tileYDown]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                attrCode = BGCHRBank2.array[tileYDown]
                tileYDown++
                tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
                texel = tileYLine
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                pixelPosition++
            }
            if ( (pixelPosition < pixelPositionEnd)) {
                chrCode = BGCHRBank1.array[tileYDown]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                attrCode = BGCHRBank2.array[tileYDown]
                tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
                if(pixelPositionEnd - pixelPosition == 7){
                    frameBuffer[pixelPosition + 6] = gbcBGPalette[palette | tile[tileYLine | 6]]
                    frameBuffer[pixelPosition + 5] = gbcBGPalette[palette | tile[tileYLine | 5]]
                    frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 6){
                    frameBuffer[pixelPosition + 5] = gbcBGPalette[palette | tile[tileYLine | 5]]
                    frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]

                }
                if(pixelPositionEnd - pixelPosition == 5){
                    frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 4){
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 3){
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 2){
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 1){
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
            }
        }
    }
    func BGGBCLayerRenderNoPriorityFlagging( scanlineToRender: Int64) {
        
        let scrollYAdjusted = (backgroundY + scanlineToRender) & 0xFF            //The line of the BG we're at.
        let tileYLine = (scrollYAdjusted & 7) << 3
        var tileYDown = gfxBackgroundCHRBankPosition | ((scrollYAdjusted & 0xF8) << 2)  //The row of cached tiles we're fetching from.
        var scrollXAdjusted = (backgroundX + currentX) & 0xFF            //The scroll amount of the BG.
        var pixelPosition = pixelStart + currentX                  //Current pixel we're working on.
        var pixelPositionEnd = pixelStart + (pixelEnd)
        if((gfxWindowDisplay && (scanlineToRender - windowY) >= 0)){
            pixelPositionEnd = pixelStart + (min(max(windowX, 0) + currentX, pixelEnd))
        }
        //Make sure we do at most 160 pixels a scanline.
        var tileNumber = tileYDown + (scrollXAdjusted >> 3)
        var chrCode = BGCHRBank1.array[tileNumber]
        if ( (chrCode < gfxBackgroundBankOffset)) {
            chrCode |= 0x100
        }
        var attrCode = BGCHRBank2.array[tileNumber]
        var tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
        var palette = (attrCode & 0x7) << 2
        var texel: Int64 = (scrollXAdjusted & 0x7)
        while ( texel < 8 && pixelPosition < pixelPositionEnd && scrollXAdjusted < 0x100) {
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine | texel]]
            texel++
            pixelPosition++
            scrollXAdjusted += 1
        }
        var scrollXAdjustedAligned = min(pixelPositionEnd - pixelPosition, 0x100 - scrollXAdjusted) >> 3
        scrollXAdjusted += scrollXAdjustedAligned << 3
        scrollXAdjustedAligned += tileNumber
        while ( (tileNumber < scrollXAdjustedAligned)) {
            tileNumber += 1
            chrCode = BGCHRBank1.array[tileNumber]
            if ( (chrCode < gfxBackgroundBankOffset)) {
                chrCode |= 0x100
            }
            attrCode = BGCHRBank2.array[tileNumber]
            tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
            palette = (attrCode & 0x7) << 2
            texel = tileYLine
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            texel++
            pixelPosition++
            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
            pixelPosition++
        }
        if ( (pixelPosition < pixelPositionEnd)) {
            if ( (scrollXAdjusted < 0x100)) {
                tileNumber += 1
                chrCode = BGCHRBank1.array[tileNumber]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                attrCode = BGCHRBank2.array[tileNumber]
                tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                palette = (attrCode & 0x7) << 2
                var texel = tileYLine - 1
                while ( pixelPosition < pixelPositionEnd && scrollXAdjusted < 0x100) {
                    texel += 1
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                    pixelPosition++
                    scrollXAdjusted += 1
                }
            }
            scrollXAdjustedAligned = ((pixelPositionEnd - pixelPosition) >> 3) + tileYDown
            while ( (tileYDown < scrollXAdjustedAligned)) {
                chrCode = BGCHRBank1.array[tileYDown]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                attrCode = BGCHRBank2.array[tileYDown]
                tileYDown++
                tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                palette = (attrCode & 0x7) << 2
                texel = tileYLine
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                texel++
                pixelPosition++
                frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]] 
                pixelPosition++
            }
            if ( (pixelPosition < pixelPositionEnd)) {
                chrCode = BGCHRBank1.array[tileYDown]
                if ( (chrCode < gfxBackgroundBankOffset)) {
                    chrCode |= 0x100
                }
                attrCode = BGCHRBank2.array[tileYDown]
                tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                palette = (attrCode & 0x7) << 2
                if(pixelPositionEnd - pixelPosition == 7){
                    frameBuffer[pixelPosition + 6] = gbcBGPalette[palette | tile[tileYLine | 6]]
                    frameBuffer[pixelPosition + 5] = gbcBGPalette[palette | tile[tileYLine | 5]]
                    frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 6){
                    frameBuffer[pixelPosition + 5] = gbcBGPalette[palette | tile[tileYLine | 5]]
                    frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]

                }
                if(pixelPositionEnd - pixelPosition == 5){
                    frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 4){
                    frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 3){
                    frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 2){
                    frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
                if(pixelPositionEnd - pixelPosition == 1){
                    frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                }
            }
        }
    }
    func WindowGBLayerRender( scanlineToRender: Int64) {
        
        if ( (gfxWindowDisplay)) {                  //Is the window enabled?
            let scrollYAdjusted = scanlineToRender - windowY    //The line of the BG we're at.
            if ( (scrollYAdjusted >= 0)) {
                var scrollXRangeAdjusted =  currentX
                if( (windowX > 0)){
                    scrollXRangeAdjusted = (windowX + currentX) 
                }
                var pixelPosition = pixelStart + scrollXRangeAdjusted
                let pixelPositionEnd = pixelStart + pixelEnd
                if ( (pixelPosition < pixelPositionEnd)) {
                    let tileYLine = (scrollYAdjusted & 0x7) << 3
                    var tileNumber = (gfxWindowCHRBankPosition | ((scrollYAdjusted & 0xF8) << 2)) + (currentX >> 3)
                    var chrCode = BGCHRBank1.array[tileNumber]
                    if ( (chrCode < gfxBackgroundBankOffset)) {
                        chrCode |= 0x100
                    }
                    var tile = tileCache[chrCode].array
                    var texel = (scrollXRangeAdjusted - windowX) & 0x7
                    scrollXRangeAdjusted = min(8, texel + pixelPositionEnd - pixelPosition)
                    while ( (texel < scrollXRangeAdjusted)) {
                        frameBuffer[pixelPosition] = BGPalette[tile[tileYLine | texel]]
                        texel++
                        pixelPosition++
                    }
                    scrollXRangeAdjusted = tileNumber + ((pixelPositionEnd - pixelPosition) >> 3)
                    while ( (tileNumber < scrollXRangeAdjusted)) {
                        tileNumber += 1
                        chrCode = BGCHRBank1.array[tileNumber]
                        if ( (chrCode < gfxBackgroundBankOffset)) {
                            chrCode |= 0x100
                        }
                        tile = tileCache[chrCode].array
                        texel = tileYLine
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = BGPalette[tile[texel]]
                        pixelPosition++
                    }
                    if ( (pixelPosition < pixelPositionEnd)) {
                        tileNumber += 1
                        chrCode = BGCHRBank1.array[tileNumber]
                        if ( (chrCode < gfxBackgroundBankOffset)) {
                            chrCode |= 0x100
                        }
                        tile = tileCache[chrCode].array
                        if(pixelPositionEnd - pixelPosition == 7){
                            frameBuffer[pixelPosition + 6] = BGPalette[tile[tileYLine | 6]]
                            frameBuffer[pixelPosition + 5] = BGPalette[tile[tileYLine | 5]]
                            frameBuffer[pixelPosition + 4] = BGPalette[tile[tileYLine | 4]]
                            frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 6){
                            frameBuffer[pixelPosition + 5] = BGPalette[tile[tileYLine | 5]]
                            frameBuffer[pixelPosition + 4] = BGPalette[tile[tileYLine | 4]]
                            frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 5){
                            frameBuffer[pixelPosition + 4] = BGPalette[tile[tileYLine | 4]]
                            frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 4){
                            frameBuffer[pixelPosition + 3] = BGPalette[tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 3){
                            frameBuffer[pixelPosition + 2] = BGPalette[tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 2){
                            frameBuffer[pixelPosition + 1] = BGPalette[tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 1){
                            frameBuffer[pixelPosition] = BGPalette[tile[tileYLine]]
                        }
                    }
                }
            }
        }
    }
    func WindowGBCLayerRender( scanlineToRender: Int64) {
        if ( (gfxWindowDisplay)) {                  //Is the window enabled?
            let scrollYAdjusted = scanlineToRender - windowY    //The line of the BG we're at.
            if ( (scrollYAdjusted >= 0)) {
                var scrollXRangeAdjusted = currentX
                if((windowX > 0)){
                    scrollXRangeAdjusted =  (windowX + currentX) 
                }
                var pixelPosition = pixelStart + scrollXRangeAdjusted
                let pixelPositionEnd = pixelStart + pixelEnd
                if ( (pixelPosition < pixelPositionEnd)) {
                    let tileYLine = (scrollYAdjusted & 0x7) << 3
                    var tileNumber = (gfxWindowCHRBankPosition | ((scrollYAdjusted & 0xF8) << 2)) + (currentX >> 3)
                    var chrCode = BGCHRBank1.array[tileNumber]
                    if ( (chrCode < gfxBackgroundBankOffset)) {
                        chrCode |= 0x100
                    }
                    var attrCode = BGCHRBank2.array[tileNumber]
                    var tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                    var palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
                    var texel = (scrollXRangeAdjusted - windowX) & 0x7
                    scrollXRangeAdjusted = min(8, texel + pixelPositionEnd - pixelPosition)
                    while ( (texel < scrollXRangeAdjusted)) {
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine | texel]]
                        texel++
                        pixelPosition++
                    }
                    scrollXRangeAdjusted = tileNumber + ((pixelPositionEnd - pixelPosition) >> 3)
                    while ( (tileNumber < scrollXRangeAdjusted)) {
                        tileNumber += 1
                        chrCode = BGCHRBank1.array[tileNumber]
                        if ( (chrCode < gfxBackgroundBankOffset)) {
                            chrCode |= 0x100
                        }
                        attrCode = BGCHRBank2.array[tileNumber]
                        tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                        palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
                        texel = tileYLine
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        pixelPosition++
                    }
                    if ( (pixelPosition < pixelPositionEnd)) {
                        tileNumber += 1
                        chrCode = BGCHRBank1.array[tileNumber]
                        if ( (chrCode < gfxBackgroundBankOffset)) {
                            chrCode |= 0x100
                        }
                        attrCode = BGCHRBank2.array[tileNumber]
                        tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                        palette = ((attrCode & 0x7) << 2) | ((attrCode & 0x80) >> 2)
                        if(pixelPositionEnd - pixelPosition == 7){
                            frameBuffer[pixelPosition + 6] = gbcBGPalette[palette | tile[tileYLine | 6]]
                            frameBuffer[pixelPosition + 5] = gbcBGPalette[palette | tile[tileYLine | 5]]
                            frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                            frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 6){
                            frameBuffer[pixelPosition + 5] = gbcBGPalette[palette | tile[tileYLine | 5]]
                            frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                            frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 5){
                            frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                            frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 4){
                            frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                            frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 3){
                            frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                            frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 2){
                            frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                        if(pixelPositionEnd - pixelPosition == 1){
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                    }
                }
            }
        }
    }
    func WindowGBCLayerRenderNoPriorityFlagging( scanlineToRender: Int64) {
        
        if ( (gfxWindowDisplay)) {                  //Is the window enabled?
            let scrollYAdjusted = scanlineToRender - windowY    //The line of the BG we're at.
            if ( (scrollYAdjusted >= 0)) {
                var scrollXRangeAdjusted = currentX
                if(windowX > 0){
                    scrollXRangeAdjusted =  (windowX + currentX) 
                }
                var pixelPosition = pixelStart + scrollXRangeAdjusted
                let pixelPositionEnd = pixelStart + pixelEnd
                if ( (pixelPosition < pixelPositionEnd)) {
                    let tileYLine = (scrollYAdjusted & 0x7) << 3
                    var tileNumber = (gfxWindowCHRBankPosition | ((scrollYAdjusted & 0xF8) << 2)) + (currentX >> 3)
                    var chrCode = BGCHRBank1.array[tileNumber]
                    if ( (chrCode < gfxBackgroundBankOffset)) {
                        chrCode |= 0x100
                    }
                    var attrCode = BGCHRBank2.array[tileNumber]
                    var tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                    var palette = (attrCode & 0x7) << 2
                    var texel = (scrollXRangeAdjusted - windowX) & 0x7
                    scrollXRangeAdjusted = min(8, texel + pixelPositionEnd - pixelPosition)
                    while ( (texel < scrollXRangeAdjusted)) {
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine | texel]]
                        texel++
                        pixelPosition++
                    }
                    scrollXRangeAdjusted = tileNumber + ((pixelPositionEnd - pixelPosition) >> 3)
                    while ( (tileNumber < scrollXRangeAdjusted)) {
                        tileNumber += 1
                        chrCode = BGCHRBank1.array[tileNumber]
                        if ( (chrCode < gfxBackgroundBankOffset)) {
                            chrCode |= 0x100
                        }
                        attrCode = BGCHRBank2.array[tileNumber]
                        tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                        palette = (attrCode & 0x7) << 2
                        texel = tileYLine
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        texel++
                        pixelPosition++
                        frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[texel]]
                        pixelPosition++
                    }
                    if ( (pixelPosition < pixelPositionEnd)) {
                        tileNumber += 1
                        chrCode = BGCHRBank1.array[tileNumber]
                        if ( (chrCode < gfxBackgroundBankOffset)) {
                            chrCode |= 0x100
                        }
                        attrCode = BGCHRBank2.array[tileNumber]
                        tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | chrCode].array
                        palette = (attrCode & 0x7) << 2
                        if(pixelPositionEnd - pixelPosition == 7){
                            frameBuffer[pixelPosition + 6] = gbcBGPalette[palette | tile[tileYLine | 6]]
                        }
                        if(pixelPositionEnd - pixelPosition == 6){
                            frameBuffer[pixelPosition + 5] = gbcBGPalette[palette | tile[tileYLine | 5]]
                        }
                        if(pixelPositionEnd - pixelPosition == 5){
                            frameBuffer[pixelPosition + 4] = gbcBGPalette[palette | tile[tileYLine | 4]]
                        }
                        if(pixelPositionEnd - pixelPosition == 4){
                            frameBuffer[pixelPosition + 3] = gbcBGPalette[palette | tile[tileYLine | 3]]
                        }
                        if(pixelPositionEnd - pixelPosition == 3){
                            frameBuffer[pixelPosition + 2] = gbcBGPalette[palette | tile[tileYLine | 2]]
                        }
                        if(pixelPositionEnd - pixelPosition == 2){
                            frameBuffer[pixelPosition + 1] = gbcBGPalette[palette | tile[tileYLine | 1]]
                        }
                        if(pixelPositionEnd - pixelPosition == 1){
                            frameBuffer[pixelPosition] = gbcBGPalette[palette | tile[tileYLine]]
                        }
                    }
                }
            }
        }
    }
    func SpriteGBLayerRender( scanlineToRender: Int64) {
        
        if ( (gfxSpriteShow)) {                    //Are sprites enabled?
            let lineAdjusted = scanlineToRender + 0x10
            var OAMAddress = 0xFE00
            var yoffset = 0
            var xcoord = 1
            var xCoordStart = 0
            var xCoordEnd = 0
            var attrCode = 0
            var palette = 0
            var tile: Array<Int64> = []
            var data = 0
            var spriteCount = 0
            let length = 0
            var currentPixel = 0
            var linePixel = 0
            //Clear our x-coord sort buffer:
            while ( (xcoord < 168)) {
                sortBuffer[xcoord] = 0xFF
                xcoord++
            }
            if ( (gfxSpriteNormalHeight)) {
                //Draw the visible sprites:
                let length = findLowestSpriteDrawable(lineAdjusted, 0x7)
                while ( spriteCount < length) {
                    OAMAddress = OAMAddressCache[spriteCount]
                    yoffset = (lineAdjusted - memory[OAMAddress]) << 3
                    attrCode = memory[OAMAddress | 3]
                    palette = (attrCode & 0x10) >> 2
                    tile = tileCache[((attrCode & 0x60) << 4) | memory[OAMAddress | 0x2]].array
                    linePixel = memory[OAMAddress | 1]
                    xCoordStart = memory[OAMAddress | 1]
                    xCoordEnd = min(168 - linePixel, 8)
                    if(linePixel > 7){
                        xcoord = 0 
                    }else{
                        xcoord = (8 - linePixel)
                    }
                    if(linePixel > 8){
                        currentPixel = pixelStart + ((linePixel - 8) )
                    }else{
                        currentPixel = pixelStart + (0)
                    }
                    while ( xcoord < xCoordEnd) {
                        if ( (sortBuffer[linePixel] > xCoordStart)) {
                            if ( (frameBuffer[currentPixel] >= 0x2000000)) {
                                data = tile[yoffset | xcoord]
                                if ( (data > 0)) {
                                    frameBuffer[currentPixel] = OBJPalette[palette | data]
                                    sortBuffer[linePixel] = xCoordStart
                                }
                            }
                            else if ( (frameBuffer[currentPixel] < 0x1000000)) {
                                data = tile[yoffset | xcoord]
                                if ( (data > 0 && attrCode < 0x80)) {
                                    frameBuffer[currentPixel] = OBJPalette[palette | data]
                                    sortBuffer[linePixel] = xCoordStart
                                }
                            }
                        }
                        xcoord += 1
                        currentPixel += 1
                        linePixel += 1
                    }
                    spriteCount += 1
                }
            }
            else {
                //Draw the visible sprites:
                let length = findLowestSpriteDrawable(lineAdjusted, 0xF)
                while ( spriteCount < length) {
                    OAMAddress = OAMAddressCache[spriteCount]
                    yoffset = (lineAdjusted - memory[OAMAddress]) << 3
                    attrCode = memory[OAMAddress | 3]
                    palette = (attrCode & 0x10) >> 2
                    if ( ((attrCode & 0x40) == (0x40 & yoffset))) {
                        tile = tileCache[((attrCode & 0x60) << 4) | (memory[OAMAddress | 0x2] & 0xFE)].array
                    }
                    else {
                        tile = tileCache[((attrCode & 0x60) << 4) | memory[OAMAddress | 0x2] | 1].array
                    }
                    yoffset &= 0x3F
                    xCoordStart = memory[OAMAddress | 1]
                    linePixel = xCoordStart
                    xCoordEnd = min(168 - linePixel, 8)
                    if(linePixel > 7){
                        xcoord = 0 
                    }else{
                        xcoord =(8 - linePixel)
                    }
                    var currentPixel = pixelStart + ( 0)
                    if(linePixel > 8){
                        currentPixel = pixelStart + (  (linePixel - 8) )
                    }
                    while ( xcoord < xCoordEnd) {
                        if ( (sortBuffer[linePixel] > xCoordStart)) {
                            if ( (frameBuffer[currentPixel] >= 0x2000000)) {
                                data = tile[yoffset | xcoord]
                                if ( (data > 0)) {
                                    frameBuffer[currentPixel] = OBJPalette[palette | data]
                                    sortBuffer[linePixel] = xCoordStart
                                }
                            }
                            else if ( (frameBuffer[currentPixel] < 0x1000000)) {
                                data = tile[yoffset | xcoord]
                                if ( (data > 0 && attrCode < 0x80)) {
                                    frameBuffer[currentPixel] = OBJPalette[palette | data]
                                    sortBuffer[linePixel] = xCoordStart
                                }
                            }
                        }
                        xcoord += 1
                        currentPixel += 1
                        linePixel += 1
                    }
                    spriteCount += 1
                }
            }
        }
    }
    func findLowestSpriteDrawable( scanlineToRender: Int64,  drawableRange: Int64) : Int64 {
        
        var address = 0xFE00
        var spriteCount = 0
        var diff = 0
        while ( (address < 0xFEA0 && spriteCount < 10)) {
            diff = scanlineToRender - memory[address]
            if ((diff & drawableRange) == diff) {
                OAMAddressCache[spriteCount] = address
                spriteCount++
            }
            address += 4
        }
        return spriteCount
    }
    func SpriteGBCLayerRender( scanlineToRender: Int64) {
        if ( (gfxSpriteShow)) {                    //Are sprites enabled?
            var OAMAddress = 0xFE00
            let lineAdjusted = scanlineToRender + 0x10
            var yoffset = 0
            var xcoord = 0
            var endX = 0
            var xCounter = 0
            var attrCode = 0
            var palette = 0
            var tile: Array<Int64> = []
            var data = 0
            var currentPixel = 0
            var spriteCount = 0
            if ( (gfxSpriteNormalHeight)) {
                while ( OAMAddress < 0xFEA0 && spriteCount < 10) {
                    yoffset = lineAdjusted - memory[OAMAddress]
                    if ( ((yoffset & 0x7) == yoffset)) {
                        xcoord = memory[OAMAddress | 1] - 8
                        endX = min(160, xcoord + 8)
                        attrCode = memory[OAMAddress | 3]
                        palette = (attrCode & 7) << 2
                        tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | memory[OAMAddress | 2]].array
                        if(xcoord > 0){
                            xCounter = xcoord 
                        }else{
                            xCounter = 0
                        }
                        xcoord -= yoffset << 3
                        currentPixel = pixelStart + xCounter
                        while ( xCounter < endX) {
                            if ( (frameBuffer[currentPixel] >= 0x2000000)) {
                                data = tile[xCounter - xcoord]
                                if ( (data > 0)) {
                                    frameBuffer[currentPixel] = gbcOBJPalette[palette | data]
                                }
                            } else if ( (frameBuffer[currentPixel] < 0x1000000)) {
                                data = tile[xCounter - xcoord]
                                if ( (data > 0 && attrCode < 0x80)) {    //Don't optimize for attrCode, as LICM-capable JITs should optimize its checks.
                                    frameBuffer[currentPixel] = gbcOBJPalette[palette | data]
                                }
                            }
                            xCounter += 1
                            currentPixel += 1
                        }
                        spriteCount += 1
                    }
                    OAMAddress += 4
                }
            }
            else {
                while ( OAMAddress < 0xFEA0 && spriteCount < 10) {
                    yoffset = lineAdjusted - memory[OAMAddress]
                    if ( ((yoffset & 0xF) == yoffset)) {
                        xcoord = memory[OAMAddress | 1] - 8
                        endX = min(160, xcoord + 8)
                        attrCode = memory[OAMAddress | 3]
                        palette = (attrCode & 7) << 2
                        if ( ((attrCode & 0x40) == (0x40 & (yoffset << 3)))) {
                            tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | (memory[OAMAddress | 0x2] & 0xFE)].array
                        }
                        else {
                            tile = tileCache[((attrCode & 0x08) << 8) | ((attrCode & 0x60) << 4) | memory[OAMAddress | 0x2] | 1].array
                        }
                        if(xcoord > 0){
                            xCounter =  xcoord 
                        }else{
                            xCounter = 0
                        }
                        xcoord -= (yoffset & 0x7) << 3
                        var currentPixel: Int64 = pixelStart + xCounter
                        while ( xCounter < endX) {
                            if ( (frameBuffer[currentPixel] >= 0x2000000)) {
                                data = tile[xCounter - xcoord]
                                if ( (data > 0)) {
                                    frameBuffer[currentPixel] = gbcOBJPalette[palette | data]
                                }
                            } else if ( (frameBuffer[currentPixel] < 0x1000000)) {
                                data = tile[xCounter - xcoord]
                                if ( (data > 0 && attrCode < 0x80)) {    //Don't optimize for attrCode, as LICM-capable JITs should optimize its checks.
                                    frameBuffer[currentPixel] = gbcOBJPalette[palette | data]
                                }
                            }
                            xCounter += 1
                            currentPixel += 1
                        }
                        spriteCount += 1
                    }
                    OAMAddress += 4
                }
            }
        }
    }
    //Generate only a single tile line for the GB tile cache mode:
    func generateGBTileLine( addressTemp: Int64) {
        
        var address = addressTemp
        let lineCopy = (memory[0x1 | address] << 8) | memory[0x9FFE & address]
        let tileBlock = tileCache[(address & 0x1FF0) >> 4]
        address = (address & 0xE) << 2
        tileBlock.array[address | 7] = ((lineCopy & 0x100) >> 7) | (lineCopy & 0x1)
        tileBlock.array[address | 6] = ((lineCopy & 0x200) >> 8) | ((lineCopy & 0x2) >> 1)
        tileBlock.array[address | 5] = ((lineCopy & 0x400) >> 9) | ((lineCopy & 0x4) >> 2)
        tileBlock.array[address | 4] = ((lineCopy & 0x800) >> 10) | ((lineCopy & 0x8) >> 3)
        tileBlock.array[address | 3] = ((lineCopy & 0x1000) >> 11) | ((lineCopy & 0x10) >> 4)
        tileBlock.array[address | 2] = ((lineCopy & 0x2000) >> 12) | ((lineCopy & 0x20) >> 5)
        tileBlock.array[address | 1] = ((lineCopy & 0x4000) >> 13) | ((lineCopy & 0x40) >> 6)
        tileBlock.array[address] = ((lineCopy & 0x8000) >> 14) | ((lineCopy & 0x80) >> 7)
    }
    //Generate only a single tile line for the GBC tile cache mode (Bank 1):
    func generateGBCTileLineBank1( addressTemp: Int64) {
        var address = addressTemp
        let lineCopy = (memory[0x1 | address] << 8) | memory[0x9FFE & address]
        address &= 0x1FFE
        let tileBlock1 = tileCache[address >> 4]
        let tileBlock2 = tileCache[0x200 | (address >> 4)]
        let tileBlock3 = tileCache[0x400 | (address >> 4)]
        let tileBlock4 = tileCache[0x600 | (address >> 4)]
        address = (address & 0xE) << 2
        let addressFlipped = 0x38 - address
        tileBlock1.array[address | 7] = ((lineCopy & 0x100) >> 7) | (lineCopy & 0x1)
        tileBlock4.array[addressFlipped] = tileBlock1.array[address | 7]
        tileBlock2.array[address] = tileBlock1.array[address | 7]
        tileBlock3.array[addressFlipped | 7] = tileBlock1.array[address | 7]
        tileBlock1.array[address | 6] = ((lineCopy & 0x200) >> 8) | ((lineCopy & 0x2) >> 1)
        tileBlock4.array[addressFlipped | 1] = tileBlock1.array[address | 6]
        tileBlock2.array[address | 1] = tileBlock1.array[address | 6]
        tileBlock3.array[addressFlipped | 6] = tileBlock1.array[address | 6]
        tileBlock1.array[address | 5] = ((lineCopy & 0x400) >> 9) | ((lineCopy & 0x4) >> 2)
        tileBlock4.array[addressFlipped | 2] = tileBlock1.array[address | 5]
        tileBlock2.array[address | 2] = tileBlock1.array[address | 5]
        tileBlock3.array[addressFlipped | 5] = tileBlock1.array[address | 5]
        tileBlock1.array[address | 4] = ((lineCopy & 0x800) >> 10) | ((lineCopy & 0x8) >> 3)
        tileBlock4.array[addressFlipped | 3] = tileBlock1.array[address | 4]
        tileBlock2.array[address | 3] = tileBlock1.array[address | 4]
        tileBlock3.array[addressFlipped | 4] = tileBlock1.array[address | 4]
        tileBlock1.array[address | 3] = ((lineCopy & 0x1000) >> 11) | ((lineCopy & 0x10) >> 4)
        tileBlock4.array[addressFlipped | 4] = tileBlock1.array[address | 3]
        tileBlock2.array[address | 4] = tileBlock1.array[address | 3]
        tileBlock3.array[addressFlipped | 3] = tileBlock1.array[address | 3]
        tileBlock1.array[address | 2] = ((lineCopy & 0x2000) >> 12) | ((lineCopy & 0x20) >> 5)
        tileBlock4.array[addressFlipped | 5] = tileBlock1.array[address | 2]
        tileBlock2.array[address | 5] = tileBlock1.array[address | 2]
        tileBlock3.array[addressFlipped | 2] = tileBlock1.array[address | 2]
        tileBlock1.array[address | 1] = ((lineCopy & 0x4000) >> 13) | ((lineCopy & 0x40) >> 6)
        tileBlock4.array[addressFlipped | 6] = tileBlock1.array[address | 1]
        tileBlock2.array[address | 6] = tileBlock1.array[address | 1]
        tileBlock3.array[addressFlipped | 1] = tileBlock1.array[address | 1]
        tileBlock1.array[address] = ((lineCopy & 0x8000) >> 14) | ((lineCopy & 0x80) >> 7)
        tileBlock4.array[addressFlipped | 7] = tileBlock1.array[address]
        tileBlock2.array[address | 7] = tileBlock1.array[address]
        tileBlock3.array[addressFlipped] = tileBlock1.array[address]
    }
    //Generate all the flip combinations for a full GBC VRAM bank 1 tile:
    func generateGBCTileBank1( vramAddressTemp: Int64) {
        var vramAddress = vramAddressTemp
        var address = vramAddress >> 4
        let tileBlock1 = tileCache[address]
        let tileBlock2 = tileCache[0x200 | address]
        let tileBlock3 = tileCache[0x400 | address]
        let tileBlock4 = tileCache[0x600 | address]
        var lineCopy = 0
        vramAddress |= 0x8000
        address = 0
        var addressFlipped = 56
        do {
            lineCopy = (memory[0x1 | vramAddress] << 8) | memory[vramAddress]
            tileBlock1.array[address | 7] = ((lineCopy & 0x100) >> 7) | (lineCopy & 0x1)
            tileBlock4.array[addressFlipped] = tileBlock1.array[address | 7]
            tileBlock2.array[address] = tileBlock1.array[address | 7]
            tileBlock3.array[addressFlipped | 7] = tileBlock1.array[address | 7]
            tileBlock1.array[address | 6] = ((lineCopy & 0x200) >> 8) | ((lineCopy & 0x2) >> 1)
            tileBlock4.array[addressFlipped | 1] = tileBlock1.array[address | 6]
            tileBlock2.array[address | 1] = tileBlock1.array[address | 6]
            tileBlock3.array[addressFlipped | 6] = tileBlock1.array[address | 6]
            tileBlock1.array[address | 5] = ((lineCopy & 0x400) >> 9) | ((lineCopy & 0x4) >> 2)
            tileBlock4.array[addressFlipped | 2] = tileBlock1.array[address | 5]
            tileBlock2.array[address | 2] = tileBlock1.array[address | 5]
            tileBlock3.array[addressFlipped | 5] = tileBlock1.array[address | 5]
            tileBlock1.array[address | 4] = ((lineCopy & 0x800) >> 10) | ((lineCopy & 0x8) >> 3)
            tileBlock4.array[addressFlipped | 3] = tileBlock1.array[address | 4]
            tileBlock2.array[address | 3] = tileBlock1.array[address | 4]
            tileBlock3.array[addressFlipped | 4] = tileBlock1.array[address | 4]
            tileBlock1.array[address | 3] = ((lineCopy & 0x1000) >> 11) | ((lineCopy & 0x10) >> 4)
            tileBlock4.array[addressFlipped | 4] = tileBlock1.array[address | 3]
            tileBlock2.array[address | 4] = tileBlock1.array[address | 3]
            tileBlock3.array[addressFlipped | 3] = tileBlock1.array[address | 3]
            tileBlock1.array[address | 2] = ((lineCopy & 0x2000) >> 12) | ((lineCopy & 0x20) >> 5)
            tileBlock4.array[addressFlipped | 5] = tileBlock1.array[address | 2]
            tileBlock2.array[address | 5] = tileBlock1.array[address | 2]
            tileBlock3.array[addressFlipped | 2] = tileBlock1.array[address | 2]
            tileBlock1.array[address | 1] = ((lineCopy & 0x4000) >> 13) | ((lineCopy & 0x40) >> 6)
            tileBlock4.array[addressFlipped | 6] = tileBlock1.array[address | 1]
            tileBlock2.array[address | 6] = tileBlock1.array[address | 1]
            tileBlock3.array[addressFlipped | 1] = tileBlock1.array[address | 1]
            tileBlock1.array[address] = ((lineCopy & 0x8000) >> 14) | ((lineCopy & 0x80) >> 7)
            tileBlock4.array[addressFlipped | 7] = tileBlock1.array[address]
            tileBlock2.array[address | 7] = tileBlock1.array[address]
            tileBlock3.array[addressFlipped] = tileBlock1.array[address]
            address += 8
            addressFlipped -= 8
            vramAddress += 2
        } while (addressFlipped > -1)
    }
    //Generate only a single tile line for the GBC tile cache mode (Bank 2):
    func generateGBCTileLineBank2( addressTemp: Int64) {
        
        var address = addressTemp
        let lineCopy = (VRAM[0x1 | address] << 8) | VRAM[0x1FFE & address]
        let tileBlock1 = tileCache[0x800 | (address >> 4)]
        let tileBlock2 = tileCache[0xA00 | (address >> 4)]
        let tileBlock3 = tileCache[0xC00 | (address >> 4)]
        let tileBlock4 = tileCache[0xE00 | (address >> 4)]
        address = (address & 0xE) << 2
        let addressFlipped = 0x38 - address
        tileBlock1.array[address | 7] = ((lineCopy & 0x100) >> 7) | (lineCopy & 0x1)
        tileBlock4.array[addressFlipped] = tileBlock1.array[address | 7]
        tileBlock2.array[address] = tileBlock1.array[address | 7]
        tileBlock3.array[addressFlipped | 7] = tileBlock1.array[address | 7]
        tileBlock1.array[address | 6] = ((lineCopy & 0x200) >> 8) | ((lineCopy & 0x2) >> 1)
        tileBlock4.array[addressFlipped | 1] = tileBlock1.array[address | 6]
        tileBlock2.array[address | 1] = tileBlock1.array[address | 6]
        tileBlock3.array[addressFlipped | 6] = tileBlock1.array[address | 6]
        tileBlock1.array[address | 5] = ((lineCopy & 0x400) >> 9) | ((lineCopy & 0x4) >> 2)
        tileBlock4.array[addressFlipped | 2] = tileBlock1.array[address | 5]
        tileBlock2.array[address | 2] = tileBlock1.array[address | 5]
        tileBlock3.array[addressFlipped | 5] = tileBlock1.array[address | 5]
        tileBlock1.array[address | 4] = ((lineCopy & 0x800) >> 10) | ((lineCopy & 0x8) >> 3)
        tileBlock4.array[addressFlipped | 3] = tileBlock1.array[address | 4]
        tileBlock2.array[address | 3] = tileBlock1.array[address | 4]
        tileBlock3.array[addressFlipped | 4] = tileBlock1.array[address | 4]
        tileBlock1.array[address | 3] = ((lineCopy & 0x1000) >> 11) | ((lineCopy & 0x10) >> 4)
        tileBlock4.array[addressFlipped | 4] = tileBlock1.array[address | 3]
        tileBlock2.array[address | 4] = tileBlock1.array[address | 3]
        tileBlock3.array[addressFlipped | 3] = tileBlock1.array[address | 3]
        tileBlock1.array[address | 2] = ((lineCopy & 0x2000) >> 12) | ((lineCopy & 0x20) >> 5)
        tileBlock4.array[addressFlipped | 5] = tileBlock1.array[address | 2]
        tileBlock2.array[address | 5] = tileBlock1.array[address | 2]
        tileBlock3.array[addressFlipped | 2] = tileBlock1.array[address | 2]
        tileBlock1.array[address | 1] = ((lineCopy & 0x4000) >> 13) | ((lineCopy & 0x40) >> 6)
        tileBlock4.array[addressFlipped | 6] = tileBlock1.array[address | 1]
        tileBlock2.array[address | 6] = tileBlock1.array[address | 1]
        tileBlock3.array[addressFlipped | 1] = tileBlock1.array[address | 1]
        tileBlock1.array[address] = ((lineCopy & 0x8000) >> 14) | ((lineCopy & 0x80) >> 7)
        tileBlock4.array[addressFlipped | 7] = tileBlock1.array[address]
        tileBlock2.array[address | 7] = tileBlock1.array[address]
        tileBlock3.array[addressFlipped] = tileBlock1.array[address]
    }
    //Generate all the flip combinations for a full GBC VRAM bank 2 tile:
    func generateGBCTileBank2( vramAddressTemp: Int64) {
        var vramAddress = vramAddressTemp
        var address = vramAddress >> 4
        let tileBlock1 = tileCache[0x800 | address]
        let tileBlock2 = tileCache[0xA00 | address]
        let tileBlock3 = tileCache[0xC00 | address]
        let tileBlock4 = tileCache[0xE00 | address]
        var lineCopy = 0
        address = 0
        var addressFlipped = 56
        do {
            lineCopy = (VRAM[0x1 | vramAddress] << 8) | VRAM[vramAddress]
            tileBlock1.array[address | 7] = ((lineCopy & 0x100) >> 7) | (lineCopy & 0x1)
            tileBlock4.array[addressFlipped] = tileBlock1.array[address | 7]
            tileBlock2.array[address] = tileBlock1.array[address | 7]
            tileBlock3.array[addressFlipped | 7] = tileBlock1.array[address | 7]
            tileBlock1.array[address | 6] = ((lineCopy & 0x200) >> 8) | ((lineCopy & 0x2) >> 1)
            tileBlock4.array[addressFlipped | 1] = tileBlock1.array[address | 6]
            tileBlock2.array[address | 1] = tileBlock1.array[address | 6]
            tileBlock3.array[addressFlipped | 6] = tileBlock1.array[address | 6]
            tileBlock1.array[address | 5] = ((lineCopy & 0x400) >> 9) | ((lineCopy & 0x4) >> 2)
            tileBlock4.array[addressFlipped | 2] = tileBlock1.array[address | 5]
            tileBlock2.array[address | 2] = tileBlock1.array[address | 5]
            tileBlock3.array[addressFlipped | 5] = tileBlock1.array[address | 5]
            tileBlock1.array[address | 4] = ((lineCopy & 0x800) >> 10) | ((lineCopy & 0x8) >> 3)
            tileBlock4.array[addressFlipped | 3] = tileBlock1.array[address | 4]
            tileBlock2.array[address | 3] = tileBlock1.array[address | 4]
            tileBlock3.array[addressFlipped | 4] = tileBlock1.array[address | 4]
            tileBlock1.array[address | 3] = ((lineCopy & 0x1000) >> 11) | ((lineCopy & 0x10) >> 4)
            tileBlock4.array[addressFlipped | 4] = tileBlock1.array[address | 3]
            tileBlock2.array[address | 4] = tileBlock1.array[address | 3]
            tileBlock3.array[addressFlipped | 3] = tileBlock1.array[address | 3]
            tileBlock1.array[address | 2] = ((lineCopy & 0x2000) >> 12) | ((lineCopy & 0x20) >> 5)
            tileBlock4.array[addressFlipped | 5] = tileBlock1.array[address | 2]
            tileBlock2.array[address | 5] = tileBlock1.array[address | 2]
            tileBlock3.array[addressFlipped | 2] = tileBlock1.array[address | 2]
            tileBlock1.array[address | 1] = ((lineCopy & 0x4000) >> 13) | ((lineCopy & 0x40) >> 6)
            tileBlock4.array[addressFlipped | 6] = tileBlock1.array[address | 1]
            tileBlock2.array[address | 6] = tileBlock1.array[address | 1]
            tileBlock3.array[addressFlipped | 1] = tileBlock1.array[address | 1]
            tileBlock1.array[address] = ((lineCopy & 0x8000) >> 14) | ((lineCopy & 0x80) >> 7)
            tileBlock4.array[addressFlipped | 7] = tileBlock1.array[address]
            tileBlock2.array[address | 7] = tileBlock1.array[address]
            tileBlock3.array[addressFlipped] = tileBlock1.array[address]
            address += 8
            addressFlipped -= 8
            vramAddress += 2
        } while (addressFlipped > -1)
    }
    //Generate only a single tile line for the GB tile cache mode (OAM accessible range):
    func generateGBOAMTileLine( addressTemp: Int64) {
        
        var address = addressTemp
        let lineCopy = (memory[0x1 | address] << 8) | memory[0x9FFE & address]
        address &= 0x1FFE
        let tileBlock1 = tileCache[address >> 4]
        let tileBlock2 = tileCache[0x200 | (address >> 4)]
        let tileBlock3 = tileCache[0x400 | (address >> 4)]
        let tileBlock4 = tileCache[0x600 | (address >> 4)]
        address = (address & 0xE) << 2
        let addressFlipped = 0x38 - address
        tileBlock1.array[address | 7] = ((lineCopy & 0x100) >> 7) | (lineCopy & 0x1)
        tileBlock4.array[addressFlipped] = tileBlock1.array[address | 7]
        tileBlock2.array[address] = tileBlock1.array[address | 7]
        tileBlock3.array[addressFlipped | 7] = tileBlock1.array[address | 7]
        tileBlock1.array[address | 6] = ((lineCopy & 0x200) >> 8) | ((lineCopy & 0x2) >> 1)
        tileBlock4.array[addressFlipped | 1] = tileBlock1.array[address | 6]
        tileBlock2.array[address | 1] = tileBlock1.array[address | 6]
        tileBlock3.array[addressFlipped | 6] = tileBlock1.array[address | 6]
        tileBlock1.array[address | 5] = ((lineCopy & 0x400) >> 9) | ((lineCopy & 0x4) >> 2)
        tileBlock4.array[addressFlipped | 2] = tileBlock1.array[address | 5]
        tileBlock2.array[address | 2] = tileBlock1.array[address | 5]
        tileBlock3.array[addressFlipped | 5] = tileBlock1.array[address | 5]
        tileBlock1.array[address | 4] = ((lineCopy & 0x800) >> 10) | ((lineCopy & 0x8) >> 3)
        tileBlock4.array[addressFlipped | 3] = tileBlock1.array[address | 4]
        tileBlock2.array[address | 3] = tileBlock1.array[address | 4]
        tileBlock3.array[addressFlipped | 4] = tileBlock1.array[address | 4]
        tileBlock1.array[address | 3] = ((lineCopy & 0x1000) >> 11) | ((lineCopy & 0x10) >> 4)
        tileBlock4.array[addressFlipped | 4] = tileBlock1.array[address | 3]
        tileBlock2.array[address | 4] = tileBlock1.array[address | 3]
        tileBlock3.array[addressFlipped | 3] = tileBlock1.array[address | 3]
        tileBlock1.array[address | 2] = ((lineCopy & 0x2000) >> 12) | ((lineCopy & 0x20) >> 5)
        tileBlock4.array[addressFlipped | 5] = tileBlock1.array[address | 2]
        tileBlock2.array[address | 5] = tileBlock1.array[address | 2]
        tileBlock3.array[addressFlipped | 2] = tileBlock1.array[address | 2]
        tileBlock1.array[address | 1] = ((lineCopy & 0x4000) >> 13) | ((lineCopy & 0x40) >> 6)
        tileBlock4.array[addressFlipped | 6] = tileBlock1.array[address | 1]
        tileBlock2.array[address | 6] = tileBlock1.array[address | 1]
        tileBlock3.array[addressFlipped | 1] = tileBlock1.array[address | 1]
        tileBlock1.array[address] = ((lineCopy & 0x8000) >> 14) | ((lineCopy & 0x80) >> 7)
        tileBlock4.array[addressFlipped | 7] = tileBlock1.array[address]
        tileBlock2.array[address | 7] = tileBlock1.array[address]
        tileBlock3.array[addressFlipped] = tileBlock1.array[address]
    }
    func graphicsJIT() {
        if ( (LCDisOn)) {
            totalLinesPassed = 0      //Mark frame for ensuring a JIT pass for the next framebuffer output.
            graphicsJITScanlineGroup()
        }
    }
    func graphicsJITVBlank() {
        
        //JIT the graphics to v-blank framing:
        totalLinesPassed += queuedScanLines
        graphicsJITScanlineGroup()
    }
    func graphicsJITScanlineGroup() {
        //Normal rendering JIT, where we try to do groups of scanlines at once:
        while ( (queuedScanLines > 0)) {
            renderScanLine(lastUnrenderedLine)
            if ( (lastUnrenderedLine < 143)) {
                lastUnrenderedLine += 1
            }
            else {
                lastUnrenderedLine = 0
            }
            queuedScanLines -= 1
        }
    }
    func incrementScanLineQueue() {
        if ( (queuedScanLines < 144)) {
            queuedScanLines += 1
        }
        else {
            currentX = 0
            midScanlineOffset = -1
            if ( (lastUnrenderedLine < 143)) {
                lastUnrenderedLine += 1
            }
            else {
                lastUnrenderedLine = 0
            }
        }
    }
    func midScanLineJIT() {
        graphicsJIT()
        renderMidScanLine()
    }
    //Check for the highest priority IRQ to fire:
    func launchIRQ() {
        
        var bitShift = 0
        var testbit = 1
        do {
            //Check to see if an interrupt is enabled AND requested.
            if ( ((testbit & IRQLineMatched) == testbit)) {
                IME = false            //Reset the interrupt enabling.
                interruptsRequested -= testbit  //Reset the interrupt request.
                IRQLineMatched = 0        //Reset the IRQ assertion.
                //Int64errupts have a certain clock cycle length:
                CPUTicks = 20
                //Set the stack pointer to the current program counter value:
                stackPointer = (stackPointer - 1) & 0xFFFF
                memoryWriter[stackPointer](this, stackPointer, programCounter >> 8)
                stackPointer = (stackPointer - 1) & 0xFFFF
                memoryWriter[stackPointer](this, stackPointer, programCounter & 0xFF)
                //Set the program counter to the interrupt's address:
                programCounter = 0x40 | (bitShift << 3)
                //Clock the core for mid-instruction updates:
                updateCore()
                return                  //We only want the highest priority interrupt.
            }
            bitShift += 1
            testbit = 1 << bitShift
        } while (bitShift < 5)
    }
    /*
     Check for IRQs to be fired while not in HALT:
     */
    func checkIRQMatching() {
        if ( (IME)) {
            IRQLineMatched = interruptsEnabled & interruptsRequested & 0x1F
        }
    }
    /*
     Handle the HALT opcode by predicting all IRQ cases correctly,
     then selecting the next closest IRQ firing from the prediction to
     clock up to. This prevents hacky looping that doesn't predict, but
     instead just clocks through the core update procedure by one which
     is very slow. Not many emulators do this because they have to cover
     all the IRQ prediction cases and they usually get them wrong.
     */
    func calculateHALTPeriod() {
        
        //Initialize our variables and start our prediction:
        var currentClocks = 0
        if ( (!halt)) {
            halt = true
            currentClocks = -1
            var temp_var = 0
            if ( (LCDisOn)) {
                //If the LCD is enabled, then predict the LCD IRQs enabled:
                if ( ((interruptsEnabled & 0x1) == 0x1)) {
                    if(modeSTAT == 1){
                        currentClocks = ((456 * (( 298 ) - actualScanLine)) - LCDTicks) << doubleSpeedShifter
                    }else{
                        currentClocks = ((456 * ((144) - actualScanLine)) - LCDTicks) << doubleSpeedShifter
                    }
                }
                if ( ((interruptsEnabled & 0x2) == 0x2)) {
                    if ( (mode0TriggerSTAT)) {
                        temp_var = (clocksUntilMode0() - LCDTicks) << doubleSpeedShifter
                        if ( (temp_var <= currentClocks || currentClocks == -1)) {
                            currentClocks = temp_var
                        }
                    }
                    if ( (mode1TriggerSTAT && (interruptsEnabled & 0x1) == 0)) {
                        if(modeSTAT == 1){
                            temp_var = ((456 * ((298 ) - actualScanLine)) - LCDTicks) << doubleSpeedShifter
                        }else{
                            temp_var = ((456 * ((144) - actualScanLine)) - LCDTicks) << doubleSpeedShifter
                        }
                        if ( (temp_var <= currentClocks || currentClocks == -1)) {
                            currentClocks = temp_var
                        }
                    }
                    if ( (mode2TriggerSTAT)) {
                        if(actualScanLine >= 143) {
                            temp_var = (( (456 * (154 - actualScanLine)) ) - LCDTicks) << doubleSpeedShifter
                        }else{
                            temp_var = ((456) - LCDTicks) << doubleSpeedShifter
                        }
                        if ( (temp_var <= currentClocks || currentClocks == -1)) {
                            currentClocks = temp_var
                        }
                    }
                    if ( (LYCMatchTriggerSTAT && memory[0xFF45] <= 153)) {
                        temp_var = (clocksUntilLYCMatch() - LCDTicks) << doubleSpeedShifter
                        if ( (temp_var <= currentClocks || currentClocks == -1)) {
                            currentClocks = temp_var
                        }
                    }
                }
            }
            if ( (TIMAEnabled && (interruptsEnabled & 0x4) == 0x4)) {
                //CPU timer IRQ prediction:
                temp_var = ((0x100 - memory[0xFF05]) * TACClocker) - timerTicks
                if ( (temp_var <= currentClocks || currentClocks == -1)) {
                    currentClocks = temp_var
                }
            }
            if ( (serialTimer > 0 && (interruptsEnabled & 0x8) == 0x8)) {
                //Serial IRQ prediction:
                if ( (serialTimer <= currentClocks || currentClocks == -1)) {
                    currentClocks = serialTimer
                }
            }
        }
        else {
            currentClocks = remainingClocks
        }
        let maxClocks = Int64(CPUCyclesTotal - emulatorTicks) << doubleSpeedShifter
        if ( (currentClocks >= 0)) {
            if ( (currentClocks <= maxClocks)) {
                //Exit out of HALT normally:
                CPUTicks = max(currentClocks, CPUTicks)
                updateCoreFull()
                halt = false
                CPUTicks = 0
            }
            else {
                //Still in HALT, clock only up to the clocks specified per iteration:
                CPUTicks = max(maxClocks, CPUTicks)
                remainingClocks = currentClocks - CPUTicks
            }
        }
        else {
            //Still in HALT, clock only up to the clocks specified per iteration:
            //Will stay in HALT forever (Stuck in HALT forever), but the APU and LCD are still clocked, so don't pause:
            CPUTicks += maxClocks
        }
    }
    //Memory Reading:
    func memoryRead( address: Int64) : Int64 {
        //Act as a wrapper for reading the returns from the compiled jumps to memory.
        return memoryReader[address](this, address)    //This seems to be faster than the usual if/else.
    }
    func memoryHighRead( address: Int64) : Int64 {
        //Act as a wrapper for reading the returns from the compiled jumps to memory.
        return memoryHighReader[address](this, address)    //This seems to be faster than the usual if/else.
    }
    func memoryReadJumpCompile() {
        
        //Faster in some browsers, since we are doing less conditionals overall by implementing them in advance.
        for ( index in 0x0000..0xFFFF+1) {
            if ( (index < 0x4000)) {
                memoryReader[index] = memoryReadNormal
            }
            else if ( (index < 0x8000)) {
                memoryReader[index] = memoryReadROM
            }
            else if ( (index < 0x9800)) {
                if(cGBC){
                    memoryReader[index] = VRAMDATAReadCGBCPU 
                }else{
                    memoryReader[index] =  VRAMDATAReadDMGCPU
                }
            }
            else if ( (index < 0xA000)) {
                if(cGBC){
                    memoryReader[index] =  VRAMCHRReadCGBCPU 
                }else{
                    memoryReader[index] = VRAMCHRReadDMGCPU  
                }
            }
            else if ( (index >= 0xA000 && index < 0xC000)) {
                if ( ((numRAMBanks == 1 / 16 && index < 0xA200) || numRAMBanks >= 1)) {
                    if ( (cMBC7)) {
                        memoryReader[index] = memoryReadMBC7
                    }
                    else if ( (!cMBC3)) {
                        memoryReader[index] = memoryReadMBC
                    }
                    else {
                        //MBC3 RTC + RAM:
                        memoryReader[index] = memoryReadMBC3
                    }
                }
                else {
                    memoryReader[index] = memoryReadBAD
                }
            }
            else if ( (index >= 0xC000 && index < 0xE000)) {
                if ( (!cGBC || index < 0xD000)) {
                    memoryReader[index] = memoryReadNormal
                }
                else {
                    memoryReader[index] = memoryReadGBCMemory
                }
            }
            else if ( (index >= 0xE000 && index < 0xFE00)) {
                if ( (!cGBC || index < 0xF000)) {
                    memoryReader[index] = memoryReadECHONormal
                }
                else {
                    memoryReader[index] = memoryReadECHOGBCMemory
                }
            }
            else if ( (index < 0xFEA0)) {
                memoryReader[index] = memoryReadOAM
            }
            else if ( (cGBC && index >= 0xFEA0 && index < 0xFF00)) {
                memoryReader[index] = memoryReadNormal
            }
            else if ( (index >= 0xFF00)) {
                match ( (index)) {
                case 0xFF00=>
                    //JOYPAD:
                    memoryReader[0xFF00] = { parentObj, address =>
                        return 0xC0 | parentObj.memory[0xFF00]  //Top nibble returns as set.
                    }
                    memoryHighReader[0] = memoryReader[0xFF00]
                    
                case 0xFF01=>
                    //SB
                    memoryReader[0xFF01] = { parentObj, address =>
                        if(parentObj.memory[0xFF02] < 0x80){
                            return  parentObj.memory[0xFF01] 
                        }else{
                            return  0xFF
                        }                       
                    }
                    memoryHighReader[0x01] = memoryReader[0xFF01]
                    
                case 0xFF02=>
                    //SC
                    if ( (cGBC)) {
                        memoryReader[0xFF02] = { parentObj, address =>
                            if(parentObj.serialTimer <= 0){
                                return (0x7C ) | parentObj.memory[0xFF02]
                            }else{
                                return ( 0xFC) | parentObj.memory[0xFF02]
                            }
                        }
                        memoryHighReader[0x02] = memoryReader[0xFF02]
                    }
                    else {
                        memoryReader[0xFF02] = { parentObj, address =>
                            if(parentObj.serialTimer <= 0){
                                return ( 0x7E ) | parentObj.memory[0xFF02]
                            }else{
                                return ( 0xFE) | parentObj.memory[0xFF02]
                            }
                        }
                        memoryHighReader[0x02] = memoryReader[0xFF02]
                    }
                    
                case 0xFF04=>
                    //DIV
                    memoryReader[0xFF04] = { parentObj, address =>
                        parentObj.memory[0xFF04] = (parentObj.memory[0xFF04] + (parentObj.DIVTicks >> 8)) & 0xFF
                        parentObj.DIVTicks &= 0xFF
                        return parentObj.memory[0xFF04]
                    }
                    memoryHighReader[0x04] = memoryReader[0xFF04]
                    
                case 0xFF07=>
                    memoryReader[0xFF07] = { parentObj, address =>
                        return 0xF8 | parentObj.memory[0xFF07]
                    }
                    memoryHighReader[0x07] = memoryReader[0xFF07]
                    
                case 0xFF0F=>
                    //IF
                    memoryReader[0xFF0F] = { parentObj, address =>
                        return 0xE0 | parentObj.interruptsRequested
                    }
                    memoryHighReader[0x0F] = memoryReader[0xFF0F]
                    
                case 0xFF10=>
                    memoryReader[0xFF10] = { parentObj, address =>
                        return 0x80 | parentObj.memory[0xFF10]
                    }
                    memoryHighReader[0x10] = memoryReader[0xFF10]
                    
                case 0xFF11=>
                    memoryReader[0xFF11] = { parentObj, address =>
                        return 0x3F | parentObj.memory[0xFF11]
                    }
                    memoryHighReader[0x11] = memoryReader[0xFF11]
                    
                case 0xFF13=>
                    memoryHighReader[0x13] = memoryReadBAD
                    memoryReader[0xFF13] = memoryReadBAD
                    
                case 0xFF14=>
                    memoryReader[0xFF14] = { parentObj, address =>
                        return 0xBF | parentObj.memory[0xFF14]
                    }
                    memoryHighReader[0x14] = memoryReader[0xFF14]
                   
                case 0xFF16=>
                    memoryReader[0xFF16] = { parentObj, address =>
                        return 0x3F | parentObj.memory[0xFF16]
                    }
                    memoryHighReader[0x16] = memoryReader[0xFF16]
                    
                case 0xFF18=>
                    memoryHighReader[0x18] = memoryReadBAD
                    memoryReader[0xFF18] = memoryReadBAD
                    
                case 0xFF19=>
                    memoryReader[0xFF19] = { parentObj, address =>
                        return 0xBF | parentObj.memory[0xFF19]
                    }
                    memoryHighReader[0x19] = memoryReader[0xFF19]
                    
                case 0xFF1A=>
                    memoryReader[0xFF1A] = { parentObj, address =>
                        return 0x7F | parentObj.memory[0xFF1A]
                    }
                    memoryHighReader[0x1A] = memoryReader[0xFF1A]
                    
                case 0xFF1B=>
                    memoryHighReader[0x1B] =  memoryReadBAD
                    memoryReader[0xFF1B] = memoryReadBAD
                    
                case 0xFF1C=>
                    memoryReader[0xFF1C] = { parentObj, address =>
                        return 0x9F | parentObj.memory[0xFF1C]
                    }
                    memoryHighReader[0x1C] = memoryReader[0xFF1C]
                    
                case 0xFF1D=>
                    memoryReader[0xFF1D] = { parentObj, address =>
                        return 0xFF
                    }
                    memoryHighReader[0x1D] = memoryReader[0xFF1D]
                    
                case 0xFF1E=>
                    memoryReader[0xFF1E] = { parentObj, address =>
                        return 0xBF | parentObj.memory[0xFF1E]
                    }
                    memoryHighReader[0x1E] = memoryReader[0xFF1E]
                    
                case 0xFF1F| 0xFF20=>
                    memoryHighReader[index & 0xFF] = memoryReadBAD
                    memoryReader[index] = memoryReadBAD
                    
                case 0xFF23=>
                    memoryReader[0xFF23] = { parentObj, address =>
                        return 0xBF | parentObj.memory[0xFF23]
                    }
                    memoryHighReader[0x23] = memoryReader[0xFF23]
                    
                case 0xFF26=>
                    memoryReader[0xFF26] = { parentObj, address =>
                        parentObj.audioJIT()
                        return 0x70 | parentObj.memory[0xFF26]
                    }
                    memoryHighReader[0x26] = memoryReader[0xFF26]
                    
                case 0xFF27|0xFF28|0xFF29|0xFF2A|0xFF2B|0xFF2C|0xFF2D|0xFF2E|0xFF2F=>
                    memoryReader[index] = memoryReadBAD
                    memoryHighReader[index & 0xFF] = memoryReader[index]
                    
                case 0xFF30|
                    0xFF31|0xFF32|0xFF33|0xFF34|0xFF35|0xFF36|0xFF37|0xFF38|0xFF39|0xFF3A|0xFF3B|0xFF3C|0xFF3D|0xFF3E|0xFF3F=>
                    memoryReader[index] = { parentObj, address => 
                        if(parentObj.channel3canPlay){
                            return ( parentObj.memory[0xFF00 | (parentObj.channel3lastSampleLookup >> 1)] ) 
                        }else{
                            return ( parentObj.memory[address])
                        }
                    }
                    memoryHighReader[index & 0xFF] = { parentObj, address =>
                        if(parentObj.channel3canPlay){
                            return ( parentObj.memory[0xFF00 | address])
                        }else{
                            return ( parentObj.memory[0xFF00 | address])
                        }
                    }
                    
                case 0xFF41=>
                    memoryReader[0xFF41] = { parentObj, address =>
                        return 0x80 | parentObj.memory[0xFF41] | parentObj.modeSTAT
                    }
                    memoryHighReader[0x41] = memoryReader[0xFF41]
                    
                case 0xFF42=>
                    memoryReader[0xFF42] = { parentObj, address =>
                        return parentObj.backgroundY
                    }
                    memoryHighReader[0x42] = memoryReader[0xFF42]
                    
                case 0xFF43=>
                    memoryReader[0xFF43] = { parentObj, address =>
                        return parentObj.backgroundX
                    }
                    memoryHighReader[0x43] = memoryReader[0xFF43]
                    
                case 0xFF44=>
                    memoryReader[0xFF44] = { parentObj, address =>
                        if(parentObj.LCDisOn){
                            return ( parentObj.memory[0xFF44])
                        }else{
                            return (0)
                        }
                    }
                    memoryHighReader[0x44] = memoryReader[0xFF44]
                    
                case 0xFF4A=>
                    //WY
                    memoryReader[0xFF4A] = { parentObj, address =>
                        return parentObj.windowY
                    }
                    memoryHighReader[0x4A] = memoryReader[0xFF4A]
                    
                case 0xFF4F=>
                    memoryReader[0xFF4F] = { parentObj, address =>
                        return parentObj.currVRAMBank
                    }
                    memoryHighReader[0x4F] = memoryReader[0xFF4F]
                    
                case 0xFF55=>
                    if ( (cGBC)) {
                        memoryReader[0xFF55] = { parentObj, address =>
                            if ( (!parentObj.LCDisOn && parentObj.hdmaRunning)) {  //Undocumented behavior alert: HDMA becomes GDMA when LCD is off (Worms Armageddon Fix).
                                //DMA
                                parentObj.DMAWrite((parentObj.memory[0xFF55] & 0x7F) + 1)
                                parentObj.memory[0xFF55] = 0xFF  //Transfer completed.
                                parentObj.hdmaRunning = false
                            }
                            return parentObj.memory[0xFF55]
                        }
                        memoryHighReader[0x55] = memoryReader[0xFF55]
                    }
                    else {
                        memoryReader[0xFF55] = memoryReadNormal
                        memoryHighReader[0x55] = memoryHighReadNormal
                    }
                    
                case 0xFF56=>
                    if ( (cGBC)) {
                        memoryReader[0xFF56] = { parentObj, address =>
                            
                            if(parentObj.memory[0xFF56] >= 0xC0){
                                return 0x3C | ( (0x2 | (parentObj.memory[0xFF56] & 0xC1)) )
                            }else{
                                return 0x3C | ( (parentObj.memory[0xFF56] & 0xC3))
                            }
                        }
                        memoryHighReader[0x56] = memoryReader[0xFF56]
                    }
                    else {
                        memoryReader[0xFF56] = memoryReadNormal
                        memoryHighReader[0x56] = memoryHighReadNormal
                    }
                    
                case 0xFF6C=>
                    if ( (cGBC)) {
                        memoryReader[0xFF6C] = { parentObj, address =>
                            return 0xFE | parentObj.memory[0xFF6C]
                        }
                        memoryHighReader[0x6C] = memoryReader[0xFF6C]
                    }
                    else {
                        memoryReader[0xFF6C] = memoryReadBAD
                        memoryHighReader[0x6C] = memoryReadBAD
                    }
                    
                case 0xFF70=>
                    if ( (cGBC)) {
                        //SVBK
                        memoryReader[0xFF70] = { parentObj, address =>
                            return 0x40 | parentObj.memory[0xFF70]
                        }
                        memoryHighReader[0x70] = memoryReader[0xFF70]
                    }
                    else {
                        memoryReader[0xFF70] = memoryReadBAD
                        memoryHighReader[0x70] = memoryReadBAD
                    }
                    
                case 0xFF75=>
                    memoryReader[0xFF75] = { parentObj, address =>
                        return 0x8F | parentObj.memory[0xFF75]
                    }
                    memoryHighReader[0x75] = memoryReader[0xFF75]
                    
                case 0xFF76| 0xFF77=>
                    memoryReader[index] = { parentObj, address =>
                        return 0
                    }
                    memoryHighReader[index & 0xFF] = memoryReader[index]
                    
                case 0xFFFF=>
                    //IE
                    memoryReader[0xFFFF] = { parentObj, address =>
                        return parentObj.interruptsEnabled
                    }
                    memoryHighReader[0xFF] = memoryReader[0xFFFF]
                    
                case _ =>
                    memoryReader[index] = memoryReadNormal
                    memoryHighReader[index & 0xFF] = memoryHighReadNormal
                }
            }
            else {
                memoryReader[index] = memoryReadBAD
            }
        }
    }
    func memoryReadNormal( parentObj: GameBoyCore,  address: Int64) : Int64 {
        return parentObj.memory[address]
    }
    func memoryHighReadNormal( parentObj: GameBoyCore,  address: Int64) : Int64 {
        return parentObj.memory[0xFF00 | address]
    }
    func memoryReadROM( parentObj: GameBoyCore,  address: Int64) : Int64 {
        return parentObj.ROM[parentObj.currentROMBank + address]
    }
    func memoryReadMBC( parentObj: GameBoyCore,  address: Int64) : Int64 {
        //Switchable RAM
        if ( (parentObj.MBCRAMBanksEnabled || (settings[10] as Bool).getOrThrow())) {
            return parentObj.MBCRam[address + parentObj.currMBCRAMBankPosition]
        }
        //cout("Reading from disabled RAM.", 1)
        return 0xFF
    }
    func memoryReadMBC7( parentObj: GameBoyCore,  address: Int64) : Int64 {
        
        //Switchable RAM
        if ( (parentObj.MBCRAMBanksEnabled || (settings[10] as Bool).getOrThrow())) {
            match ( (address)) {
            case 0xA000|0xA060|0xA070=>
                return 0
            case 0xA080=>
                //TODO: Gyro Control Register
                return 0
            case 0xA050=>
                //Y High Byte
                return parentObj.highY
            case 0xA040=>
                //Y Low Byte
                return parentObj.lowY
            case 0xA030=>
                //X High Byte
                return parentObj.highX
            case 0xA020=>
                //X Low Byte:
                return parentObj.lowX
            case _ =>
                return parentObj.MBCRam[address + parentObj.currMBCRAMBankPosition]
            }
        }
        //cout("Reading from disabled RAM.", 1)
        return 0xFF
    }
    func memoryReadMBC3( parentObj: GameBoyCore,  address: Int64) : Int64 {
        deBugLog("This is memoryReadMBC3")
        //Switchable RAM
        if ( (parentObj.MBCRAMBanksEnabled || (settings[10] as Bool).getOrThrow())) {
            match ( (parentObj.currMBCRAMBank)) {
            case 0x00|0x01|0x02|0x03=>
                return parentObj.MBCRam[address + parentObj.currMBCRAMBankPosition]
            case 0x08=>
                return parentObj.latchedSeconds
            case 0x09=>
                return parentObj.latchedMinutes
            case 0x0A=>
                return parentObj.latchedHours
            case 0x0B=>
                return parentObj.latchedLDays
            case 0x0C=>
                var t1 = 0
                if(parentObj.RTCDayOverFlow){t1 = 0x80}
                var t2 = 0
                if(parentObj.RTCHALT){t2 = 0x40}
                return (t1 + t2) + parentObj.latchedHDays
            case _ =>
                return 0
            }
        }
        //cout("Reading from invalid or disabled RAM.", 1)
        return 0xFF
    }
    func memoryReadGBCMemory( parentObj: GameBoyCore,  address: Int64) : Int64 {
        return parentObj.GBCMemory[address + parentObj.gbcRamBankPosition]
    }
    func memoryReadOAM( parentObj: GameBoyCore,  address: Int64) : Int64 {
        if(parentObj.modeSTAT > 1){
            return  0xFF
        }else{
            return parentObj.memory[address]
        }
    }
    func memoryReadECHOGBCMemory( parentObj: GameBoyCore,  address: Int64) : Int64 {
        return parentObj.GBCMemory[address + parentObj.gbcRamBankPositionECHO]
    }
    func memoryReadECHONormal( parentObj: GameBoyCore,  address: Int64) : Int64 {
        return parentObj.memory[address - 0x2000]
    }
    func memoryReadBAD( parentObj: GameBoyCore,  address: Int64) : Int64 {
        return 0xFF
    }
    func VRAMDATAReadCGBCPU( parentObj: GameBoyCore,  address: Int64) : Int64 {
        //CPU Side Reading The VRAM (Optimized for GameBoy Color)
        var t1 = parentObj.VRAM[address & 0x1FFF]
        if(parentObj.currVRAMBank == 0){t1= parentObj.memory[address] }
        if(parentObj.modeSTAT > 2){
            return 0xFF 
        }else{
            return t1
        }
    }
    func VRAMDATAReadDMGCPU( parentObj: GameBoyCore,  address: Int64) : Int64 {
        //CPU Side Reading The VRAM (Optimized for classic GameBoy)
        if(parentObj.modeSTAT > 2){
            return 0xFF 
        }else{
            return parentObj.memory[address]
        }
    }
    func VRAMCHRReadCGBCPU( parentObj: GameBoyCore,  address: Int64) : Int64 {
        //CPU Side Reading the Character Data Map:
        if(parentObj.modeSTAT > 2){
            return 0xFF 
        }
        return parentObj.BGCHRCurrentBank.getOrThrow().array[address & 0x7FF]
    }
    func VRAMCHRReadDMGCPU( parentObj: GameBoyCore,  address: Int64) : Int64 {
        //CPU Side Reading the Character Data Map:
        if(parentObj.modeSTAT > 2){
            return 0xFF
        }
        return parentObj.BGCHRBank1.array[address & 0x7FF]
    }
    func setCurrentMBC1ROMBank() {
        
        //Read the cartridge ROM data from RAM memory:
        match ( (ROMBank1offs)) {
        case 0x00|0x20|0x40|0x60=>
            //Bank calls for 0x00, 0x20, 0x40, and 0x60 are really for 0x01, 0x21, 0x41, and 0x61.
            currentROMBank = (ROMBank1offs % ROMBankEdge) << 14
            
        case _ =>
            currentROMBank = ((ROMBank1offs % ROMBankEdge) - 1) << 14
        }
    }
    func setCurrentMBC2AND3ROMBank() {
        //Read the cartridge ROM data from RAM memory:
        //Only map bank 0 to bank 1 here (MBC2 is like MBC1, but can only do 16 banks, so only the bank 0 quirk appears for MBC2):
        currentROMBank = max((ROMBank1offs % ROMBankEdge) - 1, 0) << 14
    }
    func setCurrentMBC5ROMBank() {
        //Read the cartridge ROM data from RAM memory:
        currentROMBank = ((ROMBank1offs % ROMBankEdge) - 1) << 14
    }
    //Memory Writing:
    func memoryWrite( address: Int64,  data: Int64) {
        //Act as a wrapper for writing by compiled jumps to specific memory writing functions.
        memoryWriter[address](this, address, data)
    }
    //0xFFXX fast path:
    func memoryHighWrite( address: Int64,  data: Int64) {
        //Act as a wrapper for writing by compiled jumps to specific memory writing functions.
        return memoryHighWriter[address](this, address, data)
    }
    func memoryWriteJumpCompile() {
        
        //Faster in some browsers, since we are doing less conditionals overall by implementing them in advance.
        for ( index in 0x0000..0xFFFF+1) {
            if ( (index < 0x8000)) {
                if ( (cMBC1)) {
                    if ( (index < 0x2000)) {
                        memoryWriter[index] = MBCWriteEnable
                    }
                    else if ( (index < 0x4000)) {
                        memoryWriter[index] = MBC1WriteROMBank
                    }
                    else if ( (index < 0x6000)) {
                        memoryWriter[index] = MBC1WriteRAMBank
                    }
                    else {
                        memoryWriter[index] = MBC1WriteType
                    }
                }
                else if ( (cMBC2)) {
                    if ( (index < 0x1000)) {
                        memoryWriter[index] = MBCWriteEnable
                    }
                    else if ( (index >= 0x2100 && index < 0x2200)) {
                        memoryWriter[index] = MBC2WriteROMBank
                    }
                    else {
                        memoryWriter[index] = cartIgnoreWrite
                    }
                }
                else if ( (cMBC3)) {
                    if ( (index < 0x2000)) {
                        memoryWriter[index] = MBCWriteEnable
                    }
                    else if ( (index < 0x4000)) {
                        memoryWriter[index] = MBC3WriteROMBank
                    }
                    else if ( (index < 0x6000)) {
                        memoryWriter[index] = MBC3WriteRAMBank
                    }
                    else {
                        memoryWriter[index] = MBC3WriteRTCLatch
                    }
                }
                else if ( (cMBC5 || cRUMBLE || cMBC7)) {
                    if ( (index < 0x2000)) {
                        memoryWriter[index] = MBCWriteEnable
                    }
                    else if ( (index < 0x3000)) {
                        memoryWriter[index] = MBC5WriteROMBankLow
                    }
                    else if ( (index < 0x4000)) {
                        memoryWriter[index] = MBC5WriteROMBankHigh
                    }
                    else if ( (index < 0x6000)) {
                        if(cRUMBLE){
                            memoryWriter[index] =  RUMBLEWriteRAMBank
                        }else{
                            memoryWriter[index] =  MBC5WriteRAMBank
                        }
                    }
                    else {
                        memoryWriter[index] = cartIgnoreWrite
                    }
                }
                else if ( (cHuC3)) {
                    if ( (index < 0x2000)) {
                        memoryWriter[index] = MBCWriteEnable
                    }
                    else if ( (index < 0x4000)) {
                        memoryWriter[index] = MBC3WriteROMBank
                    }
                    else if ( (index < 0x6000)) {
                        memoryWriter[index] = HuC3WriteRAMBank
                    }
                    else {
                        memoryWriter[index] = cartIgnoreWrite
                    }
                }
                else {
                    memoryWriter[index] = cartIgnoreWrite
                }
            }
            else if ( (index < 0x9000)) {
                if(cGBC){
                    memoryWriter[index] = VRAMGBCDATAWrite 
                }else{
                    memoryWriter[index] = VRAMGBDATAWrite
                }
            }
            else if ( (index < 0x9800)) {
            if(cGBC){
                    memoryWriter[index] = VRAMGBCDATAWrite 
                }else{
                    memoryWriter[index] = VRAMGBDATAUpperWrite
                }
            }
            else if ( (index < 0xA000)) {
                if(cGBC){
                    memoryWriter[index] = VRAMGBCCHRMAPWrite 
                }else{
                    memoryWriter[index] = VRAMGBCHRMAPWrite
                }
            }
            else if ( (index < 0xC000)) {
                if ( ((numRAMBanks == 1 / 16 && index < 0xA200) || numRAMBanks >= 1)) {
                    if ( (!cMBC3)) {
                        memoryWriter[index] = memoryWriteMBCRAM
                    }
                    else {
                        //MBC3 RTC + RAM:
                        memoryWriter[index] = memoryWriteMBC3RAM
                    }
                }
                else {
                    memoryWriter[index] = cartIgnoreWrite
                }
            }
            else if ( (index < 0xE000)) {
                if ( (cGBC && index >= 0xD000)) {
                    memoryWriter[index] = memoryWriteGBCRAM
                }
                else {
                    memoryWriter[index] = memoryWriteNormal
                }
            }
            else if ( (index < 0xFE00)) {
                if ( (cGBC && index >= 0xF000)) {
                    memoryWriter[index] = memoryWriteECHOGBCRAM
                }
                else {
                    memoryWriter[index] = memoryWriteECHONormal
                }
            }
            else if ( (index <= 0xFEA0)) {
                memoryWriter[index] = memoryWriteOAMRAM
            }
            else if ( (index < 0xFF00)) {
                if ( (cGBC)) {                      //Only GBC has access to this RAM.
                    memoryWriter[index] = memoryWriteNormal
                }
                else {
                    memoryWriter[index] = cartIgnoreWrite
                }
            }
            else {
                //Start the I/O initialization by filling in the slots as normal memory:
                memoryWriter[index] = memoryWriteNormal
                memoryHighWriter[index & 0xFF] = memoryHighWriteNormal
            }
        }
        registerWriteJumpCompile()        //Compile the I/O write functions separately...
    }
    func MBCWriteEnable( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        deBugLog("This is MBCWriteEnable")
        //MBC RAM Bank Enable/Disable:
        parentObj.MBCRAMBanksEnabled = ((data & 0x0F) == 0x0A)  //If lower nibble is 0x0A, then enable, otherwise disable.
    }
    func MBC1WriteROMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        
        //MBC1 ROM bank switching:
        parentObj.ROMBank1offs = (parentObj.ROMBank1offs & 0x60) | (data & 0x1F)
        parentObj.setCurrentMBC1ROMBank()
    }
    func MBC1WriteRAMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
         
        //MBC1 RAM bank switching
        if ( (parentObj.MBC1Mode)) {
            //4/32 Mode
            parentObj.currMBCRAMBank = data & 0x03
            parentObj.currMBCRAMBankPosition = (parentObj.currMBCRAMBank << 13) - 0xA000
        }
        else {
            //16/8 Mode
            parentObj.ROMBank1offs = ((data & 0x03) << 5) | (parentObj.ROMBank1offs & 0x1F)
            parentObj.setCurrentMBC1ROMBank()
        }
    }
    func MBC1WriteType( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //MBC1 mode setting:
        parentObj.MBC1Mode = ((data & 0x1) == 0x1)
        if ( (parentObj.MBC1Mode)) {
            parentObj.ROMBank1offs &= 0x1F
            parentObj.setCurrentMBC1ROMBank()
        }
        else {
            parentObj.currMBCRAMBank = 0
            parentObj.currMBCRAMBankPosition = -0xA000
        }
    }
    func MBC2WriteROMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //MBC2 ROM bank switching:
        parentObj.ROMBank1offs = data & 0x0F
        parentObj.setCurrentMBC2AND3ROMBank()
    }
    func MBC3WriteROMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //MBC3 ROM bank switching:
        parentObj.ROMBank1offs = data & 0x7F
        parentObj.setCurrentMBC2AND3ROMBank()
    }
    func MBC3WriteRAMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        parentObj.currMBCRAMBank = data
        if ( (data < 4)) {
            //MBC3 RAM bank switching
            parentObj.currMBCRAMBankPosition = (parentObj.currMBCRAMBank << 13) - 0xA000
        }
    }
    func MBC3WriteRTCLatch( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        if ( (data == 0)) {
            parentObj.RTCisLatched = false
        }
        else if ( (!parentObj.RTCisLatched)) {
            //Copy over the current RTC time for reading.
            parentObj.RTCisLatched = true
            parentObj.latchedSeconds = parentObj.RTCSeconds | 0
            parentObj.latchedMinutes = parentObj.RTCMinutes
            parentObj.latchedHours = parentObj.RTCHours
            parentObj.latchedLDays = (parentObj.RTCDays & 0xFF)
            parentObj.latchedHDays = parentObj.RTCDays >> 8
        }
    }
    func MBC5WriteROMBankLow( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //MBC5 ROM bank switching:
        parentObj.ROMBank1offs = (parentObj.ROMBank1offs & 0x100) | data
        parentObj.setCurrentMBC5ROMBank()
    }
    func MBC5WriteROMBankHigh( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //MBC5 ROM bank switching (by least significant bit):
        parentObj.ROMBank1offs  = ((data & 0x01) << 8) | (parentObj.ROMBank1offs & 0xFF)
        parentObj.setCurrentMBC5ROMBank()
    }
    func MBC5WriteRAMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //MBC5 RAM bank switching
        parentObj.currMBCRAMBank = data & 0xF
        parentObj.currMBCRAMBankPosition = (parentObj.currMBCRAMBank << 13) - 0xA000
    }
    func RUMBLEWriteRAMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //MBC5 RAM bank switching
        //Like MBC5, but bit 3 of the lower nibble is used for rumbling and bit 2 is ignored.
        parentObj.currMBCRAMBank = data & 0x03
        parentObj.currMBCRAMBankPosition = (parentObj.currMBCRAMBank << 13) - 0xA000
    }
    func HuC3WriteRAMBank( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //HuC3 RAM bank switching
        parentObj.currMBCRAMBank = data & 0x03
        parentObj.currMBCRAMBankPosition = (parentObj.currMBCRAMBank << 13) - 0xA000
    }
    func cartIgnoreWrite( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        //We might have encountered illegal RAM writing or such, so just do nothing...
    }
    func memoryWriteNormal( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        parentObj.memory[address] = data
    }
    func memoryHighWriteNormal( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        parentObj.memory[0xFF00 | address] = data
    }
    func memoryWriteMBCRAM( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        if ( (parentObj.MBCRAMBanksEnabled || (settings[10] as Bool).getOrThrow())) {
            parentObj.MBCRam[address + parentObj.currMBCRAMBankPosition] = data
        }
    }
    func memoryWriteMBC3RAM( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        
        if ( (parentObj.MBCRAMBanksEnabled || (settings[10] as Bool).getOrThrow())) {
            match ( (parentObj.currMBCRAMBank)) {
            case 0x00|0x01|0x02|0x03=>
                parentObj.MBCRam[address + parentObj.currMBCRAMBankPosition] = data
                
            case 0x08=>
                if ( (data < 60)) {
                    parentObj.RTCSeconds = data
                }
                else {
                    cout("(Bank #" + String(Rune(parentObj.currMBCRAMBank)) + ") RTC write out of range: " + String(Rune(data)), 1)
                }
                
            case 0x09=>
                if ( (data < 60)) {
                    parentObj.RTCMinutes = data
                }
                else {
                    cout("(Bank #" + String(Rune(parentObj.currMBCRAMBank)) + ") RTC write out of range: " + String(Rune(data)), 1)
                }
                
            case 0x0A=>
                if ( (data < 24)) {
                    parentObj.RTCHours = data
                }
                else {
                    cout("(Bank #" + String(Rune(parentObj.currMBCRAMBank)) + ") RTC write out of range: " + String(Rune(data)), 1)
                }
                
            case 0x0B=>
                parentObj.RTCDays = (data & 0xFF) | (parentObj.RTCDays & 0x100)
                
            case 0x0C=>
                parentObj.RTCDayOverFlow = (data > 0x7F)
                parentObj.RTCHALT = (data & 0x40) == 0x40
                parentObj.RTCDays = ((data & 0x1) << 8) | (parentObj.RTCDays & 0xFF)
                
            case _ =>
                cout("Invalid MBC3 bank address selected: " + String(Rune(parentObj.currMBCRAMBank)), 0)
            }
        }
    }
    func memoryWriteGBCRAM( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        parentObj.GBCMemory[address + parentObj.gbcRamBankPosition] = data
    }
    func memoryWriteOAMRAM( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        if ( (parentObj.modeSTAT < 2)) {    //OAM RAM cannot be written to in mode 2 & 3
            if ( (parentObj.memory[address] != data)) {
                parentObj.graphicsJIT()
                parentObj.memory[address] = data
            }
        }
    }
    func memoryWriteECHOGBCRAM( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        parentObj.GBCMemory[address + parentObj.gbcRamBankPositionECHO] = data
    }
    func memoryWriteECHONormal( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        parentObj.memory[address - 0x2000] = data
    }
    func VRAMGBDATAWrite( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        if ( (parentObj.modeSTAT < 3)) {  //VRAM cannot be written to during mode 3
            if ( (parentObj.memory[address] != data)) {
                //JIT the graphics render queue:
                parentObj.graphicsJIT()
                parentObj.memory[address] = data
                parentObj.generateGBOAMTileLine(address)
            }
        }
    }
    func VRAMGBDATAUpperWrite( parentObj: GameBoyCore,  address: Int64,  data: Int64) {
        if ( (parentObj.modeSTAT < 3)) {  //VRAM cannot be written to during mode 3
            if ( (parentObj.memory[address] != data)) {
                //JIT the graphics render queue:
                parentObj.graphicsJIT()
                parentObj.memory[address] = data
                parentObj.generateGBTileLine(address)
            }
        }
    }
    func VRAMGBCDATAWrite( parentObj: GameBoyCore,  addressTemp: Int64,  data: Int64) {
        var address = addressTemp
        if ( (parentObj.modeSTAT < 3)) {  //VRAM cannot be written to during mode 3
            if ( (parentObj.currVRAMBank == 0)) {
                if ( (parentObj.memory[address] != data)) {
                    //JIT the graphics render queue:
                    parentObj.graphicsJIT()
                    parentObj.memory[address] = data
                    parentObj.generateGBCTileLineBank1(address)
                }
            }
            else {
                address &= 0x1FFF
                if ( parentObj.VRAM[address] != data) {
                    //JIT the graphics render queue:
                    parentObj.graphicsJIT()
                    parentObj.VRAM[address] = data
                    parentObj.generateGBCTileLineBank2(address)
                }
            }
        }
    }
    func VRAMGBCHRMAPWrite( parentObj: GameBoyCore,  addressTemp: Int64,  data: Int64) {
        var address = addressTemp
        if ( (parentObj.modeSTAT < 3)) {  //VRAM cannot be written to during mode 3
            address &= 0x7FF
            if ( parentObj.BGCHRBank1.array[address] != data) {
                //JIT the graphics render queue:
                parentObj.graphicsJIT()
                parentObj.BGCHRBank1.array[address] = data
            }
        }
    }
    func VRAMGBCCHRMAPWrite( parentObj: GameBoyCore,  tempAddress: Int64,  data: Int64) {
        var address = tempAddress
        if ( (parentObj.modeSTAT < 3)) {  //VRAM cannot be written to during mode 3
            address &= 0x7FF
            if ( parentObj.BGCHRCurrentBank.getOrThrow().array[address] != data) {
                //JIT the graphics render queue:
                parentObj.graphicsJIT()
                parentObj.BGCHRCurrentBank.getOrThrow().array[address] = data
            }
        }
    }
    func DMAWrite( tilesToTransferTemp: Int64) {
        var tilesToTransfer = tilesToTransferTemp
        if ( (!halt)) {
            //Clock the CPU for the DMA transfer (CPU is halted during the transfer):
            CPUTicks += 4 | ((tilesToTransfer << 5) << doubleSpeedShifter)
        }
        //Source address of the transfer:
        var source = ((memory[0xFF51]) << 8) | (memory[0xFF52])
        //Destination address in the VRAM memory range:
        var destination = ((memory[0xFF53]) << 8) | (memory[0xFF54])
        //Creating some references:
        _ = memoryReader
        //JIT the graphics render queue:
        graphicsJIT()
        _ = memory
        //Determining which bank we're working on so we can optimize:
        if ( (currVRAMBank == 0)) {
            //DMA transfer for VRAM bank 0:
            do {
                if ( (destination < 0x1800)) {
                    memory[0x8000 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8001 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8002 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8003 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8004 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8005 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8006 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8007 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8008 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x8009 | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x800A | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x800B | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x800C | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x800D | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x800E | destination] = memoryReader[source](this, source)
                    source++
                    memory[0x800F | destination] = memoryReader[source](this, source)
                    source++
                    generateGBCTileBank1(destination)
                    destination += 0x10
                }
                else {
                    destination &= 0x7F0
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank1.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    destination = (destination + 0x1800) & 0x1FF0
                }
                source &= 0xFFF0
                tilesToTransfer -= 1
            } while (tilesToTransfer > 0)
        }
        else {
            _ = VRAM
            //DMA transfer for VRAM bank 1:
            do {
                if ( (destination < 0x1800)) {
                    VRAM[destination] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x1] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x2] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x3] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x4] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x5] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x6] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x7] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x8] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0x9] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0xA] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0xB] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0xC] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0xD] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0xE] = memoryReader[source](this, source)
                    source++
                    VRAM[destination | 0xF] = memoryReader[source](this, source)
                    source++
                    generateGBCTileBank2(destination)
                    destination += 0x10
                }
                else {
                    destination &= 0x7F0
                    BGCHRBank2.array[destination] = memoryReader[source](this, source) 
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    BGCHRBank2.array[destination] = memoryReader[source](this, source)
                    source++
                    destination++
                    destination = (destination + 0x1800) & 0x1FF0
                }
                source &= 0xFFF0
                tilesToTransfer -= 1
            } while (tilesToTransfer > 0)
        }
        //Update the HDMA registers to their next addresses:
        memory[0xFF51] = source >> 8
        memory[0xFF52] = source & 0xF0
        memory[0xFF53] = destination >> 8
        memory[0xFF54] = destination & 0xF0
    }
    func registerWriteJumpCompile() {
        
        //I/O Registers (GB + GBC):
        //JoyPad
        memoryWriter[0xFF00] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            var t1 = 0xF
            if((data & 0x20) == 0){t1 = Int64((parentObj.JoyPad >> 4))}
            var t2 = 0xF
            if((data & 0x10) == 0){t2 = Int64((parentObj.JoyPad & 0xF)) }
            parentObj.memory[0xFF00] = (data & 0x30) | ( t1 & t2)
        }
        memoryHighWriter[0] = memoryWriter[0xFF00]
        //SB (Serial Transfer Data)
        memoryWriter[0xFF01] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if (parentObj.memory[0xFF02] < 0x80) {  //Cannot write while ( a serial transfer is active.
                parentObj.memory[0xFF01] = data
            }
        }
        memoryHighWriter[0x1] = memoryWriter[0xFF01]
        //DIV
        memoryWriter[0xFF04] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.DIVTicks &= 0xFF  //Update DIV for realignment.
            parentObj.memory[0xFF04] = 0
        }
        memoryHighWriter[0x4] = memoryWriter[0xFF04]
        //TIMA
        memoryWriter[0xFF05] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.memory[0xFF05] = data
        }
        memoryHighWriter[0x5] = memoryWriter[0xFF05]
        //TMA
        memoryWriter[0xFF06] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.memory[0xFF06] = data
        }
        memoryHighWriter[0x6] = memoryWriter[0xFF06]
        //TAC
        memoryWriter[0xFF07] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.memory[0xFF07] = data & 0x07
            parentObj.TIMAEnabled = (data & 0x04) == 0x04
            if((data & 0x3) != 0){
                parentObj.TACClocker = Int64(pow(4.0,  Float64((data & 0x3)) )) << 2
            }else{
                parentObj.TACClocker = Int64(pow(4.0, 4.0)) << 2
            }
            //TODO: Find a way to not make a conditional in here...
        }
        memoryHighWriter[0x7] = memoryWriter[0xFF07]
        //IF (Int64errupt Request)
        memoryWriter[0xFF0F] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.interruptsRequested = data
            parentObj.checkIRQMatching()
        }
        memoryHighWriter[0xF] = memoryWriter[0xFF0F]
        memoryWriter[0xFF10] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                if ( (parentObj.channel1decreaseSweep && (data & 0x08) == 0)) {
                    if ( (parentObj.channel1numSweep != parentObj.channel1frequencySweepDivider)) {
                        parentObj.channel1SweepFault = true
                    }
                }
                parentObj.channel1lastTimeSweep = (data & 0x70) >> 4
                parentObj.channel1frequencySweepDivider = data & 0x07
                parentObj.channel1decreaseSweep = ((data & 0x08) == 0x08)
                parentObj.memory[0xFF10] = data
                parentObj.channel1EnableCheck()
            }
        }
        memoryHighWriter[0x10] = memoryWriter[0xFF10]
        memoryWriter[0xFF11] = { parentObj, address, tempData =>
            var data = tempData
            if ( (parentObj.soundMasterEnabled || !parentObj.cGBC)) {
                if ( (parentObj.soundMasterEnabled)) {
                    parentObj.audioJIT()
                }
                else {
                    data &= 0x3F
                }
                parentObj.channel1CachedDuty = parentObj.dutyLookup[data >> 6]
                parentObj.channel1totalLength = 0x40 - (data & 0x3F)
                parentObj.memory[0xFF11] = data & 0xC0
                parentObj.channel1EnableCheck()
            }
        }
        memoryHighWriter[0x11] = memoryWriter[0xFF11]
        memoryWriter[0xFF12] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                if ( (parentObj.channel1Enabled && parentObj.channel1envelopeSweeps == 0)) {
                    //Zombie Volume PAPU Bug:
                    if ( ((((parentObj.memory[0xFF12]) ^ data) & 0x8) == 0x8)) {
                        if ( (((parentObj.memory[0xFF12]) & 0x8) == 0)) {
                            if ( (((parentObj.memory[0xFF12]) & 0x7) == 0x7)) {
                                parentObj.channel1envelopeVolume += 2
                            }
                            else {
                                parentObj.channel1envelopeVolume += 1
                            }
                        }
                        parentObj.channel1envelopeVolume = (16 - parentObj.channel1envelopeVolume) & 0xF
                    }
                    else if ( (((parentObj.memory[0xFF12]) & 0xF) == 0x8)) {
                        parentObj.channel1envelopeVolume = (1 + parentObj.channel1envelopeVolume) & 0xF
                    }
                    parentObj.channel1OutputLevelCache()
                }
                parentObj.channel1envelopeType = ((data & 0x08) == 0x08)
                parentObj.memory[0xFF12] = data
                parentObj.channel1VolumeEnableCheck()
            }
        }
        memoryHighWriter[0x12] = memoryWriter[0xFF12]
        memoryWriter[0xFF13] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                parentObj.channel1frequency = (parentObj.channel1frequency & 0x700) | data
                parentObj.channel1FrequencyTracker = (0x800 - parentObj.channel1frequency) << 2
                parentObj.memory[0xFF13] = data
            }
        }
        memoryHighWriter[0x13] = memoryWriter[0xFF13]
        memoryWriter[0xFF14] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                parentObj.channel1consecutive = ((data & 0x40) == 0x0)
                parentObj.channel1frequency = ((data & 0x7) << 8) | (parentObj.channel1frequency & 0xFF)
                parentObj.channel1FrequencyTracker = (0x800 - parentObj.channel1frequency) << 2
                if ( (data > 0x7F)) {
                    //Reload 0xFF10:
                    parentObj.channel1timeSweep = parentObj.channel1lastTimeSweep
                    parentObj.channel1numSweep = parentObj.channel1frequencySweepDivider
                    //Reload 0xFF12:
                    let nr12 = parentObj.memory[0xFF12]
                    parentObj.channel1envelopeVolume = nr12 >> 4
                    parentObj.channel1OutputLevelCache()
                    parentObj.channel1envelopeSweepsLast = (nr12 & 0x7) - 1
                    if ( (parentObj.channel1totalLength == 0)) {
                        parentObj.channel1totalLength = 0x40
                    }
                    if ( (parentObj.channel1lastTimeSweep > 0 || parentObj.channel1frequencySweepDivider > 0)) {
                        parentObj.memory[0xFF26] |= 0x1
                    }
                    else {
                        parentObj.memory[0xFF26] &= 0xFE
                    }
                    if ( ((data & 0x40) == 0x40)) {
                        parentObj.memory[0xFF26] |= 0x1
                    }
                    parentObj.channel1ShadowFrequency = parentObj.channel1frequency
                    //Reset frequency overflow check + frequency sweep type check:
                    parentObj.channel1SweepFault = false
                    //Supposed to run immediately:
                    parentObj.runAudioSweep()
                }
                parentObj.channel1EnableCheck()
                parentObj.memory[0xFF14] = data & 0x40
            }
        }
        memoryHighWriter[0x14] = memoryWriter[0xFF14]
        memoryWriter[0xFF16] = { parentObj, address, tempData =>
            var data = tempData
            if ( (parentObj.soundMasterEnabled || !parentObj.cGBC)) {
                if ( (parentObj.soundMasterEnabled)) {
                    parentObj.audioJIT()
                }
                else {
                    data &= 0x3F
                }
                parentObj.channel2CachedDuty = parentObj.dutyLookup[data >> 6]
                parentObj.channel2totalLength = 0x40 - (data & 0x3F)
                parentObj.memory[0xFF16] = data & 0xC0
                parentObj.channel2EnableCheck()
            }
        }
        memoryHighWriter[0x16] = memoryWriter[0xFF16]
        memoryWriter[0xFF17] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                if ( (parentObj.channel2Enabled && parentObj.channel2envelopeSweeps == 0)) {
                    //Zombie Volume PAPU Bug:
                    if ( (((parentObj.memory[0xFF17] ^ data) & 0x8) == 0x8)) {
                        if ( ((parentObj.memory[0xFF17] & 0x8) == 0)) {
                            if ( ((parentObj.memory[0xFF17] & 0x7) == 0x7)) {
                                parentObj.channel2envelopeVolume += 2
                            }
                            else {
                                parentObj.channel2envelopeVolume += 1
                            }
                        }
                        parentObj.channel2envelopeVolume = (16 - parentObj.channel2envelopeVolume) & 0xF
                    }
                    else if ( ((parentObj.memory[0xFF17] & 0xF) == 0x8)) {
                        parentObj.channel2envelopeVolume = (1 + parentObj.channel2envelopeVolume) & 0xF
                    }
                    parentObj.channel2OutputLevelCache()
                }
                parentObj.channel2envelopeType = ((data & 0x08) == 0x08)
                parentObj.memory[0xFF17] = data
                parentObj.channel2VolumeEnableCheck()
            }
        }
        memoryHighWriter[0x17] = memoryWriter[0xFF17]
        memoryWriter[0xFF18] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                parentObj.channel2frequency = (parentObj.channel2frequency & 0x700) | data
                parentObj.channel2FrequencyTracker = (0x800 - parentObj.channel2frequency) << 2
                parentObj.memory[0xFF18] = data
            }
        }
        memoryHighWriter[0x18] = memoryWriter[0xFF18]
        memoryWriter[0xFF19] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                if ( (data > 0x7F)) {
                    //Reload 0xFF17:
                    let nr22 = parentObj.memory[0xFF17]
                    parentObj.channel2envelopeVolume = nr22 >> 4
                    parentObj.channel2OutputLevelCache()
                    parentObj.channel2envelopeSweepsLast = (nr22 & 0x7) - 1
                    if ( (parentObj.channel2totalLength == 0)) {
                        parentObj.channel2totalLength = 0x40
                    }
                    if ( ((data & 0x40) == 0x40)) {
                        parentObj.memory[0xFF26] |= 0x2
                    }
                }
                parentObj.channel2consecutive = ((data & 0x40) == 0x0)
                parentObj.channel2frequency = ((data & 0x7) << 8) | (parentObj.channel2frequency & 0xFF)
                parentObj.channel2FrequencyTracker = (0x800 - parentObj.channel2frequency) << 2
                parentObj.memory[0xFF19] = data & 0x40
                parentObj.channel2EnableCheck()
            }
        }
        memoryHighWriter[0x19] = memoryWriter[0xFF19]
        memoryWriter[0xFF1A] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                if ( (!parentObj.channel3canPlay && data >= 0x80)) {
                    parentObj.channel3lastSampleLookup = 0
                    parentObj.channel3UpdateCache()
                }
                parentObj.channel3canPlay = (data > 0x7F)
                if ( (parentObj.channel3canPlay && parentObj.memory[0xFF1A] > 0x7F && !parentObj.channel3consecutive)) {
                    parentObj.memory[0xFF26] |= 0x4
                }
                parentObj.memory[0xFF1A] = data & 0x80
                //parentObj.channel3EnableCheck()
            }
        }
        memoryHighWriter[0x1A] = memoryWriter[0xFF1A]
        memoryWriter[0xFF1B] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled || !parentObj.cGBC)) {
                if ( (parentObj.soundMasterEnabled)) {
                    parentObj.audioJIT()
                }
                parentObj.channel3totalLength = 0x100 - data
                parentObj.memory[0xFF1B] = data
                parentObj.channel3EnableCheck()
            }
        }
        memoryHighWriter[0x1B] = memoryWriter[0xFF1B]
        memoryWriter[0xFF1C] = { parentObj, address, tempData =>
            var data = tempData
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                data &= 0x60
                parentObj.memory[0xFF1C] = data
                if(data == 0){
                    parentObj.channel3patternType =  4 
                }
                parentObj.channel3patternType = ((data >> 5) - 1)
            }
        }
        memoryHighWriter[0x1C] = memoryWriter[0xFF1C]
        memoryWriter[0xFF1D] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                parentObj.channel3frequency = (parentObj.channel3frequency & 0x700) | data
                parentObj.channel3FrequencyPeriod = (0x800 - parentObj.channel3frequency) << 1
                parentObj.memory[0xFF1D] = data
            }
        }
        memoryHighWriter[0x1D] = memoryWriter[0xFF1D]
        memoryWriter[0xFF1E] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                if ( (data > 0x7F)) {
                    if ( (parentObj.channel3totalLength == 0)) {
                        parentObj.channel3totalLength = 0x100
                    }
                    parentObj.channel3lastSampleLookup = 0
                    if ( ((data & 0x40) == 0x40)) {
                        parentObj.memory[0xFF26] |= 0x4
                    }
                }
                parentObj.channel3consecutive = ((data & 0x40) == 0x0)
                parentObj.channel3frequency = ((data & 0x7) << 8) | (parentObj.channel3frequency & 0xFF)
                parentObj.channel3FrequencyPeriod = (0x800 - parentObj.channel3frequency) << 1
                parentObj.memory[0xFF1E] = data & 0x40
                parentObj.channel3EnableCheck()
            }
        }
        memoryHighWriter[0x1E] = memoryWriter[0xFF1E]
        memoryWriter[0xFF20] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled || !parentObj.cGBC)) {
                if ( (parentObj.soundMasterEnabled)) {
                    parentObj.audioJIT()
                }
                parentObj.channel4totalLength = 0x40 - (data & 0x3F)
                parentObj.memory[0xFF20] = data | 0xC0
                parentObj.channel4EnableCheck()
            }
        }
        memoryHighWriter[0x20] = memoryWriter[0xFF20]
        memoryWriter[0xFF21] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                if ( (parentObj.channel4Enabled && parentObj.channel4envelopeSweeps == 0)) {
                    //Zombie Volume PAPU Bug:
                    if ( (((parentObj.memory[0xFF21] ^ data) & 0x8) == 0x8)) {
                        if ( ((parentObj.memory[0xFF21] & 0x8) == 0)) {
                            if ( ((parentObj.memory[0xFF21] & 0x7) == 0x7)) {
                                parentObj.channel4envelopeVolume += 2
                            }
                            else {
                                parentObj.channel4envelopeVolume += 1
                            }
                        }
                        parentObj.channel4envelopeVolume = (16 - parentObj.channel4envelopeVolume) & 0xF
                    }
                    else if ( ((parentObj.memory[0xFF21] & 0xF) == 0x8)) {
                        parentObj.channel4envelopeVolume = (1 + parentObj.channel4envelopeVolume) & 0xF
                    }
                    parentObj.channel4currentVolume = parentObj.channel4envelopeVolume << parentObj.channel4VolumeShifter
                }
                parentObj.channel4envelopeType = ((data & 0x08) == 0x08)
                parentObj.memory[0xFF21] = data
                parentObj.channel4UpdateCache()
                parentObj.channel4VolumeEnableCheck()
            }
        }
        memoryHighWriter[0x21] = memoryWriter[0xFF21]
        memoryWriter[0xFF22] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                parentObj.channel4FrequencyPeriod = max((data & 0x7) << 4, 8) << (data >> 4)
                let bitWidth = (data & 0x8)
                if ( ((bitWidth == 0x8 && parentObj.channel4BitRange == 0x7FFF) || (bitWidth == 0 && parentObj.channel4BitRange == 0x7F))) {
                    parentObj.channel4lastSampleLookup = 0
                    if(bitWidth == 0x8){
                        parentObj.channel4BitRange =  0x7F
                        parentObj.channel4VolumeShifter =  7 
                    }else{
                        parentObj.channel4BitRange =  0x7FFF
                        parentObj.channel4VolumeShifter = 15
                    }
                    parentObj.channel4currentVolume = parentObj.channel4envelopeVolume << parentObj.channel4VolumeShifter
                    if(bitWidth == 0x8){
                        parentObj.noiseSampleTable = parentObj.LSFR7Table 
                    }else{
                        parentObj.noiseSampleTable =  parentObj.LSFR15Table
                    }
                }
                parentObj.memory[0xFF22] = data
                parentObj.channel4UpdateCache()
            }
        }
        memoryHighWriter[0x22] = memoryWriter[0xFF22]
        memoryWriter[0xFF23] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled)) {
                parentObj.audioJIT()
                parentObj.memory[0xFF23] = data
                parentObj.channel4consecutive = ((data & 0x40) == 0x0)
                if ( (data > 0x7F)) {
                    let nr42 = parentObj.memory[0xFF21]
                    parentObj.channel4envelopeVolume = nr42 >> 4
                    parentObj.channel4currentVolume = parentObj.channel4envelopeVolume << parentObj.channel4VolumeShifter
                    parentObj.channel4envelopeSweepsLast = (nr42 & 0x7) - 1
                    if ( (parentObj.channel4totalLength == 0)) {
                        parentObj.channel4totalLength = 0x40
                    }
                    if ( ((data & 0x40) == 0x40)) {
                        parentObj.memory[0xFF26] |= 0x8
                    }
                }
                parentObj.channel4EnableCheck()
            }
        }
        memoryHighWriter[0x23] = memoryWriter[0xFF23]
        memoryWriter[0xFF24] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled && parentObj.memory[0xFF24] != data)) {
                parentObj.audioJIT()
                parentObj.memory[0xFF24] = data
                parentObj.VinLeftChannelMasterVolume = ((data >> 4) & 0x07) + 1
                parentObj.VinRightChannelMasterVolume = (data & 0x07) + 1
                parentObj.mixerOutputLevelCache()
            }
        }
        memoryHighWriter[0x24] = memoryWriter[0xFF24]
        memoryWriter[0xFF25] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.soundMasterEnabled && parentObj.memory[0xFF25] != data)) {
                parentObj.audioJIT()
                parentObj.memory[0xFF25] = data
                parentObj.rightChannel1 = ((data & 0x01) == 0x01)
                parentObj.rightChannel2 = ((data & 0x02) == 0x02)
                parentObj.rightChannel3 = ((data & 0x04) == 0x04)
                parentObj.rightChannel4 = ((data & 0x08) == 0x08)
                parentObj.leftChannel1 = ((data & 0x10) == 0x10)
                parentObj.leftChannel2 = ((data & 0x20) == 0x20)
                parentObj.leftChannel3 = ((data & 0x40) == 0x40)
                parentObj.leftChannel4 = (data > 0x7F)
                parentObj.channel1OutputLevelCache()
                parentObj.channel2OutputLevelCache()
                parentObj.channel3OutputLevelCache()
                parentObj.channel4OutputLevelCache()
            }
        }
        memoryHighWriter[0x25] = memoryWriter[0xFF25]
        memoryWriter[0xFF26] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.audioJIT()
            if ( (!parentObj.soundMasterEnabled && data > 0x7F)) {
                parentObj.memory[0xFF26] = 0x80
                parentObj.soundMasterEnabled = true
                parentObj.initializeAudioStartState()
            }
            else if ( (parentObj.soundMasterEnabled && data < 0x80)) {
                parentObj.memory[0xFF26] = 0
                parentObj.soundMasterEnabled = false
                //GBDev wiki says the registers are written with zeros on power off:
                for ( index in 0xFF10..0xFF26) {
                    parentObj.memoryWriter[index](parentObj, index, 0)
                }
            }
        }
        memoryHighWriter[0x26] = memoryWriter[0xFF26]
        //0xFF27 to 0xFF2F don't do anything...
        memoryHighWriter[0x27] = cartIgnoreWrite
        memoryWriter[0xFF27] = cartIgnoreWrite
        memoryHighWriter[0x28] = cartIgnoreWrite
        memoryWriter[0xFF28] = cartIgnoreWrite
        memoryHighWriter[0x29] = cartIgnoreWrite
        memoryWriter[0xFF29] = cartIgnoreWrite
        memoryHighWriter[0x2A] = cartIgnoreWrite
        memoryWriter[0xFF2A] = cartIgnoreWrite
        memoryHighWriter[0x2B] = cartIgnoreWrite
        memoryWriter[0xFF2B] = cartIgnoreWrite
        memoryHighWriter[0x2C] = cartIgnoreWrite
        memoryWriter[0xFF2C] = cartIgnoreWrite
        memoryHighWriter[0x2D] = cartIgnoreWrite
        memoryWriter[0xFF2D] = cartIgnoreWrite
        memoryHighWriter[0x2E] = cartIgnoreWrite
        memoryWriter[0xFF2E] = cartIgnoreWrite
        memoryHighWriter[0x2F] = cartIgnoreWrite
        memoryWriter[0xFF2F] = cartIgnoreWrite
        //WAVE PCM RAM:
        memoryWriter[0xFF30] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0, data)
        }
        memoryHighWriter[0x30] = memoryWriter[0xFF30]
        memoryWriter[0xFF31] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x1, data)
        }
        memoryHighWriter[0x31] = memoryWriter[0xFF31]
        memoryWriter[0xFF32] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x2, data)
        }
        memoryHighWriter[0x32] = memoryWriter[0xFF32]
        memoryWriter[0xFF33] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x3, data)
        }
        memoryHighWriter[0x33] = memoryWriter[0xFF33]
        memoryWriter[0xFF34] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x4, data)
        }
        memoryHighWriter[0x34] = memoryWriter[0xFF34]
        memoryWriter[0xFF35] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x5, data)
        }
        memoryHighWriter[0x35] = memoryWriter[0xFF35]
        memoryWriter[0xFF36] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x6, data)
        }
        memoryHighWriter[0x36] = memoryWriter[0xFF36]
        memoryWriter[0xFF37] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x7, data)
        }
        memoryHighWriter[0x37] = memoryWriter[0xFF37]
        memoryWriter[0xFF38] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x8, data)
        }
        memoryHighWriter[0x38] = memoryWriter[0xFF38]
        memoryWriter[0xFF39] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0x9, data)
        }
        memoryHighWriter[0x39] = memoryWriter[0xFF39]
        memoryWriter[0xFF3A] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0xA, data)
        }
        memoryHighWriter[0x3A] = memoryWriter[0xFF3A]
        memoryWriter[0xFF3B] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0xB, data)
        }
        memoryHighWriter[0x3B] = memoryWriter[0xFF3B]
        memoryWriter[0xFF3C] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0xC, data)
        }
        memoryHighWriter[0x3C] = memoryWriter[0xFF3C]
        memoryWriter[0xFF3D] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0xD, data)
        }
        memoryHighWriter[0x3D] = memoryWriter[0xFF3D]
        memoryWriter[0xFF3E] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0xE, data)
        }
        memoryHighWriter[0x3E] = memoryWriter[0xFF3E]
        memoryWriter[0xFF3F] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.channel3WriteRAM(0xF, data)
        }
        memoryHighWriter[0x3F] = memoryWriter[0xFF3F]
        //SCY
        memoryWriter[0xFF42] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.backgroundY != data)) {
                parentObj.midScanLineJIT()
                parentObj.backgroundY = data
            }
        }
        memoryHighWriter[0x42] = memoryWriter[0xFF42]
        //SCX
        memoryWriter[0xFF43] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.backgroundX != data)) {
                parentObj.midScanLineJIT()
                parentObj.backgroundX = data
            }
        }
        memoryHighWriter[0x43] = memoryWriter[0xFF43]
        //LY
        memoryWriter[0xFF44] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            //Read Only:
            if ( (parentObj.LCDisOn)) {
                //Gambatte says to do this:
                parentObj.modeSTAT = 2
                parentObj.midScanlineOffset = -1
                parentObj.totalLinesPassed = 0
                parentObj.currentX = 0
                parentObj.queuedScanLines = 0
                parentObj.lastUnrenderedLine = 0
                parentObj.LCDTicks = 0
                parentObj.STATTracker = 0
                parentObj.actualScanLine = 0
                parentObj.memory[0xFF44] = 0
            }
        }
        memoryHighWriter[0x44] = memoryWriter[0xFF44]
        //LYC
        memoryWriter[0xFF45] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.memory[0xFF45] != data)) {
                parentObj.memory[0xFF45] = data
                if ( (parentObj.LCDisOn)) {
                    parentObj.matchLYC()  //Get the compare of the first scan line.
                }
            }
        }
        memoryHighWriter[0x45] = memoryWriter[0xFF45]
        //WY
        memoryWriter[0xFF4A] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.windowY != data)) {
                parentObj.midScanLineJIT()
                parentObj.windowY = data
            }
        }
        memoryHighWriter[0x4A] = memoryWriter[0xFF4A]
        //WX
        memoryWriter[0xFF4B] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            if ( (parentObj.memory[0xFF4B] != data)) {
                parentObj.midScanLineJIT()
                parentObj.memory[0xFF4B] = data
                parentObj.windowX = data - 7
            }
        }
        memoryHighWriter[0x4B] = memoryWriter[0xFF4B]
        memoryWriter[0xFF72] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.memory[0xFF72] = data
        }
        memoryHighWriter[0x72] = memoryWriter[0xFF72]
        memoryWriter[0xFF73] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.memory[0xFF73] = data
        }
        memoryHighWriter[0x73] = memoryWriter[0xFF73]
        memoryWriter[0xFF75] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.memory[0xFF75] = data
        }
        memoryHighWriter[0x75] = memoryWriter[0xFF75]
        memoryHighWriter[0x76] = cartIgnoreWrite
        memoryWriter[0xFF76] = cartIgnoreWrite
        memoryHighWriter[0x77] = cartIgnoreWrite
        memoryWriter[0xFF77] = cartIgnoreWrite
        //IE (Int64errupt Enable)
        memoryWriter[0xFFFF] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
            parentObj.interruptsEnabled = data
            parentObj.checkIRQMatching()
        }
        memoryHighWriter[0xFF] = memoryWriter[0xFFFF]
        recompileModelSpecificIOWriteHandling()
        recompileBootIOWriteHandling()
    }
    
    func recompileModelSpecificIOWriteHandling() {
        
        if ( cGBC) {
            //GameBoy Color Specific I/O:
            //SC (Serial Transfer Control Register)
            memoryWriter[0xFF02] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (((data & 0x1) == 0x1))) {
                    //Int64ernal clock:
                    parentObj.memory[0xFF02] = (data & 0x7F)
                    if((data & 0x2) == 0){
                        parentObj.serialTimer = 4096 
                        parentObj.serialShiftTimer = 512
                    }else{
                        parentObj.serialTimer =  128
                        parentObj.serialShiftTimer = 16
                    }
                    //Set the Serial IRQ counter.
                    //Set the transfer data shift counter.
                    parentObj.serialShiftTimerAllocated = parentObj.serialShiftTimer
                }
                else {
                    //External clock:
                    parentObj.memory[0xFF02] = data
                    parentObj.serialShiftTimer = 0  //Zero the timers, since we're emulating as if nothing is connected.
                    parentObj.serialShiftTimerAllocated = parentObj.serialShiftTimer
                    parentObj.serialTimer = parentObj.serialShiftTimer
                }
            }
            memoryHighWriter[0x2] = memoryWriter[0xFF02]
            memoryWriter[0xFF40] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( parentObj.memory[0xFF40] != data) {
                    parentObj.midScanLineJIT()
                    let temp_var = (data > 0x7F)
                    if ( (temp_var != parentObj.LCDisOn)) {
                        //When the display mode changes...
                        parentObj.LCDisOn = temp_var
                        parentObj.memory[0xFF41] &= 0x78
                        parentObj.midScanlineOffset = -1
                        parentObj.totalLinesPassed = 0
                        parentObj.currentX = 0
                        parentObj.queuedScanLines = 0
                        parentObj.lastUnrenderedLine = 0
                        parentObj.STATTracker = 0
                        parentObj.LCDTicks = 0
                        parentObj.actualScanLine = 0
                        parentObj.memory[0xFF44] = 0
                        if ( (parentObj.LCDisOn)) {
                            parentObj.modeSTAT = 2
                            parentObj.matchLYC()  //Get the compare of the first scan line.
                            parentObj.LCDCONTROL = parentObj.LINECONTROL
                        }
                        else {
                            parentObj.modeSTAT = 0
                            parentObj.LCDCONTROL = parentObj.DISPLAYOFFCONTROL
                            parentObj.DisplayShowOff()
                        }
                        parentObj.interruptsRequested &= 0xFD
                    }
                    parentObj.gfxWindowCHRBankPosition =  0
                    if((data & 0x40) == 0x40){
                        parentObj.gfxWindowCHRBankPosition =  0x400 
                    }
                    parentObj.gfxWindowDisplay = ((data & 0x20) == 0x20)
                    parentObj.gfxBackgroundBankOffset =  0x80
                    if((data & 0x10) == 0x10){
                        parentObj.gfxBackgroundBankOffset =0
                    }
                    parentObj.gfxBackgroundCHRBankPosition =  0
                    if ((data & 0x08) == 0x08){
                        parentObj.gfxBackgroundCHRBankPosition =  0x400 
                    }
                    parentObj.gfxSpriteNormalHeight = ((data & 0x04) == 0)
                    parentObj.gfxSpriteShow = ((data & 0x02) == 0x02)
                    parentObj.BGPriorityEnabled = ((data & 0x01) == 0x01)
                    parentObj.priorityFlaggingPathRebuild()  //Special case the priority flagging as an optimization.
                    parentObj.memory[0xFF40] = data
                }
            }
            memoryHighWriter[0x40] = memoryWriter[0xFF40]
            memoryWriter[0xFF41] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.LYCMatchTriggerSTAT = ((data & 0x40) == 0x40)
                parentObj.mode2TriggerSTAT = ((data & 0x20) == 0x20)
                parentObj.mode1TriggerSTAT = ((data & 0x10) == 0x10)
                parentObj.mode0TriggerSTAT = ((data & 0x08) == 0x08)
                parentObj.memory[0xFF41] = data & 0x78
            }
            memoryHighWriter[0x41] = memoryWriter[0xFF41]
            memoryWriter[0xFF46] = { parentObj, addressTemp, dataTemp =>
                var data = dataTemp
                var address = addressTemp
                parentObj.memory[0xFF46] = data
                if ( (data < 0xE0)) {
                    data <<= 8
                    address = 0xFE00
                    let stat = parentObj.modeSTAT
                    parentObj.modeSTAT = 0
                    var newData = 0
                    do {
                        newData = parentObj.memoryReader[data](parentObj, data)
                        data++
                        if ( (newData != parentObj.memory[address])) {
                            //JIT the graphics render queue:
                            parentObj.modeSTAT = stat
                            parentObj.graphicsJIT()
                            parentObj.modeSTAT = 0
                            parentObj.memory[address] = newData
                            address++
                            break
                        }
                        address += 1
                    } while (address < 0xFEA0)
                    if ( address < 0xFEA0) {
                        do {
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                        } while (address < 0xFEA0)
                    }
                    parentObj.modeSTAT = stat
                }
            }
            memoryHighWriter[0x46] = memoryWriter[0xFF46]
            //KEY1
            memoryWriter[0xFF4D] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                let temp = parentObj.memory[0xFF4D] & 0x80
                parentObj.memory[0xFF4D] = (data & 0x7F) | temp
            }
            memoryHighWriter[0x4D] = memoryWriter[0xFF4D]
            memoryWriter[0xFF4F] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.currVRAMBank = data & 0x01
                if ( (parentObj.currVRAMBank > 0)) {
                    parentObj.BGCHRCurrentBank = parentObj.BGCHRBank2
                }
                else {
                    parentObj.BGCHRCurrentBank = parentObj.BGCHRBank1
                }
                //Only writable by GBC.
            }
            memoryHighWriter[0x4F] = memoryWriter[0xFF4F]
            memoryWriter[0xFF51] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (!parentObj.hdmaRunning)) {
                    parentObj.memory[0xFF51] = data
                }
            }
            memoryHighWriter[0x51] = memoryWriter[0xFF51]
            memoryWriter[0xFF52] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (!parentObj.hdmaRunning)) {
                    parentObj.memory[0xFF52] = data & 0xF0
                }
            }
            memoryHighWriter[0x52] = memoryWriter[0xFF52]
            memoryWriter[0xFF53] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (!parentObj.hdmaRunning)) {
                    parentObj.memory[0xFF53] = data & 0x1F
                }
            }
            memoryHighWriter[0x53] = memoryWriter[0xFF53]
            memoryWriter[0xFF54] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (!parentObj.hdmaRunning)) {
                    parentObj.memory[0xFF54] = data & 0xF0
                }
            }
            memoryHighWriter[0x54] = memoryWriter[0xFF54]
            memoryWriter[0xFF55] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (!parentObj.hdmaRunning)) {
                    if ( ((data & 0x80) == 0)) {
                        //DMA
                        parentObj.DMAWrite((data & 0x7F) + 1)
                        parentObj.memory[0xFF55] = 0xFF  //Transfer completed.
                    }
                    else {
                        //H-Blank DMA
                        parentObj.hdmaRunning = true
                        parentObj.memory[0xFF55] = data & 0x7F
                    }
                }
                else if ( ((data & 0x80) == 0)) {
                    //Stop H-Blank DMA
                    parentObj.hdmaRunning = false
                    parentObj.memory[0xFF55] |= 0x80
                }
                else {
                    parentObj.memory[0xFF55] = data & 0x7F
                }
            }
            memoryHighWriter[0x55] = memoryWriter[0xFF55]
            memoryWriter[0xFF68] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.memory[0xFF69] = parentObj.gbcBGRawPalette[data & 0x3F]
                parentObj.memory[0xFF68] = data
            }
            memoryHighWriter[0x68] = memoryWriter[0xFF68]
            memoryWriter[0xFF69] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.updateGBCBGPalette(parentObj.memory[0xFF68] & 0x3F, data)
                if ( (parentObj.memory[0xFF68] > 0x7F)) { // high bit = autoincrement
                    let next = ((parentObj.memory[0xFF68] + 1) & 0x3F)
                    parentObj.memory[0xFF68] = (next | 0x80)
                    parentObj.memory[0xFF69] = parentObj.gbcBGRawPalette[next]
                }
                else {
                    parentObj.memory[0xFF69] = data
                }
            }
            memoryHighWriter[0x69] = memoryWriter[0xFF69]
            memoryWriter[0xFF6A] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.memory[0xFF6B] = parentObj.gbcOBJRawPalette[data & 0x3F]
                parentObj.memory[0xFF6A] = data
            }
            memoryHighWriter[0x6A] = memoryWriter[0xFF6A]
            memoryWriter[0xFF6B] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                let temp = parentObj.memory[0xFF6A]
                parentObj.updateGBCOBJPalette(temp & 0x3F, data)
                if ( temp > 0x7F) { // high bit = autoincrement
                    let next = ((parentObj.memory[0xFF6A] + 1) & 0x3F)
                    parentObj.memory[0xFF6A] = (next | 0x80)
                    parentObj.memory[0xFF6B] = parentObj.gbcOBJRawPalette[next]
                }
                else {
                    parentObj.memory[0xFF6B] = data
                }
            }
            memoryHighWriter[0x6B] = memoryWriter[0xFF6B]
            //SVBK
            memoryWriter[0xFF70] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                let addressCheck = (parentObj.memory[0xFF51] << 8) | parentObj.memory[0xFF52]  //Cannot change the RAM bank while WRAM is the source of a running HDMA.
                if ( (!parentObj.hdmaRunning || addressCheck < 0xD000 || addressCheck >= 0xE000)) {
                    parentObj.gbcRamBank = max(data & 0x07, 1)  //Bank range is from 1-7
                    parentObj.gbcRamBankPosition = ((parentObj.gbcRamBank - 1) << 12) - 0xD000
                    parentObj.gbcRamBankPositionECHO = parentObj.gbcRamBankPosition - 0x2000
                }
                parentObj.memory[0xFF70] = data  //Bit 6 cannot be written to.
            }
            memoryHighWriter[0x70] = memoryWriter[0xFF70]
            memoryWriter[0xFF74] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.memory[0xFF74] = data
            }
            memoryHighWriter[0x74] = memoryWriter[0xFF74]
        }
        else {
            //Fill in the GameBoy Color I/O registers as normal RAM for GameBoy compatibility:
            //SC (Serial Transfer Control Register)
            memoryWriter[0xFF02] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (((data & 0x1) == 0x1))) {
                    //Int64ernal clock:
                    parentObj.memory[0xFF02] = (data & 0x7F)
                    parentObj.serialTimer = 4096  //Set the Serial IRQ counter.
                    parentObj.serialShiftTimer = 512
                    parentObj.serialShiftTimerAllocated = 512  //Set the transfer data shift counter.
                }
                else {
                    //External clock:
                    parentObj.memory[0xFF02] = data
                    parentObj.serialShiftTimer = 0
                    parentObj.serialShiftTimerAllocated = 0
                    parentObj.serialTimer = 0  //Zero the timers, since we're emulating as if nothing is connected.
                }
            }
            memoryHighWriter[0x2] = memoryWriter[0xFF02]
            memoryWriter[0xFF40] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (parentObj.memory[0xFF40] != data)) {
                    parentObj.midScanLineJIT()
                    let temp_var = (data > 0x7F)
                    if ( (temp_var != parentObj.LCDisOn)) {
                        //When the display mode changes...
                        parentObj.LCDisOn = temp_var
                        parentObj.memory[0xFF41] &= 0x78
                        parentObj.midScanlineOffset = -1
                        parentObj.totalLinesPassed = 0
                        parentObj.currentX = 0
                        parentObj.queuedScanLines = 0
                        parentObj.lastUnrenderedLine = 0
                        parentObj.STATTracker = 0
                        parentObj.LCDTicks = 0
                        parentObj.actualScanLine = 0
                        parentObj.memory[0xFF44] = 0
                        if ( (parentObj.LCDisOn)) {
                            parentObj.modeSTAT = 2
                            parentObj.matchLYC()  //Get the compare of the first scan line.
                            parentObj.LCDCONTROL = parentObj.LINECONTROL
                        }
                        else {
                            parentObj.modeSTAT = 0
                            parentObj.LCDCONTROL = parentObj.DISPLAYOFFCONTROL
                            parentObj.DisplayShowOff()
                        }
                        parentObj.interruptsRequested &= 0xFD
                    }
                    parentObj.gfxWindowCHRBankPosition =  0
                    if((data & 0x40) == 0x40){
                        parentObj.gfxWindowCHRBankPosition = 0x400
                    }
                    parentObj.gfxWindowDisplay = (data & 0x20) == 0x20
                    parentObj.gfxBackgroundBankOffset = 0x80
                    if((data & 0x10) == 0x10){
                         parentObj.gfxBackgroundBankOffset =  0 
                    }
                    parentObj.gfxBackgroundCHRBankPosition =  0
                    if((data & 0x08) == 0x08) {
                        parentObj.gfxBackgroundCHRBankPosition = 0x400 
                    }
                    parentObj.gfxSpriteNormalHeight = ((data & 0x04) == 0)
                    parentObj.gfxSpriteShow = (data & 0x02) == 0x02
                    parentObj.bgEnabled = ((data & 0x01) == 0x01)
                    parentObj.memory[0xFF40] = data
                }
            }
            memoryHighWriter[0x40] = memoryWriter[0xFF40]
            memoryWriter[0xFF41] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.LYCMatchTriggerSTAT = ((data & 0x40) == 0x40)
                parentObj.mode2TriggerSTAT = ((data & 0x20) == 0x20)
                parentObj.mode1TriggerSTAT = ((data & 0x10) == 0x10)
                parentObj.mode0TriggerSTAT = ((data & 0x08) == 0x08)
                parentObj.memory[0xFF41] = data & 0x78
                if ( ((!parentObj.usedBootROM || !parentObj.usedGBCBootROM) && parentObj.LCDisOn && parentObj.modeSTAT < 2)) {
                    parentObj.interruptsRequested |= 0x2
                    parentObj.checkIRQMatching()
                }
            }
            memoryHighWriter[0x41] = memoryWriter[0xFF41]
            memoryWriter[0xFF46] = { parentObj, addressTemp, dataTemp =>
                parentObj.memory[0xFF46] = dataTemp
                var data = dataTemp
                var address = addressTemp
                if ( (data > 0x7F && data < 0xE0)) {  //DMG cannot DMA from the ROM banks.
                    data <<= 8
                    address = 0xFE00
                    let stat = parentObj.modeSTAT
                    parentObj.modeSTAT = 0
                    var newData = 0
                    do{
                        newData = parentObj.memoryReader[data](parentObj, data)
                        data++
                        if ( (newData != parentObj.memory[address])) {
                            //JIT the graphics render queue:
                            parentObj.modeSTAT = stat
                            parentObj.graphicsJIT()
                            parentObj.modeSTAT = 0
                            parentObj.memory[address] = newData
                            address++
                            break
                        }
                        address += 1
                    } while (address < 0xFEA0)
                    if ( (address < 0xFEA0)) {
                        do {
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                            parentObj.memory[address] = parentObj.memoryReader[data](parentObj, data)
                            data++
                            address++
                        } while (address < 0xFEA0)
                    }
                    parentObj.modeSTAT = stat
                }
            }
            memoryHighWriter[0x46] = memoryWriter[0xFF46]
            memoryWriter[0xFF47] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (parentObj.memory[0xFF47] != data)) {
                    parentObj.midScanLineJIT()
                    parentObj.updateGBBGPalette.getOrThrow()(data)
                    parentObj.memory[0xFF47] = data
                }
            }
            memoryHighWriter[0x47] = memoryWriter[0xFF47]
            memoryWriter[0xFF48] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (parentObj.memory[0xFF48] != data)) {
                    parentObj.midScanLineJIT()
                    parentObj.updateGBOBJPalette.getOrThrow()(0, data)
                    parentObj.memory[0xFF48] = data
                }
            }
            memoryHighWriter[0x48] = memoryWriter[0xFF48]
            memoryWriter[0xFF49] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                if ( (parentObj.memory[0xFF49] != data)) {
                    parentObj.midScanLineJIT()
                    parentObj.updateGBOBJPalette.getOrThrow()(4, data)
                    parentObj.memory[0xFF49] = data
                }
            }
            memoryHighWriter[0x49] = memoryWriter[0xFF49]
            memoryWriter[0xFF4D] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                parentObj.memory[0xFF4D] = data
            }
            memoryHighWriter[0x4D] = memoryWriter[0xFF4D]
            memoryHighWriter[0x4F] = cartIgnoreWrite
            memoryWriter[0xFF4F] = cartIgnoreWrite  //Not writable in DMG mode.
            memoryHighWriter[0x55] = cartIgnoreWrite
            memoryWriter[0xFF55] = cartIgnoreWrite
            memoryHighWriter[0x68] = cartIgnoreWrite
            memoryWriter[0xFF68] = cartIgnoreWrite
            memoryHighWriter[0x69] = cartIgnoreWrite
            memoryWriter[0xFF69] = cartIgnoreWrite
            memoryHighWriter[0x6A] = cartIgnoreWrite
            memoryWriter[0xFF6A] = cartIgnoreWrite
            memoryHighWriter[0x6B] = cartIgnoreWrite
            memoryWriter[0xFF6B] = cartIgnoreWrite
            memoryHighWriter[0x6C] = cartIgnoreWrite
            memoryWriter[0xFF6C] = cartIgnoreWrite
            memoryHighWriter[0x70] = cartIgnoreWrite
            memoryWriter[0xFF70] = cartIgnoreWrite
            memoryHighWriter[0x74] = cartIgnoreWrite
            memoryWriter[0xFF74] = cartIgnoreWrite
        }
    }
    func disableBootROM() :Unit {
        
        //Remove any traces of the boot ROM from ROM memory.
        for (index in 0..0x100) {
            memory[index] = ROM[index]  //Replace the GameBoy or GameBoy Color boot ROM with the game ROM.
        }
        if (usedGBCBootROM) {
            //Remove any traces of the boot ROM from ROM memory.
            for (index in 0x200..0x900) {
                memory[index] = ROM[index]  //Replace the GameBoy Color boot ROM with the game ROM.
            }
            if (!cGBC) {
                //Clean up the post-boot (GB mode only) state:
                GBCtoGBModeAdjust()
            }
            else {
                recompileBootIOWriteHandling()
            }
        }
        else {
            recompileBootIOWriteHandling()
        }
    }

    func recompileBootIOWriteHandling() {
        
        // Boot I/O Registers:
        if ( inBootstrap) {
            memoryWriter[0xFF50] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                
                parentObj.inBootstrap = false
                parentObj.disableBootROM()
                parentObj.memory[0xFF50] = data
            }
            memoryHighWriter[0x50] = memoryWriter[0xFF50]
            if ( cGBC) {
                memoryWriter[0xFF6C] = { parentObj:GameBoyCore, address:Int64, data:Int64 =>
                    if ( parentObj.inBootstrap) {
                        parentObj.cGBC = ((data & 0x1) == 0)
                        // Exception to the GBC identifying code:
                        if ( parentObj.name + parentObj.gameCode + String(Rune(parentObj.ROM[0x143])) == "Game and Watch 50") {
                            parentObj.cGBC = true
                            cout("Created a boot exception for Game and Watch Gallery 2 (GBC ID byte is wrong on the cartridge).", 1)
                        }
                        cout("Booted to GBC Mode: ${parentObj.cGBC}", 0)
                    }
                    parentObj.memory[0xFF6C] = data
                }
                memoryHighWriter[0x6C] = memoryWriter[0xFF6C]
            }
        }
        else {
            // Lockout the ROMs from accessing the BOOT ROM control register:
            memoryHighWriter[0x50] = cartIgnoreWrite
            memoryWriter[0xFF50] = cartIgnoreWrite
        }
    }
    
    func toTypedArray( baseArray: Array<Int64>,  memtype: String) : Array<Int64> {
        if ( baseArray.size == 0) {
            return []
        }
        let length = baseArray.size
        var typedArrayTemp: Array<Int64> = []
        match ( memtype) {
        case "uint8"=>
            typedArrayTemp = Array(length,repeat:0)
            
        case "int8"=>
            typedArrayTemp = Array(length,repeat:0)
            
        case "int32"=>
            typedArrayTemp = Array(length,repeat:0)
            
        case "float32"=>
             typedArrayTemp = Array(length,repeat:0)
        case _ => ()

        //default=>
         //   break
        }
        for ( index in 0..length) {
            typedArrayTemp[index] = baseArray[index]
        }
        return typedArrayTemp
    }
    
    func fromTypedArray( baseArray: Array<Int>) : Array<Int> {
        if ( baseArray.size == 0) {
            return []
        }
        return baseArray
    }
    
    func getTypedArray( length: Int64,  defaultValue: Any,  numberType: String) : Array<Any> {
        var arrayHandle: Array<Any> = []
        if ( (settings[5] as Bool).getOrThrow()) {
            arrayHandle = Array(length,repeat:defaultValue)
            return arrayHandle
        }
        match ( numberType) {
        case "int8"=>
            arrayHandle = Array(length,repeat:0)
            
        case "uint8"=>
            arrayHandle = Array(length,repeat:0)
            
        case "int32"=>
            arrayHandle = Array(length,repeat:0)
            
        case "float32"=>
            arrayHandle = Array(length,repeat:Float32(0))
        case _ =>
            arrayHandle = []
        //case _ :=>
            
        }
        var t1 =  0
        if((defaultValue as Int64).isSome()){
            t1 = (defaultValue as Int64).getOrThrow()
        }
        var t2 = Float32(0.0)
        if((defaultValue as? Float32).isSome()){
            t2 = (defaultValue as Float32 ).getOrThrow()
        }
        if ( t1 != 0 ||t2 != 0.0) {
            var index = 0
            while ( (index < length)) {
                arrayHandle[index] = defaultValue
                index++
            }
        }
        return arrayHandle
    }
}

// End of js/GameBoyCore.js file.

// Start of js/GameBoyIO.js file.

func start( canvas: GameBoyCanvas,  ROM: String) {
    
    clearLastEmulation()
    gameboy = GameBoyCore(canvas, ROM)
    gameboy.getOrThrow().openMBC = openSRAM
    gameboy.getOrThrow().openRTC = openRTC
    gameboy.getOrThrow().start()
    run()
}

func run() {
    
    if ( (GameBoyEmulatorInitialized())) {
        if ( (!GameBoyEmulatorPlaying())) {
            gameboy.getOrThrow().stopEmulator &= 1
            cout("Starting the iterator.", 0)
            let dateObj = new_Date()  // The line is changed for benchmarking.
            gameboy.getOrThrow().firstIteration = dateObj.getTime()
            gameboy.getOrThrow().iterations = 0
        }
        else {
            cout("The GameBoy core is already running.", 1)
        }
    }
    else {
        cout("GameBoy core cannot run while it has not been initialized.", 1)
    }
}

func pausePlay() {
    if ( (GameBoyEmulatorInitialized())) {
        if ( (GameBoyEmulatorPlaying())) {
            clearLastEmulation()
        }
        else {
            cout("GameBoy core has already been paused.", 1)
        }
    }
    else {
        cout("GameBoy core cannot be paused while it has not been initialized.", 1)
    }
}

func clearLastEmulation() {
    if ( (GameBoyEmulatorInitialized() && GameBoyEmulatorPlaying())) {
        gameboy.getOrThrow().stopEmulator |= 2
        cout("The previous emulation has been cleared.", 0)
    }
    else {
        cout("No previous emulation was found to be cleared.", 0)
    }
}

func openSRAM( filename: String) : Array<Int64> {
    return []
}

func openRTC( filename: String) : Array<Int64> {
    return []
}

func GameBoyEmulatorInitialized() : Bool {
    return (gameboy.isSome())
}

func GameBoyEmulatorPlaying() : Bool {
    return (((gameboy.getOrThrow().stopEmulator) & 2) == 0)
}

//The emulator will call this to sort out the canvas properties for (re)initialization.
func initNewCanvas() {
    if ( (GameBoyEmulatorInitialized())) {
        gameboy.getOrThrow().canvas.getOrThrow().width = gameboy.getOrThrow().canvas.getOrThrow().clientWidth
        gameboy.getOrThrow().canvas.getOrThrow().height = gameboy.getOrThrow().canvas.getOrThrow().clientHeight
    }
}

// Start of realtime.js file.
// ROM code from Public Domain LPC2000 Demo "realtime" by AGO.

var gameboy_rom = "r+BPyZiEZwA+AeBPySAobeEq6gAgKlYj5WJv6SRmZjjhKuXqACDJ/////////////////////////////////xgHZwCYhGcA2fX6/3/1xdXlIRPKNgHN9f/h0cHx6gAg+hLKtyAC8cnwgLcoF/CC7hjgUT6Q4FOv4FLgVOCAPv/gVfHZ8IG3IALx2fBA7gjgQA8PD+YB7gHgT/CC4FHuEOCCPojgU6/gUuBU4IE+/uBV4ID6NMs86jTL8dkKCgoKbWFkZSBieSBhZ28uIGVtYWlsOmdvYnV6b3ZAeWFob28uY29tCnVybDogc3BlY2N5LmRhLnJ1CgoKCv///////wDDSgnO7WZmzA0ACwNzAIMADAANAAgRH4iJAA7czG7m3d3Zmbu7Z2NuDuzM3dyZn7u5Mz5BR08nUyBSRUFMVElNRSCAAAAAAgEDADMBSTQeIUD/y37I8P/1y4fg//BE/pEg+su+8eD/yT7A4EY+KD0g/cnF1eWvEQPK1RITEhMGAyEAyuXFTgYAIWAMCQkqEhMqEhPB4SMFIOrhrwYIzYsU4dHByf////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8AAgMFBggJCwwOEBETFBYXGBobHR4fISIjJSYnKSorLC0uLzAxMjM0NTY3ODg5Ojo7PDw9PT4+Pj8/Pz9AQEBAQEBAQEBAPz8/Pz4+PT08PDs7Ojk5ODc2NTU0MzIxMC8uLCsqKSgmJSQjISAfHRwaGRcWFRMSEA8NCwoIBwUEAgH//fz6+ff29PPx8O7t6+ro5+Xk4uHg3t3c2tnY19bU09LR0M/OzczLysnJyMfGxsXFxMPDw8LCwcHBwcDAwMDAwMDAwMDBwcHBwsLDw8PExcXGxsfIycnKy8zNzs/Q0dLT1NXX2Nna3N3e4OHi5OXn6Onr7O7v8fL09vf5+vz9AAEECRAZJDFAUWR5kKnE4QAhRGmQueQRQHGk2RBJhMEAQYTJEFmk8UCR5DmQ6UShAGHEKZD5ZNFAsSSZEIkEgQCBBIkQmSSxQNFk+ZApxGEAoUTpkDnkkUDxpFkQyYRBAMGESRDZpHFAEeS5kGlEIQDhxKmQeWRRQDEkGRAJBAEAAQQJEBkkMUBRZHmQqcThACFEaZC55BFAcaTZEEmEwQBBhMkQWaTxQJHkOZDpRKEAYcQpkPlk0UCxJJkQiQSBAIEEiRCZJLFA0WT5kCnEYQChROmQOeSRQPGkWRDJhEEAwYRJENmkcUAR5LmQaUQhAOHEqZB5ZFFAMSQZEAkEAQAAAAAAAAAAAAAAAAAAAAABAQEBAQEBAgICAgIDAwMDBAQEBAUFBQUGBgYHBwcICAkJCQoKCgsLDAwNDQ4ODw8QEBEREhITExQUFRUWFxcYGRkaGhscHB0eHh8gISEiIyQkJSYnJygpKisrLC0uLzAxMTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1FSU1RVVldZWltcXV9gYWJkZWZnaWprbG5vcHJzdHZ3eXp7fX5/gYKEhYeIiouNjpCRk5SWl5manJ2foKKkpaepqqytr7GytLa3ubu9vsDCxMXHycvMztDS1NXX2dvd3+Hi5Obo6uzu8PL09vj6/P4A//z38Ofcz8CvnIdwVzwfAN+8l3BHHO/Aj1wn8Ld8PwC/fDfwp1wPwG8cx3AXvF8AnzzXcAecL8BP3Gfwd/x/AH/8d/Bn3E/AL5wHcNc8nwBfvBdwxxxvwA9cp/A3fL8AP3y38Cdcj8DvHEdwl7zfAB88V3CHnK/Az9zn8Pf8/wD//Pfw59zPwK+ch3BXPB8A37yXcEcc78CPXCfwt3w/AL98N/CnXA/AbxzHcBe8XwCfPNdwB5wvwE/cZ/B3/H8Af/x38GfcT8AvnAdw1zyfAF+8F3DHHG/AD1yn8Dd8vwA/fLfwJ1yPwO8cR3CXvN8AHzxXcIecr8DP3Ofw9/z/AP/////////////////////+/v7+/v79/f39/fz8/Pz8+/v7+vr6+vn5+fj4+Pf39/b29fX19PTz8/Ly8fHw8PDv7u7t7ezs6+vq6uno6Ofn5uXl5OPj4uHh4N/e3t3c3Nva2djY19bV1NTT0tHQz8/OzczLysnIx8bFxMPCwcDAvr28u7q5uLe2tbSzsrGwr62sq6qpqKalpKOioJ+enZyamZiWlZSTkZCPjYyLiYiHhYSCgYB+fXt6eHd1dHJxcG5sa2loZmVjYmBfXVtaWFdVU1JQTk1LSUhGREJBPz08Ojg2NDMxLy0rKigmJCIgHx0bGRcVExEPDQsJBwUDAf9/Px8PBwMBgEAgEAgEAgEAAQEBAQEBAQEBAQEA//////////////+AEAcAAQABAAEBAAEBAAEA/wD//wD//wD/AP+AKwcBAAEAAQD/AP8A/wD/AP8A/wABAAEAAQCARgcBAQEBAQD//////////////wABAQEBAQGAYQf///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+AwODw+Pz+/xEAwAGxwj4E9cU+BfUKbwMKZ37+gCALI34LAiN+AwILGOsahhIDHBwcHPE9IN7BIRAAGVRdPgX1Cm8DCmcalhIjfAILfQIDAx0dHR3xPSDnIRgAGVRd8T0grskRAcAB6cI+BPUKbwMKZ37+gCALI34LAiN+AwILGOs+CvUahhIcHBwc8T0g9CN8Agt9AgMD8T0g0MkgIEZJTExFRCAgIFBPTFlHT05TIEhFTElDT1BURVJJTiBBQ1RJT04gIQDADgpwLHQsGhPWICI2ACwNIPE+oOoQyngBCQDlYmsJVF3hDMYKR3AsdCwaG9YgIjYALA0g8a/qEcrJ+hDK/jDI1gTqEMpHPqCQ/lA4Aj5QDgAM1ggw+3ghAcARBAB3xggZDSD5+hHKg+oRykf+UDgCPlAOAAzWCDD7eC4td9YIGQ0g+ckh9grzMf/PzVABr+Am4P/gD+BD4EL2SOBFPkDgQT4E4AfN9RM+CuoAAA4HeeBwJqCvIstsKPsNIPIh/v8yy30g+wEKABH1/yFpAc3kE+cCAVYAEQDBIVt2zeQTrwYYIWsOzYsUIYsOzaQUxwGwAxEAgCGhF8XlzeQT4cERAIjN5BMhAJgRAwABYMDHcc9yIwUg+BQdIPHN9RMhuxUGAc2WE82JEz5E4EGv4EU+A+D/+z4B6hLK4E0QAAB4zccTBSD6zZATxwEACFkhAIhzIwt4sSD5IQDHPv9FdyRwJCJ3JXclcCwg8x5/IQCYx3PPNgDL1DYIx3PLlCPLVCjuPoABDxARIAAhIpjF5XfL1HfLlDwZDSD1POEswQUg7D486jPLr+o0yz3qL8s+oOCCPgLqG8vNiRM+ROBBr+BFPgPg/68+ACEXyyI+CiI+IHev6h7L4ITgluodyz4B6h/L6g/D6g3KBlARnAjNxAjNcwsBLAHFzTsLzQAJwQt4sSDzzZATxwEACFkhAIhzIwt4sSD5zfUTeQYQIYMOzYsUPv/qKcsGgBGwCM3ECM2JEwEsAcXNbAzNAAnBC3ixIPOv6hLKzZATPpDgU/PHAbADEQCIIaEXzeQTzfUTIQIWBgHNlhPNiRM+ROBBr+BFPgPg//sY/j4D6gAgzcRGBgMhF8t+gCJ+gDwifoB3zckP+jDLb/oxy2fNtgs+AeCB8IG3IPv6Dcq3KAPNcwHJ+h3LBgARTg2Hb2AZKmZvTgkq4ItfKjzgjD1PKuCNe4eHg0cRAMUqEhwFIPp5h4eBRxEAxCoSHAUg+n3qMMt86jHLyfCL4I7wjOCP8I3gkBEAw9XlzcoQ4dHwpeaAEhwBAwAJ8JA94JAg6CEAxQYPKk+gXxq3IB95yzegXxq3IBYqT6BfGrcgD3nLN6BfGrcgBiwsLBhHLOXNyhDwlrcoKwYB8KXGP0/LfygBBcXwpMY/Vx4AzZMOe8H18KPGP1ceAM2TDsHhJCJwGAzhJPCjxj8i8KTGPyIsJRbDBg/wjj3gjsLiCz4C6gAgw1JhfBjcHwAL7mpIYL9vBgMhF8t+gCJ+gDwifoB3zckPIcsNEQDGzf4MI+U+A+oAICEgy83+DPocy9YIb+ocy82vYAYDESDLIWIOxeXVzcoQ4fCjxhQi8KQiNg8jVF3hIyMjwQUg5M3ERsE+AeoAIAr+/ygiEQDGbyYAKRnlAwoDbyYAKRleI1bhKmZvxc0xHMwAQMEY2T4B4IHwgbcg+8l+PMjl1c3KEAYB8KVPy38oAQXF8KTLf/UoAi88Vx4AzZMO8XsgAi88xn/B9fCjy3/1KAIvPFceAM2TDvF7KAIvPMZ/wdESE3gSE+EjIyMYsFANAgAIDAYCRCgoFANEKAAUE0QAABQSRAAoFAJVKCjsA1UoAOwTVQAA7BJVACjsAAAEBQAAAAEFAAEBAwIGAQEDBwYCAgAHAwICAAcEAwMBAgYDAwEFBgQEAAECBAQAAwIFBQQFBgUFBAcGMgAAzgAAADIAAM4AAAAyAADOKAAAHhEAChEAAAAACu8AHu8AFAAKFAD2FAAPCgAF6AAC4gAQ3gAQ4gD+CgD74g4C3Q4C4QAC4vIC3fIC4AAM4PsM4PsQ4/sJ3fsJ/wABAQICAwMEBAUFAAAGAQYCBgMGBAYFBgAHAQcCBwMHBAcFBwYICQoKCwsMDA0NDgoPDxAQEQoSEhMTERQVFRYVFxUYCBkIGggb/yAAD/AbD/DlD/9//3+XEQAAAGD/f5cRAAAYAP9/lxEAAIB8lxH/f/9/QHz/f18IAADLI8sSeC9HeS9PAyEAAH2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEn2Pb3yPZwk4BWd9kW+3yxPLEssoyxkJ0BPJ+hfLJgJvfuCcLzzgnn3GQG9+4Jvgn6/gmOCZ4JrgneChPkDgl/oYy29OfcZAb0bFeOCgeeCizdMQ8KPgpvCk4KnwpeCsr+Cg4KI+QOChzdMQ8KPgp/Ck4KrwpeCtwXkvPOCgr+CheOCizdMQ8KPgmfCk4JzwpeCf8Kbgl/Cp4JrwrOCd8KfgmPCq4JvwreCe+hnLJgJvTn3GQG9GxXjgoHkvPOChr+CizdMQ8KPgpvCk4KnwpeCswXngoHjgoa/gos3TEPCj4KfwpOCq8KXgra/goOChPkDgos3TEPCj4JnwpOCc8KXgn/Cm4JfwqeCa8KzgnfCn4JjwquCb8K3gnskq4KAq4KEq4KLwl1/woCYGV8t6ICDLe3soJy88X3qTMAIvPG96g1YlXiVvfiVuZxl8LzwYH3ovPFfLeyjhey88X5IwAi88b3qDViVeJW9+JW5nGXxH8Jhf8KEmBlfLeiAgy3t7KCcvPF96kzACLzxveoNWJV4lb34lbmcZfC88GB96LzxXy3so4XsvPF+SMAIvPG96g1YlXiVvfiVuZxl8T/CZX/CiJgZXy3ogIMt7eygnLzxfepMwAi88b3qDViVeJW9+JW5nGXwvPBgfei88V8t7KOF7LzxfkjACLzxveoNWJV4lb34lbmcZfICB4KPwml/woCYGV8t6ICDLe3soJy88X3qTMAIvPG96g1YlXiVvfiVuZxl8LzwYH3ovPFfLeyjhey88X5IwAi88b3qDViVeJW9+JW5nGXxH8Jtf8KEmBlfLeiAgy3t7KCcvPF96kzACLzxveoNWJV4lb34lbmcZfC88GB96LzxXy3so4XsvPF+SMAIvPG96g1YlXiVvfiVuZxl8T/CcX/CiJgZXy3ogIMt7eygnLzxfepMwAi88b3qDViVeJW9+JW5nGXwvPBgfei88V8t7KOF7LzxfkjACLzxveoNWJV4lb34lbmcZfICB4KTwnV/woCYGV8t6ICDLe3soJy88X3qTMAIvPG96g1YlXiVvfiVuZxl8LzwYH3ovPFfLeyjhey88X5IwAi88b3qDViVeJW9+JW5nGXxH8J5f8KEmBlfLeiAgy3t7KCcvPF96kzACLzxveoNWJV4lb34lbmcZfC88GB96LzxXy3so4XsvPF+SMAIvPG96g1YlXiVvfiVuZxl8T/CfX/CiJgZXy3ogIMt7eygnLzxfepMwAi88b3qDViVeJW9+JW5nGXwvPBgfei88V8t7KOF7LzxfkjACLzxveoNWJV4lb34lbmcZfICB4KXJ9T6D4EDxyfWv4EDxyfXF1eXHKv7/KFD+FiAaTiMqh4eHVF1vJgApKXgGmAlHelRne11vGNzGYBLPeBIcGNN2ACETyjQ1KPc1yfvFBmR2AAUg+8HJ+3YABSD7yfXF1eUqEhMLeLEg+OHRwfHJxeUBAKAhAMDNAxThwcnF5XEjBSD74cHJxdXlAQCAIZXKzQMU4dHBycXV5a/qFcuwIAwaEyIaEzIEDXjqFcvlxRq+EyAPIxq+IAkTIw0gCMHhGBkrGyMjBSDmecFPBBoTIhoTIiEVyzThDSDS+hXL4dHBydVfzXIUuzD60cnF9cH6FMrLD6mAR/CLkR+AR/AFqOoUysHJ9cXltxcXF/aA4Ggq4GkFIPo+5OBH4cHxyfXF5bcXFxf2gOBqKuBrBSD6PuTgSOBJ4cHxyT4Q4ADwAC/LN+bwRz4g4ADwAC/mD7DqFsvJzyEAgK8GIE8+CCINIPwFIPnHIQCABiBPIg0g/AUg+cnFzQMVSs0eFcHJxc0RFUjNGRVLzSMVwcnFBgHNKxXBycUGABj2xQYDGPHFBgLNKxXByfXlh4eAJsBvceHxyfXlh4cmwG9GI04jXiNW4fHJ9cXV5eCDKjzK8BPWIF/wg835FF95xghPezwY6PXF1eXF1c13FdHBex4FIS3LGNUBKssR8NjNlRURGPzNlRURnP/NlRUR9v/NlRUR//8+LzwZOPwCA3ovV3svXxMZyTAwRlBT/zAwUE5UU/8wMExJTkVT/xYFB1dFTENPTUUgVE8WBQgtUkVBTFRJTUUtFgAJREVNTyBNQURFIEVTUEVDSUFMTFkWAQpGT1IgTENQJzIwMDAgUEFSVFn/FgAAR1JFRVRJTlg6ICAgICAgICAgICAWAAFEU0MsUEFOLFNBQixGQVRBTElUWRYAAkpFRkYgRlJPSFdFSU4sSUNBUlVTFgADRE9YLFFVQU5HLEFCWVNTICAgICAWAAQgICAgICAgICAgICAgICAgICAgIBYABUNSRURJVFM6ICAgICAgICAgICAgFgAGQUxMIEdGWCZDT0RFIEJZIEFHTyAWAAdIRUxJQ09QVEVSIDNEIE1PREVMIBYACENSRUFURUQgQlkgQlVTWSAgICAgFgAJICAgICAgICAgICAgICAgICAgICAWAApVU0VEIFNPRlRXQVJFOiAgICAgIBYAC1JHQkRTLE5PJENBU0gsRkFSICAgFgAMICAgICAgICAgICAgICAgICAgICAWAA1DT05UQUNUOiAgICAgICAgICAgIBYADkdPQlVaT1ZAWUFIT08uQ09NICAgFgAPSFRUUDovL1NQRUNDWS5EQS5SVSAWABAgICAgICAgICAgICAgICAgICAgIBYAEVNFRSBZT1UgT04gR0JERVYyMDAw/wAAAAAAAAAAAAAAAAAAAAAICBwUHBQ4KDgoMDBwUCAgKCh8VHxUKCgAAAAAAAAAABQUPip/QT4qfFT+gnxUKCgICDw0fkL8rP6Cfmr8hHhYJCR+Wn5SPCR4SPyU/LRISBgYPCR+Wjwkflr8tH5KNDQQEDgocFAgIAAAAAAAAAAABAQOChwUOCg4KDgoHBQICBAQOCgcFBwUHBQ4KHBQICAAABQUPio8NH5CPCx8VCgoAAAICBwUPDR+QjwsOCgQEAAAAAAAAAAAEBA4KHBQcFAAAAAAAAB8fP6CfHwAAAAAAAAAAAAAAAAwMHhIeEgwMAQEDgoeEjwkeEjwkOCgQEAYGDwkflr+qv6q/LR4SDAwGBg8JHxUPDQ4KHxs/oJ8fBwcPiJ+Wjw0eEj8vP6CfHwcHD4iflo8NE5K/LR4SDAwJCR+Wn5afFT8tP6CfGwQEBwcPiJ8XPyEfnr8tHhIMDAYGDwkeFj8pP66/LR4SDAwPDx+Qv66XFQ4KHBQcFAgIBwcPiJ+Wjwkflr8tPiIcHAcHD4iflr+sn5KfHT4iHBwAAAAAAgIHBQICBAQOCgQEAAACAgcFAgIEBA4KDgocFAAAAAAHBQ4KHBQcFA4KAAAAAAAADw8fkJ8fPyEeHgAAAAAAAA4KBwUHBQ4KHBQAAAYGDwkflr8tHhoEBA4KBAQHBw+In5a/rL8pPi4+IhwcBwcPiJ+Wv66/oL+uvy0SEg4OHxEflr8pP6a/LT4iHBwHBw+In5a5qbgoP6y/IxwcDAweEh8VH5a7qr+uvyEeHgcHD4ifFx8RHhY/Lz+gnx8HBw+Inxc/IT4uOCg4KBAQBwcPiJ+Wvy8/qL+uvyEeHgkJH5a/rr+gv66/LT8tEhIPDx+QjwsOChwUHhY/IR4eDw8fkI+Og4KXFT8tHhIMDAkJH5afFR+Qv66/LT8tEhIICBwUHBQ4KDkpP66fEQ4OCgofFR+Qv6q/rr8tPy0SEgkJH5a/pr+qv6y7qr8tEhIHBw+In5a7qruqvy0+IhwcBwcPiJ+Wv66/IT4uOCgQEAcHD4iflr+uv6q/LT+inZ2HBw+In5a/LT4iPy0/LRISBwcPiJ8XP6Cfnr8tPiIcHB8fP6CfGw4KHBQcFBwUCAgJCR+Wn5a7qruqvy0eEgwMERE7qruqnxUfFR4SHBQICAkJH5aflr+uv6q/KR8VCgoJCR+WnxUOCg8JH5a/LRISCQkflr8tPy0eEhwUHBQICA8PH5C/LT46Dwsflr8hHh4HBw+IjwsOChwUHhYfEQ4OEBA4KDwkHhIPCQeEg4KBAQ4OHxEPDQcFDgoeGj4iHBwGBg8JH5a7qpERAAAAAAAAAAAAAAAAAAAAAB8fP6CfHx81rdPfJJne5X1MAIvPEevyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxnLEcsXlDABhMsRyxeUMAGEyxHLF5QwAYTLEcsXlDABhMsRyxeUMAGEyxHLF5QwAYTLEcsXlDABhMsRyxeUMAGEeRcvT/F5MAIvPIVvJrcBAAA+t7zLEbrLED6/vcsRu8sQPj+8P8sRuj/LEL0/yxG7P8sQeLHIeKHAebcgB3xiV31rX3jLH9L/HD5AlU97lW96lPUwAi88R6/LGTABgB/LGTABgB/LGTABgB/LGTABgB/LGTABgB/LGTABgB/LGTABgB/LGTABgB/LGcsRyxeVMAGFyxHLF5UwAYXLEcsXlTABhcsRyxeVMAGFyxHLF5UwAYXLEcsXlTABhcsRyxeVMAGFyxHLF5UwAYV5Fy9P8XkwAi88hGcuQMMxHMsf0pcdPkCUT3qUZ3uV9TACLzxHr8sZMAGAH8sZMAGAH8sZMAGAH8sZMAGAH8sZMAGAH8sZMAGAH8sZMAGAH8sZMAGAH8sZyxHLF5QwAYTLEcsXlDABhMsRyxeUMAGEyxHLF5QwAYTLEcsXlDABhMsRyxeUMAGEyxHLF5QwAYTLEcsXlDABhHkXL0/xeTACLzyFbyZAwzEcyx/SoRt91r9PfZNvepT1MAIvPEevyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxnLEcsXlTABhcsRyxeVMAGFyxHLF5UwAYXLEcsXlTABhcsRyxeVMAGFyxHLF5UwAYXLEcsXlTABhcsRyxeVMAGFeRcvT/F5MAIvPIRnLr/DMRz//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////3q8MAVUZ3tdb3u90pdAfZNPepRfkTA+V3nLPy88g+CDPn+R5YdPbyYARCkpKQkBkVIJweV41kAXb3nWQB8fH+YPZ/CChGd55gcGB/YITwpP8INHLMl5S1+RV3nLPy88g+CDPneR5YdPbyYARCkpKQkBklsJweV41kAXb3nWQB8fH+YPZ/CChGd55gcGB/YITwpP8INHLMmVT3qUX5EwPld5yz8vPIPggz5/keWHT28mAEQpKSkJAR9BCcHleNZAF2951kAfHx/mD2fwgoRneeYHBgf2CE8KT/CDRyzJeUtfkVd5yz8vPIPggz53keWHT28mAEQpKSkJASBKCcHleNZAF2951kAfHx/mD2fwgoRneeYHBgf2CE8KT/CDRyzJfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkfrF3e8t4IAN6LCyAR8sJMAEkyX6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALH6xInvLeCAGessJMAEkgEcALMl+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASV+sXd7y3ggA3osLIBHywEwASXJfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsfrF3e8t4IAZ6ywEwASWARywsyf///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wHRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyLRe7o4A1pXewYHoE8K9XqgTwQK4JF6Hx8f5g9X8JNnTixGLXsfHx/mD1/wgoNne5LRxADB8JGiVy+mX3qhsyJ6L6ZfeqCzItF7ujgDWld7BgegTwr1eqBPBArgkXofHx/mD1fwk2dOLEYtex8fH+YPX/CCg2d7ktHEAMHwkaJXL6ZfeqGzInovpl96oLMi0Xu6OANaV3sGB6BPCvV6oE8ECuCReh8fH+YPV/CTZ04sRi17Hx8f5g9f8IKDZ3uS0cQAwfCRolcvpl96obMiei+mX3qgsyIxDsrh+eEWwxgNIf3Er+oLyuoMyiwsLPCPPcjgj14sGrcqKPDGeeCT+g3Ktygm+gvKPP4DIAI+AeoLyiAH+gzKPOoMyvoMyl8WyvCT1nkSe8bH4JMqTypHKuUmxl+Hh4M8PG8qX1Z5h4eBPDxveE4sh4eARjw8bypmb3y6OAViV31rX3y4OAVgR31pT3q4OAVQR3tZT3iU4JR8h+CV5dXFr+CSzUpifeCS0eHVzUpi0eE+AeCSzUpi8JRfPniTZy5Hr8sdMAGEH8sdMAGEH8sdMAGEH8sdMAGEH8sdMAGEH8sdMAGEH8sdMAGEH8sdMAGEH8sdxkBnCA7KMQDC5fCVb8l7vTBVfZNPepRfkTAkV3nLPy88Rz5/kU3Fh09vJgBEKSkJAfdiCcHlJsLwkm94BoDJeUtfkVd5yz8vPEc+d5FNxYdPbyYARCkpCQH4ZwnB5SbC8JJveAaAyZVPepRfkTAkV3nLPy88Rz5/kU3Fh09vJgBEKSkJAalsCcHlJsLwkm94BoDJeUtfkVd5yz8vPEc+d5FNxYdPbyYARCkpCQGqcQnB5SbC8JJveAaAyYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNg7gwBZOCcSwsDYO4MAWTgnEsLA2DuDAFk4JxLCwNyXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDXEsLIO4MAOTgg1xLCyDuDADk4INcSwsg7gwA5OCDcmDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDIO4MAWTgnEsLAyDuDAFk4JxLCwMg7gwBZOCcSwsDMlxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggxxLCyDuDADk4IMcSwsg7gwA5OCDHEsLIO4MAOTggzJxg+Hh+oawXovpl96obMiei+mX3qgszIkeRgAInAtJCJwLSQicC0kInAtJCJwLSQicC0kInAtJCJwLSQicC0kInAtJCJwLSQicC0kInAtJCJwLSQW/8n///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+qqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVACEzDDPAABIAEjPAMwwAIQAhMwwzwAASABIzwDMMACEAITMMM8AAEgASM8AzDAAhACEzDDPAABIAEjPAMwwAIQAhMwwzwAASABIzwDMMACEAITMMM8AAEgASM8AzDAAhACEzDDPAABIAEjPAMwwAIQAhMwwzwAASABIzwDMMACEAITMMM8AAEgASM8AzDAAhACEzDDPAABIAEjPAMwwAIQAhMwwzwAASABIzwDMMACEAITMMM8AAEgASM8AzDAAhACEzDDPAABIAEjPAMwwAIQAhMwwzwAASABIzwDMMACEAITMMM8AAEgASM8AzDAAhACEzDDPAABIAEjPAMwwAIQj8GH4y/WT7wO+B50CzINkI/Bh+Mv1k+8DvgedAsyDZCPwYfjL9ZPvA74HnQLMg2Qj8GH4y/WT7wO+B50CzINkI/Bh+Mv1k+8DvgedAsyDZCPwYfjL9ZPvA74HnQLMg2Qj8GH4y/WT7wO+B50CzINkI/Bh+Mv1k+8DvgedAsyDZCPwYfjL9ZPvA74HnQLMg2Qj8GH4y/WT7wO+B50CzINkI/Bh+Mv1k+8DvgedAsyDZCPwYfjL9ZPvA74HnQLMg2Qj8GH4y/WT7wO+B50CzINkI/Bh+Mv1k+8DvgedAsyDZCPwYfjL9ZPvA74HnQLMg2Qj8GH4y/WT7wO+B50CzINnMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzzMzMzDMzMzPMzMzMMzMzM8zMzMwzMzMzwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDMDAwMAMDAwMwMDAwAwMDAzAwMDADAwMDPHxAQEBAQEBHx8QEBAQEBDx8QEBAQEBAR8fEBAQEBAQ8fEBAQEBAQEfHxAQEBAQEPHxAQEBAQEBHx8QEBAQEBDx8QEBAQEBAR8fEBAQEBAQ8fEBAQEBAQEfHxAQEBAQEPHxAQEBAQEBHx8QEBAQEBDx8QEBAQEBAR8fEBAQEBAQ8fEBAQEBAQEfHxAQEBAQEPHxAQEBAQEBHx8QEBAQEBDx8QEBAQEBAR8fEBAQEBAQ8fEBAQEBAQEfHxAQEBAQEPHxAQEBAQEBHx8QEBAQEBDx8QEBAQEBAR8fEBAQEBAQ8fEBAQEBAQEfHxAQEBAQEPHxAQEBAQEBHx8QEBAQEBCqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlVVqqpVVaqqVVWqqlUC4XIscAl7InAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJLCwly2XIJGjJycnJyeEicAlyLHAJeyJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSwsJctlyCRoycnJycnhInAJInAJcixwCXsicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCXLZcgkaMnJycnJ4SJwCSJwCSJwCXIscAl7InAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJLCwly2XIJGjJycnJyeEicAkicAkicAkicAlyLHAJeyJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSwsJctlyCRoycnJycnhInAJInAJInAJInAJInAJcixwCXsicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCXLZcgkaMnJycnJ4SJwCSJwCSJwCSJwCSJwCSJwCXIscAl7InAJInAJInAJInAJInAJInAJInAJInAJInAJLCwly2XIJGjJycnJyeEicAkicAkicAkicAkicAkicAkicAlyLHAJeyJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSwsJctlyCRoycnJycnhInAJInAJInAJInAJInAJInAJInAJInAJcixwCXsicAkicAkicAkicAkicAkicAkicAksLCXLZcgkaMnJycnJ4SJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCXIscAl7InAJInAJInAJInAJInAJInAJLCwly2XIJGjJycnJyeEicAkicAkicAkicAkicAkicAkicAkicAkicAkicAlyLHAJeyJwCSJwCSJwCSJwCSJwCSwsJctlyCRoycnJycnhInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJcixwCXsicAkicAkicAkicAksLCXLZcgkaMnJycnJ4SJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCXIscAl7InAJInAJInAJLCwly2XIJGjJycnJyeEicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAlyLHAJeyJwCSJwCSwsJctlyCRoycnJycnhInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJInAJcixwCXsicAksLCXLZcgkaMnJycnJ4SJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCSJwCXIscAl7LCwly2XIJGjJycnJydE+t5LI4IXmB8RSRPCFHx8focjlzTJE4XkicCwicCwicCwicCwicCwicCwicCwicCzJ+ABUXWhHeZAfyx1nATNZCfCCMQCv/qAoAzEAvwH/AOlHPgeQVF1HDjOvyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxkwAYAfyxlHIbRXCeViaz7/AQ8Ayfoay2/6G8uFZ/4UIAU+/y0YBtbsIAU8LOoby3zqGsvNr2AhlEbNyhDwpMagV/Cjxn9f1SGXRs3KEPCkxqBn8KPGf2/RzTEcKAsf2hhZH9oYWcPERny6OAViV31rX+XNmkbh1Xu90sxFe9ZA4Ih9k0884Il6lF/ghjzgij2RMGvgh3nLPy88g+CF8IIBDwBvVHzWQBfLN6GFZ3rmBxdvGAjwij3KAETgivCJX/CGV/CFGASCHSgLy38g+Ffwh4LghR3NYkUY2nvgifCIg1/l5gf2CG8mB1Z7aB8fHx/LHR/LHeYDxkBnrx7/6XnghpPgh3vLPy88geCF8IIBDwBvVHzWQBfLN6GFZ3rmBxdv8Ilf8IZX8IXLfyAHV/CHgh0YAYLghc1iRfCKPcoAROCKGN171kDgiHuVTzzgiXqUX+CGPOCKPZEwa+CHecs/LzyD4IXwggEPAG9UfNZAF8s3oYVneuYHF28YCPCKPcoAROCK8Ilf8IZX8IUYBIIdKAvLfyD4V/CHguCFHc0qRhjae+CJ8IiTX+XmB/YQbyYHVntoHx8fH8sdH8sd5gPGQGc+/1jpeeCGk+CHe8s/LzyB4IXwggEPAG9UfNZAF8s3oYVneuYHF2/wiV/whlfwhct/IAdX8IeCHRgBguCFzSpG8Io9ygBE4IoY3UYAALoAAHzWQMhPHx8f5h9HeeYHKAsE/gUwBvUhylblBT4PkCHJRoRn5fCCZ69vyfCCZ69vIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIsnxAQ8APcqEVz0odj0oOj0idwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwksLCXLZSgCJGgidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwksLCXLZSgCJGgidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwksLCXLZSgCJGgidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkidwkid8kicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCUicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCUicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCUicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCUicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCUicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAksLCUicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAkicAloyfgAVF3wgjEAr/6gKAMxAL8B/wDFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcXFxcVia/nJJgJ+4JovPOCYfcZAb37gl+Cbr+CZ4JzgneCePkDgn8n/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Aw=="


// End of realtime.js file.

class ArrayObject {
    var array: Array<Int64> = []
}

func deBugLog( str: String) {
    let isLog = false
    if ( isLog) {
        print(str)
    }
}

/*
 * @State
 * @Tags Jetstream2
 */
class Benchmark {
    /*
     * @Setup
     */
    func setupGameboy() {
        initializeWebKitAudio()
        decodedgameboyrom = base64decode(gameboy_rom)
    }
    /*
     * @Benchmark
     */
    func runGameboy() {
        deBugLog("This is runGameboy")
        start(GameBoyCanvas(), decodedgameboyrom)
        
        gameboy.getOrThrow().instructions = 0
        gameboy.getOrThrow().totalInstructions = 250000
        
        while ( (gameboy.getOrThrow().instructions <= gameboy.getOrThrow().totalInstructions)) {
            deBugLog("This is runGameboy instructions: ${gameboy.getOrThrow().instructions}")
            gameboy.getOrThrow().run()
            GameBoyAudioNode.run()
        }
        
        resetGlobalVariables()
    }
    /*
     * @Teardown
     */
    func tearDownGameboy() {
        decodedgameboyrom = ""
        expectedGameboyStateStr = ""
    }
}

class Timer {
    public func getTime() {
        let time = DateTime.now()
        return time 
    }
}

func gbemuRunIteration() {
    let start = Timer().getTime()
    let benchmark = Benchmark()
    benchmark.setupGameboy()
    for (_ in 0..20) {
        benchmark.runGameboy()
    }
    benchmark.tearDownGameboy()
    let end = Timer().getTime()
    println("gbemu: ms =  ${Float64((end-start).toNanoseconds())/1000000.0}")
}

main(){
    gbemuRunIteration()
}
