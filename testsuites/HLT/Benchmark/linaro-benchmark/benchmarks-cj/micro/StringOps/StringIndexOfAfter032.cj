/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping %f -o %output
// RUN-EXEC: %export cjHeapSize=16GB && %export JETVMPROP="-Xmx2G" && %run %run_opt %output %run_args

import std.process.*
import std.time.*
import std.convert.*
import std.convert.*
import std.random.*
import std.collection.*

class StringOps {
    private static let NUM_LENGTH_TESTS :Int32 = 6
    private static let RANDOM_STRING_8 :Int32 = 0
    private static let RANDOM_STRING_16 :Int32 = 1
    private static let RANDOM_STRING_32 :Int32 = 2
    private static let RANDOM_STRING_128 :Int32 = 3
    private static let RANDOM_STRING_512 :Int32 = 4
    private static let RANDOM_STRING_2048 :Int32 = 5
    private static  let SAME_SEED :Int32 = 0
    private static  var MIN_RANDOM_CHAR :Byte = 65
    private static  var MAX_RANDOM_CHAR :Byte = 123
    private static let rnd :Random = Random(UInt64(SAME_SEED))
    private static let rndAlt :Random = Random(UInt64(SAME_SEED))
    private static var stringIndexOfAfterResult :Int32 = 0
    private static var searchChar :Byte = UInt8(UInt32(r' '))

    private static var stringEqualsResults :Array<Bool> = Array<Bool>(Int64(NUM_LENGTH_TESTS),repeat:false)
    private static var stringData :Array<String> = Array<String>(Int64(NUM_LENGTH_TESTS),repeat:"")
    private static var stringDataAlt :Array<String> = Array<String>(Int64(NUM_LENGTH_TESTS),repeat:"")

    public static func generateRandomStringFromRange(len :Int32,rnd :Random,minValue :Byte, maxValue :Byte) :String{
      if (maxValue < minValue) {
        throw IllegalArgumentException("Cannot generate random string"+ " - maxValue is smaller than minValue")
      }
      var sb :StringBuilder= StringBuilder()
      for (i in 0..len - 1) {
        sb.append(Rune(minValue + rnd.nextUInt8(maxValue - minValue)))
      }
      sb.append(Rune(maxValue))
      return sb.toString()
    }

   public static func generateRandomString(len :Int32,rnd : Random) :String{
      return generateRandomStringFromRange(len, rnd, MIN_RANDOM_CHAR, MAX_RANDOM_CHAR)
    }

   public static func generateRandomStrings(rnd :Random,output :Array<String>) :Unit{
      output[Int64(RANDOM_STRING_8)] = generateRandomString(8, rnd)
      output[Int64(RANDOM_STRING_16)] = generateRandomString(16, rnd)
      output[Int64(RANDOM_STRING_32)] = generateRandomString(32, rnd)
      output[Int64(RANDOM_STRING_128)] = generateRandomString(128, rnd)
      output[Int64(RANDOM_STRING_512)] = generateRandomString(512, rnd)
      output[Int64(RANDOM_STRING_2048)] = generateRandomString(2048, rnd)
    }

  public func generateRandomStr() :Unit{
       generateRandomStrings(rnd, stringData)
       generateRandomStrings(rndAlt, stringDataAlt)
       searchChar = MAX_RANDOM_CHAR
  }

  public func timeStringIndexOfAfter032(iterations :Int32) :Unit{
    
    for (i in 0..iterations) {
       stringIndexOfAfterResult += Int32(stringData[Int64(RANDOM_STRING_32)].indexOf(searchChar ,1) ?? -1)
     }
   }

}

  let ITER_COUNT :Int32 = 22000
  @OverflowWrapping
  main() :Unit{
    var reps: Int32 = 10
    var args = Process.current.arguments
         if (args.size == 1) {
             var num = Int32.tryParse(args[0])??0
             if (num != 0) {
                 reps = num
             }
         }
     let obj :StringOps = StringOps()
     obj.generateRandomStr()
     var startTime = DateTime.now()
     obj.timeStringIndexOfAfter032(ITER_COUNT)
     var endTime = DateTime.now()
     var durTime = endTime - startTime
     var perTime: Float64 = Float64(durTime.toNanoseconds())/Float64(reps)

     print(perTime.format(".2") + "ns\n")
 }

