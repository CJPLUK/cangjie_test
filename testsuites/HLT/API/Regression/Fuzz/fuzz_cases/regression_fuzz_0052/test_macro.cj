/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE:  macro_definition.cj
// EXEC: %compiler %cmp_macro macro_definition.cj
// EXEC-PIPE-1: %compiler %cmp_opt %macro_lib %f -o %output 2>&1 | compare %f

import define.*
@echo public var var20 : Class15 = Class15()
@echo public var var66 : Int64 = Int64(UInt16(232))
@echo var var82 : Range<UInt64> = ((UInt64(Int32(-73))&127)..(UInt64(UInt8(84))&127):((Int64(UInt8(Int8(Int8(-45))))|1)))
@echo public var var116 : (Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8)) = (((UInt64(93)&127)..=(UInt64(Int32(39))&127):((125|1))), Int16(UInt16(200)), UInt32(Int32(UInt16(Int16(-36)))), Int32(UInt32(13)), (Float32(Float32(-60.0)), UInt16(241), (), 'K', Int8(UInt8(125)), UInt8(Int8(UInt8(199)))))
@echo public var var207 : Bool = (UInt16(Int8(UInt8(Int8(-106)))) is Array<UInt16>)
@echo let var227 : Unit = ()
@echo let var259 : (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32) = (Int64(UInt32(UInt8(Int8(103)))), Int64(UInt16(66)), ((UInt8(Int8(-10))&127)..(UInt8(Int8(-116))&127):((Int64(Int16(-32))|1))), UInt16(127), ((Result<String>.Err(Exception("LangFuzz Inner Exception")) as Result<String>) is String), ((Int16(23)&127)..(Int16(-45)&127):(9|1)), Int32(UInt32(UInt32(Int8(-18)))))
@echo public let var300 : Float32 = Float32(-75.0)
@echo public let var353 : Result<UInt32> = Result<UInt32>.Err(Exception("LangFuzz Inner Exception"))
@echo public var var361 : ((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8) = (([UInt16(154), UInt16(195), UInt16(155), UInt16(195), UInt16(46), UInt16(71), UInt16(82), UInt16(138), UInt16(228), UInt16(127)], UInt32(87), ((UInt8(Int8(-112))&127)..(UInt8(Int8(-103))&127):((31|1))), Float32(24.0), UInt32(143), UInt8(106)), UInt32(Int8(Int8(5))), Int8(UInt8(Int8(88))), Int8(UInt8(227)))
@echo let var400 : Float64 = 98.0
@echo public let var425 : Unit = ()
@echo public let var561 : Int32 = Int32(Int32(96))
@echo public var var572 : (Float32*UInt16*Unit*Rune*Int8*UInt8) = (Float32(27.0), UInt16(144), (), 'r', Int8(13), UInt8(3))
@echo var var654 : (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16) = ((([UInt16(175), UInt16(31), UInt16(187), UInt16(161), UInt16(145), UInt16(141), UInt16(207), UInt16(207), UInt16(70), UInt16(186)], UInt32(UInt8(14)), ((UInt8(173)&127)..(UInt8(223)&127):(((-74)|1))), Float32(-19.0), UInt32(Int32(-19)), UInt8(125)), UInt32(20), Int8(Int8(-31)), Int8(Int8(-64))), ((Int16(-43)&127)..(Int16(126)&127):((-78)|1)), 101, ((UInt8(194)&127)..=(UInt8(211)&127):(((-28)|1))), UInt16(UInt8(Int8(Int8(96)))))
@echo public let var725 : Class15 = Class15()
@echo public let var792 : String = "DSmf$Ddv\\9"
@echo public var var870 : Int16 = Int16(UInt16(104))
@echo public var var917 : UInt16 = UInt16(Int8(UInt8(20)))
@echo public var var935 : Enum757 = Enum757.defaultValue
@echo let var963 : UInt64 = UInt64(30)
@echo var var1057 : UInt64 = UInt64(163)
@echo public let var1228 : Int8 = Int8(UInt8(UInt8(UInt8(181))))
@echo public var var1248 : UInt8 = UInt8(UInt8(207))
@echo public var var1277 : Int32 = Int32(86)
@echo public var var1280 : Bool = false
@echo public let var1303 : Unit = ()
@echo public let var1307 : Unit = ()
@echo var var1339 : (Float64*Range<Int32>*(Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))*Enum757*Array<UInt16>*UInt64*Range<Int8>) = (Float64(Float32(-12.0)), ((Int32(Int8(72))&127)..(Int32(-78)&127):(((-118)|1))), (((UInt64(32)&127)..=(UInt64(95)&127):((Int64(Int32(118))|1))), Int16(Int16(UInt16(225))), UInt32(217), Int32(40), (Float32(Float32(123.0)), UInt16(UInt8(50)), (), 'm', Int8(-63), UInt8(Int8(83)))), Enum757.defaultValue, [UInt16(145), UInt16(252), UInt16(146), UInt16(145), UInt16(112), UInt16(251), UInt16(138), UInt16(34), UInt16(179), UInt16(82)], UInt64(Int8(UInt8(222))), ((Int8(Int8(UInt8(5)))&127)..=(Int8(Int8(58))&127):(((-68)|1))))
@echo public let var1412 : Interface18 = Class15()
@echo var var1492 : Array<Unit> = [(), (), (), (), (), (), (), (), (), ()]
@echo let var1645 : Result<Unit> = Result<Unit>.Err(Exception("LangFuzz Inner Exception"))
@echo public let var1691 : Range<Int32> = ((Int32(-32)&127)..=(Int32(-23)&127):(((-85)|1)))
@echo public var var1747 : Rune = 'V'
@echo public var var1766 : (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8) = ([UInt16(7), UInt16(18), UInt16(212), UInt16(109), UInt16(195), UInt16(165), UInt16(44), UInt16(226), UInt16(132), UInt16(235)], UInt32(Int16(UInt8(Int8(30)))), ((UInt8(UInt8(204))&127)..=(UInt8(Int8(Int8(-10)))&127):((20|1))), Float32(98.0), UInt32(UInt32(Int32(55))), UInt8(UInt8(206)))
@echo public let var1813 : Aggregate332 = Aggregate332()
@echo var var1939 : (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16) = ((([UInt16(115), UInt16(124), UInt16(134), UInt16(105), UInt16(77), UInt16(17), UInt16(197), UInt16(147), UInt16(251), UInt16(26)], UInt32(Int8(107)), ((UInt8(182)&127)..=(UInt8(54)&127):((-51)|1)), Float32(15.0), UInt32(Int32(105)), UInt8(UInt8(23))), UInt32(Int16(-42)), Int8(Int8(-37)), Int8(UInt8(192))), ((Int16(42)&127)..=(Int16(Int16(76))&127):((Int64(Int64(59))|1))), (-39), ((UInt8(28)&127)..=(UInt8(188)&127):((-5)|1)), UInt16(Int8(UInt8(8))))
@echo public let var2003 : Int8 = Int8(Int8(124))
@echo var var2195 : Result<Result<Range<UInt32>>> = Result<Result<Range<UInt32>>>.Err(Exception("LangFuzz Inner Exception"))
@echo var var2392 : Range<UInt8> = ((UInt8(UInt8(75))&127)..(UInt8(18)&127):((Int64(Int16(-128))|1)))
@echo public var var2402 : Range<Int16> = ((Int16(Int8(Int8(Int8(19))))&127)..=(Int16(UInt16(82))&127):((72|1)))
@echo var var2571 : Float32 = Float32(39.0)
@echo let var2780 : UInt16 = UInt16(113)
@echo public let var2826 : Int64 = (-18)
@echo public var var2901 : Range<UInt16> = ((UInt16(157)&127)..=(UInt16(100)&127):(115|1))
@echo let var3389 : Array<Result<Unit>> = Array<Result<Unit>>(10){ i => Result<Unit>.Err(Exception("LangFuzz Inner Exception")) }
@echo public var var3432 : Array<Range<UInt64>> = [((UInt64(Int8(-92))&127)..=(UInt64(49)&127):(((-31)|1))), ((UInt64(UInt16(Int8(19)))&127)..=(UInt64(223)&127):(((-116)|1))), ((UInt64(151)&127)..=(UInt64(1)&127):((-98)|1)), ((UInt64(113)&127)..(UInt64(UInt32(UInt16(127)))&127):((Int64(Int8(-4))|1))), ((UInt64(6)&127)..(UInt64(91)&127):((-77)|1)), ((UInt64(243)&127)..=(UInt64(199)&127):(((-44)|1))), ((UInt64(112)&127)..(UInt64(197)&127):(((-69)|1))), ((UInt64(Int8(46))&127)..=(UInt64(UInt8(149))&127):((Int64(Int8(23))|1))), ((UInt64(249)&127)..=(UInt64(199)&127):(41|1)), ((UInt64(116)&127)..=(UInt64(31)&127):((-26)|1))]
@echo public var var3488 : ?Bool = Option<Bool>.None
@echo public let var3523 : Bool = true
@echo public let var3533 : ?Enum757 = (Option<Result<Unit>>.None as Enum757)
@echo public let var3584 : UInt8 = UInt8(UInt8(239))
@echo public var var3629 : (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8) = ([UInt16(Int8(Int8(8))), UInt16(123), UInt16(UInt16(Int16(107))), UInt16(UInt8(UInt8(130))), UInt16(153), UInt16(UInt16(6)), UInt16(175), UInt16(191), UInt16(Int16(Int16(11))), UInt16(UInt16(Int8(-40)))], UInt32(61), ((UInt8(118)&127)..=(UInt8(100)&127):((Int64(UInt8(160))|1))), Float32(Float32(-36.0)), UInt32(Int16(-95)), UInt8(166))
@echo public var var3665 : UInt32 = UInt32(Int8(UInt8(UInt8(72))))
@echo public var var3855 : Result<Option<Result<String>>> = Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception"))
@echo public let var3893 : Result<Result<Option<Result<String>>>> = Result<Result<Option<Result<String>>>>.Err(Exception("LangFuzz Inner Exception"))
@echo public let var4192 : ?Result<String> = Option<Result<String>>.None
@echo public var var4204 : Result<Option<Result<String>>> = Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception"))
@echo let var4243 : UInt16 = UInt16(192)
@echo public var var4275 : Bool = ((Int32(UInt32(8)), UInt8(UInt8(6)), UInt64(UInt8(Int8(65))), ((Int8(27)&127)..=(Int8(50)&127):(22|1)), [Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception"))], UInt8(190), ()) is (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8))
@echo public let var4352 : UInt16 = UInt16(UInt16(155))
@echo public let var4460 : Bool = (Result<Range<UInt32>>.Err(Exception("LangFuzz Inner Exception")) is (UInt8) -> Result<Option<Result<String>>>)
@echo var var4576 : (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16) = ((([UInt16(6), UInt16(7), UInt16(4), UInt16(184), UInt16(213), UInt16(85), UInt16(35), UInt16(43), UInt16(154), UInt16(226)], UInt32(243), ((UInt8(80)&127)..(UInt8(162)&127):(((-58)|1))), Float32(Float32(-75.0)), UInt32(58), UInt8(UInt8(58))), UInt32(175), Int8(Int8(-41)), Int8(-72)), ((Int16(Int16(6))&127)..=(Int16(Int8(Int8(-64)))&127):(((-102)|1))), Int64(UInt64(UInt32(UInt32(234)))), ((UInt8(252)&127)..=(UInt8(169)&127):((Int64(UInt8(148))|1))), UInt16(Int8(Int8(79))))
@echo public let var4630 : Result<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)> = Result<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)>.Err(Exception("LangFuzz Inner Exception"))
@echo let var4642 : (Int32*UInt8*UInt64*Range<Int8>*Array<Result<Unit>>*UInt8*Unit) = (Int32(-13), UInt8(68), UInt64(63), ((Int8(97)&127)..(Int8(Int8(59))&127):(((-45)|1))), [Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception"))], UInt8(UInt8(144)), ())
@echo public let var4752 : Result<Option<Option<Result<Result<Option<Result<String>>>>>>> = Result<Option<Option<Result<Result<Option<Result<String>>>>>>>.Err(Exception("LangFuzz Inner Exception"))
@echo public let var4825 : ??Result<Result<Option<Result<String>>>> = Option<Option<Result<Result<Option<Result<String>>>>>>.None
@echo let var4869 : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) = ((Float32(-71.0), UInt16(197), (), 'c', Int8(101), UInt8(80)), ((Int32(-40)&127)..(Int32(39)&127):(79|1)), (Float32(-40.0), UInt16(115), (), 'q', Int8(Int8(-74)), UInt8(168)), Int8(UInt8(182)))
@echo let var5034 : Unit = ()
@echo public var var5120 : Result<Int8> = Result<Int8>.Err(Exception("LangFuzz Inner Exception"))
@echo public let var5237 : Bool = (([UInt64(0), UInt64(68), UInt64(151), UInt64(17), UInt64(91), UInt64(154), UInt64(44), UInt64(58), UInt64(206), UInt64(146)] as Unit) is (Int32*UInt8*UInt64*Range<Int8>*Array<Result<Unit>>*UInt8*Unit))
@echo var var5251 : Bool = (((([UInt16(71), UInt16(56), UInt16(156), UInt16(89), UInt16(166), UInt16(196), UInt16(254), UInt16(253), UInt16(168), UInt16(219)], UInt32(244), ((UInt8(96)&127)..(UInt8(131)&127):(112|1)), Float32(-99.0), UInt32(213), UInt8(184)), UInt32(UInt16(66)), Int8(116), Int8(UInt8(40))), ((Int16(87)&127)..=(Int16(-54)&127):((-52)|1)), Int64(UInt32(UInt32(36))), ((UInt8(UInt8(80))&127)..(UInt8(240)&127):((Int64(Int16(17))|1))), UInt16(143)) is (((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>), (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8), (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)) -> Bool)
@echo var var5378 : Array<Bool> = [false, false, true, false, true, false, false, false, true, true]
@echo public var var5391 : Bool = true
@echo public let var5467 : Int8 = Int8(60)
@echo public interface Interface18 {
    @echo func func23(namedParam24 ! : Float32, namedParam25 ! : Int16) : UInt16 { // block id: 26
        @echo let var40 : Array<UInt16> = Array<UInt16>(10){ i => UInt16(UInt8(101)) };
        @echo var var72 : UInt16 = UInt16(14);
        UInt16(var40[6]) ^ (var66, (-23), ((UInt8(66)&127)..(UInt8(75)&127):(10|1)), var72, false, ((Int16(-122)&127)..(Int16(93)&127):((-7)|1)), Int32(44))[3]
    }

}

@echo public open class Class15 <: Interface18 {
    @echo public init() { // block id: 17

    }
;
    @echo public func func23(namedParam24 ! : Float32, namedParam25 ! : Int16) : UInt16 { // block id: 26
        @echo let var40 : Array<UInt16> = Array<UInt16>(10){ i => UInt16(UInt8(101)) };
        @echo var var72 : UInt16 = UInt16(14);
        UInt16(var40[6]) ^ (var66, (-23), ((UInt8(66)&127)..(UInt8(75)&127):(10|1)), var72, false, ((Int16(-122)&127)..(Int16(93)&127):((-7)|1)), Int32(44))[3]
    }
;
    @echo public var var109 : UInt16 = UInt16(132);
    @echo public var var476 : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) = ((Float32(66.0), UInt16(20), (), 'G', Int8(22), UInt8(189)), ((Int32(-35)&127)..(Int32(-24)&127):((-43)|1)), (Float32(-122.0), UInt16(8), (), 'Z', Int8(24), UInt8(161)), Int8(32));
    @echo public let var728 : Unit = ();
    @echo public init(namedParam1041 ! : (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32), optionalParam1042 ! : UInt32 = UInt32(50), namedParam1044 ! : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8), optionalParam1045 ! : Result<UInt32> = Result<UInt32>.Ok(UInt32(19))) { // block id: 1048
        try { // block id: 1050
            if (false) { // block id: 1053
                var227;
                var1057 <<= ((UInt64(174)) & 7)
            } else if (true) { // block id: 1061

            };
            ((11&127)..=(108&127):((-98)|1));
            ()
        } catch (e: Exception) { // block id: 1064
            (Result<Unit>.Err(Exception("LangFuzz Inner Exception")) ?? ())
        }
    }
;
    @echo public static func func1824(param1825 : (Float32*UInt16*Unit*Rune*Int8*UInt8), namedParam1826 ! : Range<UInt16>, namedParam1827 ! : (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)) : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) { // block id: 1828
        @echo let var1830 : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = (((UInt64(1)&127)..(UInt64(30)&127):(123|1)), (-64), ((UInt16(63)&127)..=(UInt16(139)&127):(((-112)|1))), (), Float64(Float32(-43.0)), (), 119.0);
        var1830
    }
;
    @echo public init(param3021 : Int16) { // block id: 3022
        @echo var var3031 : ?Bool = Option<Bool>.Some(false);
        @echo let var3039 : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) = ((Float32(Float32(Float32(82.0))), UInt16(UInt16(Int8(76))), (), '5', Int8(UInt8(130)), UInt8(62)), ((Int32(-74)&127)..=(Int32(107)&127):(100|1)), (Float32(4.0), UInt16(Int8(-34)), (), 'm', Int8(-38), UInt8(79)), Int8(Int8(UInt8(UInt8(222)))));
        try { // block id: 3024
            try { // block id: 3026
                ();
                if (false) { var3031 } else { Option<Bool>.Some(var207) } 
            } catch (e: Exception) { // block id: 3036
                var3031
            };
            var3039
        } finally { // block id: 3066
            Int8(2);
            ();
            ((var300, var917, var1307, 'Z', Int8(-10), UInt8(179)), ((Int32(-25)&127)..=(Int32(-42)&127):(124|1)), var572, Int8(-30))
        }
    }
;
    @echo static let var3184 : Unit = ();
    @echo static let var3217 : UInt32 = UInt32(13);
    @echo public init(param2994 : Array<Unit>, optionalParam2995 ! : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = (((UInt64(Int32(-4))&127)..(UInt64(UInt8(Int8(-95)))&127):((Int64(85)|1))), Int64(UInt16(71)), ((UInt16(71)&127)..(UInt16(54)&127):((-111)|1)), (), (-51.0), (), Float64(Float32(Float32(Float32(-25.0))))), namedParam3015 ! : Result<String>, optionalParam3016 ! : Enum757 = Enum757.enumValue783(((UInt16(188)&127)..=(UInt16(197)&127):((-52)|1)), Class15(Int16(Int8(Int8(-58)))), Result<String>.Ok("Y}I'MBG\\zC"), ((UInt16(Int16(UInt16(169)))&127)..(UInt16(149)&127):((Int64(UInt8(161))|1))))) { // block id: 3092
        match (((UInt32(205)&127)..(UInt32(109)&127):(39|1))) {
            case _ => 
                var1248;
                Option<Bool>.Some(false)
            
        };
        @echo let var3106 : Range<UInt64> = ((UInt64(62)&127)..(UInt64(109)&127):(78|1));
        @echo let var3134 : Array<Range<UInt16>> = [((UInt16(70)&127)..(UInt16(134)&127):((Int64(17)|1))), ((UInt16(187)&127)..(UInt16(140)&127):((117|1))), ((UInt16(UInt16(Int8(6)))&127)..=(UInt16(Int16(UInt8(135)))&127):((Int64(UInt32(107))|1))), ((UInt16(63)&127)..=(UInt16(157)&127):((106|1))), ((UInt16(124)&127)..=(UInt16(212)&127):(27|1)), ((UInt16(Int16(UInt8(181)))&127)..(UInt16(130)&127):((44|1))), ((UInt16(177)&127)..=(UInt16(UInt8(79))&127):((43|1))), ((UInt16(37)&127)..(UInt16(56)&127):(63|1)), ((UInt16(105)&127)..=(UInt16(220)&127):(97|1)), ((UInt16(Int16(Int16(91)))&127)..=(UInt16(Int16(UInt16(118)))&127):((Int64(Int32(UInt16(242)))|1)))];
        match (([var3106, var3106, ((UInt64(250)&127)..=(UInt64(28)&127):(7|1)), var3106, ((var1057&127)..=(UInt64(54)&127):((105|1))), ((UInt64(72)&127)..=(UInt64(9)&127):((-117)|1)), ((UInt64(84)&127)..(UInt64(40)&127):(12|1)), ((var963&127)..(UInt64(183)&127):((var66|1))), var3106, ((UInt64(152)&127)..=(UInt64(241)&127):((-96)|1))][9], Int16(-15), (var353 ?? UInt32(157)), if (var1280) { // block id: 3130
                if (var1280) { var3134 } else { [((UInt16(90)&127)..=(UInt16(36)&127):(80|1)), ((UInt16(107)&127)..=(UInt16(237)&127):((-24)|1)), ((UInt16(26)&127)..=(UInt16(138)&127):((-26)|1)), ((UInt16(181)&127)..(UInt16(177)&127):((-47)|1)), ((UInt16(24)&127)..=(UInt16(123)&127):((-4)|1)), ((UInt16(161)&127)..=(UInt16(213)&127):(36|1)), ((UInt16(87)&127)..=(UInt16(149)&127):((-104)|1)), ((UInt16(125)&127)..=(UInt16(15)&127):(91|1)), ((UInt16(254)&127)..(UInt16(240)&127):(64|1)), ((UInt16(74)&127)..=(UInt16(70)&127):((-115)|1))] } ;
                var3184;
                Int32(55)
            } else { // block id: 3187
                var1057--;
                Int32(13)
            }, var572)) {
            case (caseVar3194,caseVar3195 : Enum757,caseVar3196,caseVar3197,caseVar3198) => 
                ();
                var1766
            
            case _ => 
                var1766
            
            case (_,caseVar3208 : Bool,_ : Option<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)>,caseVar3209,(_,_ : Result<Range<Int8>>,() | (),'q',caseVar3210 : ((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8),71)) => 
                if (false) { ([UInt16(195), UInt16(25), UInt16(6), UInt16(49), UInt16(28), UInt16(192), UInt16(88), UInt16(86), UInt16(57), UInt16(244)], var3217, ((UInt8(24)&127)..(UInt8(35)&127):((var66|1))), Float32(-122.0), var3217, UInt8(240)) } else { var1766 } 
            
            case _ => 
                var1303;
                @echo let var3236 : UInt16 = UInt16(Int16(126));
                if (true) { ([var2780, var3236, UInt16(159), UInt16(155), var3236, UInt16(60), UInt16(109), UInt16(107), UInt16(63), UInt16(43)], var3217, ((UInt8(15)&127)..=(var1248&127):((108|1))), Float32(-97.0), var3217, UInt8(231)) } else { var1766 } 
            
        }
    }
;
    @echo public open func func718(namedParam719 ! : Int8, namedParam720 ! : Range<Int8>, namedParam721 ! : UInt16) : Unit { // block id: 722
        var725.var728;
        @echo let var4684 : (Unit) -> Rune = func731;
        @echo var loopTimeVar4691 : Int64 = 0;
        do {
            loopTimeVar4691++;

        } while ((!true) && loopTimeVar4691 < 100 ) |>var4684;
        @echo var loopTimeVar4699 : Range<UInt64> = ((UInt64(Int8(21))&127)..=(UInt64(83)&127):((67|1)));
        for (i in loopTimeVar4699) if (((if (true) { var1645 } else { Result<Unit>.Err(Exception("LangFuzz Inner Exception")) } ) is Int8)) {

        }
    }

}



@echo public struct Aggregate332 {
    @echo public init() { // block id: 334

    }
;
    @echo private static let var412 : Array<Unit> = [(), (), (), (), (), (), (), (), (), ()];
    @echo public init(param339 : Rune, param340 : Range<Int16>) { // block id: 341
        @echo var var389 : (Float64) -> Range<UInt32> = { lambdaParameter392 : Float64 => ((UInt32(198)&127)..(UInt32(114)&127):(9|1)) };
        try { // block id: 396
            var227;
            var400 - 13.0
        } finally { // block id: 403
            var400
        }|>var389;
        try { // block id: 408
            var227;
            var227;
            var412
        } finally { // block id: 414
            if (false) { ((Int16(-41)&127)..(Int16(87)&127):(114|1)) } else { ((Int16(61)&127)..=(Int16(-54)&127):((-126)|1)) } ;
            var66;
            if (var207) { [(), var425, var425, var227, (), (), var227, (), var227, ()] } else { [(), var227, var227, (), var227, var425, var227, var227, (), var227] } 
        }[6]
    }
;
    @echo public var var450 : Unit = ();
    @echo static var var923 : Rune = 'y';
    @echo public static var var947 : Aggregate332 = Aggregate332();
    @echo private var var950 : UInt64 = UInt64(107);
    @echo static func func901(param902 : Float64, param903 : UInt64, namedParam904 ! : Array<Bool>) : UInt64 { // block id: 905
        @echo var var908 : (Array<Bool>) -> Unit = func735;
        namedParam904|>var908;
        try { // block id: 912
            (var300, var917, (), var923, Int8(98), UInt8(22))[2];
            @echo var loopTimeVar938 : Range<UInt64> = ((UInt64((-89))&127)..=(UInt64(Int8(101))&127):((47|1)));
            for (i in loopTimeVar938) if (false) {
                var425;
                if (var207) { var935 } else { var935 } 
            };
            var947.var950
        } catch (e: Exception) { // block id: 952
            try { // block id: 954
                var725
            } catch (_) { // block id: 956
                Class15()
            };
            UInt64(201) - UInt64(252)
        }
    }
;
    @echo var var1872 : ?Result<String> = Option<Result<String>>.None;
    @echo public func func1816(param1817 : Range<UInt8>, namedParam1818 ! : UInt8, namedParam1819 ! : Range<UInt16>) : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) { // block id: 1820
        @echo let var1851 : Bool = (((Int8(-17)&127)..(Int8(-73)&127):(104|1)) is Enum757);
        @echo let var1884 : Array<Range<UInt16>> = [((UInt16(UInt16(UInt16(33)))&127)..=(UInt16(118)&127):((Int64(Int8(UInt8(48)))|1))), ((UInt16(213)&127)..(UInt16(UInt8(143))&127):((Int64(UInt32(UInt32(181)))|1))), ((UInt16(27)&127)..=(UInt16(249)&127):(78|1)), ((UInt16(UInt16(169))&127)..=(UInt16(160)&127):(((-89)|1))), ((UInt16(Int8(107))&127)..=(UInt16(34)&127):((Int64(Int16(Int8(-45)))|1))), ((UInt16(152)&127)..(UInt16(218)&127):((-60)|1)), ((UInt16(Int8(Int8(113)))&127)..(UInt16(UInt8(Int8(-26)))&127):((Int64(UInt16(28))|1))), ((UInt16(18)&127)..=(UInt16(28)&127):(19|1)), ((UInt16(174)&127)..(UInt16(109)&127):((-39)|1)), ((UInt16(Int8(-83))&127)..(UInt16(14)&127):((57|1)))];
        Class15.func1824(match {
            case var1280 => 
            var1277 &= Int32(-68);
            if (var1851) { Class15() } else { var1412 } ;
            if (var1280) { var572 } else { (var300, UInt16(247), var1303, var1747, Int8(-46), UInt8(58)) } 
            case _ => 
            ();
            if (true) { Option<Result<String>>.None } else { var1872 } ;
            (var300, UInt16(5), var1307, var1747, Int8(-95), UInt8(54))
        }, namedParam1826 : var1884[0], namedParam1827 : (Option<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)>.None ?? var1939))
    }

}


@echo public func func343(param344 : Float64) : Range<UInt32> { // block id: 345
    (((var353 ?? UInt32(5))&127)..(var361[0][4]&127):((-(-(-83))|1)))
}


@echo public func func587(param588 : Bool) : UInt16 { // block id: 589
    match {
        case try { // block id: 594
        @echo let var596 : Bool = true;
        var596
    } finally { // block id: 598
        @echo let var600 : Bool = (((UInt64(UInt16(229))&127)..(UInt64(UInt32(171))&127):((Int64(Int32(UInt16(5)))|1))) is Float32);
        var600
    } => 
        var361;
        var227;
        @echo var var614 : (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16) = ((([UInt16(84), UInt16(175), UInt16(14), UInt16(148), UInt16(148), UInt16(215), UInt16(186), UInt16(94), UInt16(123), UInt16(193)], UInt32(Int8(104)), ((UInt8(217)&127)..(UInt8(220)&127):((116|1))), Float32(Float32(-51.0)), UInt32(95), UInt8(114)), UInt32(175), Int8(-31), Int8(UInt8(Int8(-49)))), ((Int16(-113)&127)..=(Int16(-62)&127):(34|1)), (-72), ((UInt8(70)&127)..=(UInt8(203)&127):((113|1))), UInt16(UInt8(234)));
        var614
        case _ => 
        var654
    }[4]
}

@echo public func func735(param736 : Array<Bool>) : Unit { // block id: 737

}


@echo public enum Enum757 {
    defaultValue |
    enumValue783(Range<UInt16>, Class15, Result<String>, Range<UInt16>) |
    enumValue838(Array<Unit>) |
    enumValue2501((((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16), UInt8)
}
@echo func func764(param765 : UInt64) : Enum757 { // block id: 766
    @echo let var795 : Range<UInt16> = ((UInt16(53)&127)..=(UInt16(194)&127):((-12)|1));
    @echo let var814 : Range<Int32> = ((Int32(2)&127)..(Int32(-29)&127):(89|1));
    @echo var var830 : UInt8 = UInt8(Int8(Int8(UInt8(243))));
    @echo var var836 : Enum757 = Enum757.enumValue838([(), (), (), (), (), (), (), (), (), ()]);
    @echo var var885 : UInt16 = UInt16(UInt8(Int8(UInt8(UInt8(85)))));
    try { // block id: 770
        @echo var var776 : Range<UInt64> = ((UInt64(65)&127)..=(UInt64(239)&127):(23|1));
        @echo var var800 : Range<Int8> = ((Int8(UInt8(UInt8(95)))&127)..=(Int8(Int8(60))&127):((25|1)));
        (var400, ((Int32(122)&127)..(Int32(68)&127):(61|1)), (var776, Int16(-115), UInt32(224), Int32(37), var572), Enum757.enumValue783(((UInt16(8)&127)..=(UInt16(192)&127):((-57)|1)), Class15(), Result<String>.Ok(var792), var795), [UInt16(222), UInt16(234), UInt16(14), UInt16(3), UInt16(102), UInt16(47), UInt16(182), UInt16(169), UInt16(24), UInt16(244)], param765, var800)
    } finally { // block id: 808
        @echo let var824 : UInt16 = UInt16(194);
        @echo let var844 : Range<Int8> = ((Int8(UInt8(Int8(-116)))&127)..(Int8(UInt8(UInt8(UInt8(203))))&127):((Int64(UInt8(108))|1)));
        @echo var var860 : Int32 = Int32(UInt16(UInt16(UInt8(Int8(59)))));
        if (var207) { (var400, var814, (((UInt64(103)&127)..=(UInt64(8)&127):((-106)|1)), Int16(122), UInt32(230), Int32(107), (var300, var824, (), '6', Int8(86), var830)), var836, [UInt16(189), UInt16(240), UInt16(207), UInt16(65), UInt16(232), UInt16(254), UInt16(120), UInt16(25), UInt16(187), UInt16(43)], UInt64(22), var844) } else { (var400, ((Int32(-106)&127)..(var860&127):((var66|1))), (((UInt64(108)&127)..(UInt64(218)&127):((-94)|1)), var870, UInt32(169), var561, var572), var836, [var824, var824, UInt16(167), UInt16(230), UInt16(4), var824, var885, UInt16(198), UInt16(155), UInt16(237)], param765, ((Int8(43)&127)..(Int8(16)&127):((-128)|1))) } 
    }[3]
}

@echo func func760(param761 : Int32) : Enum757 { // block id: 762
    Aggregate332.func901(var400, var963, namedParam904 : [true, true, var207, var207, false, false, false, var207, false, var207])|>func764
}








@echo func func1707(param1708 : Float64) : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) { // block id: 1709
    @echo var var1717 : Int8 = Int8(UInt8(69));
    @echo var var1738 : Result<Option<Enum757>> = Result<Option<Enum757>>.Err(Exception("LangFuzz Inner Exception"));
    @echo let var1750 : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = (((UInt64(213)&127)..(UInt64(UInt8(242))&127):(((-115)|1))), Int64(Int32(23)), ((UInt16(132)&127)..=(UInt16(202)&127):((-76)|1)), (), Float64(Float32(-96.0)), (), 56.0);
    try { // block id: 1711
        @echo var loopTimeVar1722 : Range<UInt64> = ((UInt64(162)&127)..(UInt64(UInt64(UInt64(UInt16(126))))&127):((Int64(UInt32(UInt8(199)))|1)));
        for (i in loopTimeVar1722) if (var207) {
            var1717 -= var1717;
            var1691
        };
        (var1738 ?? Option<Enum757>.None)
    } catch (_) { // block id: 1741
        (var259, var1747, var1750, var1766, Option<Enum757>.Some(Enum757.defaultValue))[4]
    };
    @echo let var1795 : ?(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = Option<(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)>.Some((((UInt64(193)&127)..(UInt64(64)&127):((-106)|1)), Int64(Int16(-104)), ((UInt16(UInt8(158))&127)..=(UInt16(107)&127):((Int64(UInt8(213))|1))), (), 46.0, (), 105.0));
    (var1795 ?? var1813.func1816(((var1248&127)..(var1248&127):((14|1))), namedParam1818 : UInt8(17), namedParam1819 : ((UInt16(179)&127)..(UInt16(241)&127):((-18)|1))))
}

@echo public func func2031(param2032 : Enum757) : UInt16 { // block id: 2033
    @echo var var2075 : Array<Bool> = [true, true, (((99&127)..((-5)&127):((-22)|1)) is Range<Int64>), false, false, true, (Enum757.enumValue838([(), (), (), (), (), (), (), (), (), ()]) is ((Float32*UInt16*Unit*Rune*Int8*UInt8), Range<UInt16>, (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)) -> (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)), ((Int64(UInt8(209)), Int64(UInt8(37)), ((UInt8(249)&127)..(UInt8(139)&127):(35|1)), UInt16(180), (UInt32(138) is Range<UInt32>), ((Int16(35)&127)..=(Int16(115)&127):((-76)|1)), Int32(-104)) is Array<Result<Unit>>), (((Int32(-99)&127)..(Int32(10)&127):(0|1)) is Range<Int8>), false];
    @echo var var2111 : Bool = ([true, false, false, false, false, true, true, false, false, true] is (Float32, Int16) -> UInt16);
    try { // block id: 2035
        match (var1766) {
            case _ => 
                @echo let var2042 : ?Enum757 = Option<Enum757>.Some(Enum757.defaultValue);
                Result<Option<Enum757>>.Ok(var2042);
                @echo var var2047 : Float64 = Float64(Float32(-46.0));
                var2047 = 28.0;
                var917 >> ((UInt16(146)) & 7)
            
        }
    } finally { // block id: 2054
        var227;
        if (true) { [[false, true, false, true, true, false, false, true, false, true], [false, true, true, false, false, false, false, true, false, false], [false, false, false, true, true, true, true, true, false, false], [false, false, true, true, true, true, false, true, false, false], [false, false, false, true, true, false, true, true, true, true], [false, true, true, true, false, true, false, false, false, true], [true, false, false, true, true, false, true, true, true, false], [false, false, false, true, true, true, true, false, true, true], [true, false, true, false, true, false, false, false, false, false], [false, true, true, true, false, true, false, false, false, false]] } else { [[true, false, false, true, false, true, true, false, false, true], [true, var207, var207, var1280, true, var1280, true, false, true, true], [true, true, false, false, true, false, false, false, false, true], [false, false, false, false, true, true, false, true, false, true], var2075, var2075, [true, false, false, true, true, false, true, true, false, false], var2075, [var207, false, false, false, var2111, false, true, true, false, true], var2075] } ;
        func587(false)
    }
}



@echo public func func2138(param2139 : Result<Range<Int8>>) : UInt32 { // block id: 2140
    @echo let var2201 : UInt32 = UInt32(41);
    if ([var1280, var207, var207, var1280, false, true, true, false, false, var1280][2]) { try { // block id: 2156
        ((UInt16(88)&127)..(UInt16(239)&127):(31|1));
        @echo var var2159 : Range<UInt32> = ((UInt32(UInt8(Int8(3)))&127)..(UInt32(Int16(Int16(39)))&127):((Int64(UInt32(Int8(UInt8(252))))|1)));
        var2159
    } finally { // block id: 2171
        @echo let var2181 : UInt32 = UInt32(68);
        if (var207) { ((UInt32(164)&127)..=(UInt32(188)&127):(((-10)|1))) } else { ((UInt32(205)&127)..(var2181&127):((var66|1))) } 
    } } else { ((var2195 ?? Result<Range<UInt32>>.Ok(((UInt32(197)&127)..=(UInt32(35)&127):(106|1)))) ?? ((var2201&127)..=(UInt32(100)&127):((var66|1)))) } ;
    var1307;
    @echo let var2218 : Int64 = Int64(UInt16(Int16(UInt8(UInt8(91)))));
    @echo let var2233 : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = (((UInt64(192)&127)..(UInt64(2)&127):((44|1))), Int64(UInt64(173)), ((UInt16(232)&127)..=(UInt16(226)&127):((19|1))), (), (-111.0), (), (-111.0));
    @echo var var2304 : ((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>) = ((Int64(UInt8(UInt8(192))), Int64(Int32(UInt8(181))), ((UInt8(Int8(108))&127)..(UInt8(76)&127):((Int64(Int32(-57))|1))), UInt16(Int8(UInt8(81))), (Result<Unit>.Ok(()) is (Enum757) -> UInt16), ((Int16(Int16(55))&127)..(Int16(37)&127):((108|1))), Int32(UInt8(116))), '3', (((UInt64(229)&127)..=(UInt64(114)&127):((-82)|1)), (-81), ((UInt16(238)&127)..(UInt16(205)&127):((40|1))), (), Float64(Float32(Float32(-3.0))), (), Float64(Float32(Float32(100.0)))), ([UInt16(UInt8(167)), UInt16(12), UInt16(Int8(-25)), UInt16(140), UInt16(41), UInt16(Int8(-28)), UInt16(76), UInt16(UInt16(21)), UInt16(2), UInt16(Int16(-100))], UInt32(Int8(-66)), ((UInt8(54)&127)..(UInt8(Int8(-62))&127):((67|1))), Float32(-81.0), UInt32(UInt8(61)), UInt8(108)), (((UInt32(84)&127)..(UInt32(241)&127):(91|1)) as Enum757));
    @echo let var2420 : Range<UInt16> = ((UInt16(16)&127)..(UInt16(35)&127):(116|1));
    @echo var var2457 : ?Bool = ((Float32(Float32(Float32(-35.0))), UInt16(UInt8(129)), (), 'p', Int8(UInt8(UInt8(2))), UInt8(UInt8(Int8(-31)))) as Bool);
    (match (try { // block id: 2209
            @echo var var2213 : Int64 = Int64(Int16(Int16(58)));
            var66 %= ((var2213) | 1);
            var2218
        } finally { // block id: 2224
            ();
            var66
        }) {
        case -76 => 
            @echo var var2253 : Range<UInt16> = ((UInt16(61)&127)..=(UInt16(186)&127):((-74)|1));
            if (true) { var2233 } else { (((UInt64(157)&127)..(UInt64(55)&127):((-51)|1)), (-81), var2253, var425, 13.0, (), var400) } ;
            var917;
            if (var1280) { var353 } else { var353 } 
        
        case -113 | 98 | -105 | -36 => 
            if (true) { ((9&127)..=((-30)&127):((-60)|1)) } else { (((-23)&127)..=(24&127):((-104)|1)) } ;
            UInt16(240);
            Result<UInt32>.Err(Exception("LangFuzz Inner Exception"))
        
        case caseVar2275 => 
            Result<UInt32>.Ok(var2201)
        
        case _ => 
            var353
        
    } ?? match (match ([var917, UInt16(23), var917, var917, UInt16(132), UInt16(75), UInt16(215), UInt16(238), UInt16(184), var917]) {
            case caseVar2297 : Range<Int64> => 
                ();
                var2201;
                if (true) { var2304 } else { var2304 } 
            
            case _ => 
                Int16(-37) >> ((Int16(-113)) & 7);
                var66 /= ((78) | 1);
                @echo let var2428 : Array<UInt16> = [UInt16(131), UInt16(231), UInt16(132), UInt16(154), UInt16(29), UInt16(254), UInt16(22), UInt16(88), UInt16(153), UInt16(211)];
                ((var66, 121, var2392, var917, false, var2402, var561), var1747, (((UInt64(26)&127)..=(var963&127):((34|1))), 33, var2420, (), var400, (), (-84.0)), (var2428, var2201, var2392, Float32(-92.0), var2201, var1248), Option<Enum757>.Some(var935))
            
        }) {
        case ((-71,-101,_ : Int64,_,false | true | false | false,_ : Option<Bool>,8 | -96 | 78 | 126),'J' | 'g',caseVar2439,_,_) => 
            Option<(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)>.None;
            if (false) { var361 } else { var361 } ;
            var2201
        
        case (_ : Int64,caseVar2449,(_ : (Int32*UInt8*UInt64*Range<Int8>*Array<Result<Unit>>*UInt8*Unit),92 | -125,caseVar2450,_ : UInt16,caseVar2451 : Array<UInt16>,_,_ : Array<Array<Bool>>),(caseVar2452 : Result<Range<Int8>>,11 | 2 | 97 | 45,caseVar2453 : Array<Bool>,caseVar2454,186,44 | 8 | 212 | 57),_ : Float64) => 
            var2457;
            var361;
            var2201 * var2201
        
        case caseVar2479 : Aggregate332 => 
            ();
            var2201 % ((UInt32(172)) | 1)
        
        case _ : Array<UInt16> => 
            UInt32(138)
        
        case _ => 
            UInt32(226)
        
    })
}

@echo func func2131(param2132 : Bool) : Enum757 { // block id: 2133
    var227;
    @echo var var2494 : Result<Range<Int8>> = Result<Range<Int8>>.Err(Exception("LangFuzz Inner Exception"));
    match ((var2494|>func2138) >> ((UInt32(Int16(83))) & 7)) {
        case _ => 
            Enum757.enumValue2501(var1939, UInt8(168))
        
    }
}



@echo public func func1701(param1702 : (Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))) : Array<Bool> { // block id: 1703
    @echo var var1977 : (Float64) -> (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = { lambdaParameter1980 : Float64 => (((UInt64(37)&127)..(UInt64(45)&127):((58|1))), Int64(Int64(UInt64(195))), ((UInt16(3)&127)..=(UInt16(128)&127):(9|1)), (), 69.0, (), 37.0) };
    @echo var var2013 : UInt32 = UInt32(79);
    (try { // block id: 1996
        @echo var var1999 : Int8 = Int8(Int8(-31));
        var1999 >>= ((var2003) & 7);
        var400 - 85.0
    } catch (_) { // block id: 2009
        true;
        var2013 -= UInt32(246);
        var400
    } finally { // block id: 2017
        var1303;
        var400
    }|>var1977)[3];
    @echo let var2510 : Bool = true;
    @echo func func2023(namedParam2024 ! : ((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>), namedParam2025 ! : (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8), namedParam2026 ! : (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)) : Bool { // block id: 2027
        @echo let var2123 : (Enum757) -> UInt16 = { lambdaParameter2126 : Enum757 => UInt16(Int8(UInt8(184))) };
        @echo let var2507 : (Bool) -> Enum757 = func2131;
        (var2510|>(var2507~>var2123)) ** (var917 & 3);
        @echo let var2534 : Bool = true;
        @echo let var2540 : Bool = true;
        (match {
            case if (var207) { // block id: 2517
            if (var207) { var935 } else { var935 } ;
            var1492;
            var2510
        } else if (false) { // block id: 2525
            var300;
            !var207
        } else { // block id: 2529
            var425;
            [var207, var2534, var1280, var1280, true, var2540, true, var2534, var2510, var207];
            var1280 || var1280
        } => 
            var1307;
            var1277 ^= Int32(87);
            (((UInt64(128)&127)..(var1057&127):((0|1))), Int16(78), UInt32(97), var1277, var572)
            case _ => 
            (((UInt64(52)&127)..=(UInt64(84)&127):(54|1)), var870, UInt32(158), Int32(-19), (var2571, UInt16(212), var425, '7', Int8(55), var1248))
        } is (Int32*UInt8*UInt64*Range<Int8>*Array<Result<Unit>>*UInt8*Unit))
    }
;
    @echo let var2582 : ((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>) = ((57, 13, ((UInt8(218)&127)..=(UInt8(151)&127):(97|1)), UInt16(UInt8(173)), (Result<Result<Range<UInt32>>>.Ok(Result<Range<UInt32>>.Err(Exception("LangFuzz Inner Exception"))) is ((Float32*UInt16*Unit*Rune*Int8*UInt8), Range<UInt16>, (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)) -> (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)), ((Int16(Int8(-1))&127)..(Int16(-18)&127):((Int64(UInt16(229))|1))), Int32(-62)), 'k', (((UInt64(248)&127)..=(UInt64(10)&127):(57|1)), (-13), ((UInt16(152)&127)..(UInt16(253)&127):(125|1)), (), Float64(Float64((-66.0))), (), (-49.0)), ([UInt16(196), UInt16(65), UInt16(73), UInt16(3), UInt16(242), UInt16(134), UInt16(208), UInt16(80), UInt16(205), UInt16(43)], UInt32(69), ((UInt8(UInt8(35))&127)..=(UInt8(177)&127):((Int64(UInt8(191))|1))), Float32(Float32(Float32(-3.0))), UInt32(Int16(UInt16(82))), UInt8(156)), Option<Enum757>.None);
    @echo let var2745 : Rune = 'Y';
    @echo var var2795 : Array<UInt16> = [UInt16(32), UInt16(248), UInt16(244), UInt16(158), UInt16(44), UInt16(75), UInt16(25), UInt16(165), UInt16(123), UInt16(101)];
    @echo var var2837 : ?(Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32) = (Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception")) as (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32));
    @echo let var2862 : UInt16 = UInt16(Int8(-15));
    @echo let var2888 : Result<Range<UInt32>> = Result<Range<UInt32>>.Ok(((UInt32(UInt32(220))&127)..(UInt32(109)&127):((44|1))));
    [func2023(namedParam2024 : if (true) { // block id: 2580
        var2582
    } else if (true) { // block id: 2629
        @echo var var2633 : ((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>) = ((Int64(Int32(26)), Int64(UInt64(78)), ((UInt8(129)&127)..=(UInt8(122)&127):(23|1)), UInt16(UInt16(156)), false, ((Int16(99)&127)..=(Int16(-96)&127):(((-94)|1))), Int32(Int32(Int8(-80)))), 'm', (((UInt64(229)&127)..=(UInt64(152)&127):((Int64(UInt16(111))|1))), (-29), ((UInt16(40)&127)..(UInt16(15)&127):(((-58)|1))), (), (-120.0), (), Float64(1.0)), ([UInt16(102), UInt16(6), UInt16(166), UInt16(93), UInt16(38), UInt16(156), UInt16(161), UInt16(219), UInt16(136), UInt16(244)], UInt32(16), ((UInt8(248)&127)..=(UInt8(4)&127):(115|1)), Float32(-25.0), UInt32(Int16(50)), UInt8(215)), Option<Enum757>.None);
        @echo var var2682 : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = (((UInt64(66)&127)..(UInt64(UInt64(Int8(-29)))&127):(((-3)|1))), Int64(Int16(Int8(Int8(-16)))), ((UInt16(203)&127)..=(UInt16(200)&127):(116|1)), (), Float64(Float64(Float32(Float32(-61.0)))), (), 116.0);
        if (var207) { var2633 } else { (var259, '8', var2682, ([UInt16(239), UInt16(240), UInt16(220), UInt16(206), UInt16(231), UInt16(198), UInt16(56), UInt16(171), UInt16(177), UInt16(243)], UInt32(163), ((var1248&127)..(var1248&127):((var66|1))), var300, UInt32(213), UInt8(240)), Option<Enum757>.None) } 
    } else { // block id: 2713
        Int32(100);
        ();
        @echo var var2748 : (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = (((UInt64(Int32(-78))&127)..(UInt64(UInt32(21))&127):((120|1))), Int64(UInt8(75)), ((UInt16(200)&127)..=(UInt16(238)&127):(41|1)), (), Float64(Float32(40.0)), (), 105.0);
        if (var2510) { ((var66, var66, ((var1248&127)..=(var1248&127):((16|1))), UInt16(173), var1280, ((Int16(45)&127)..(Int16(79)&127):((-8)|1)), var561), var1747, (((UInt64(74)&127)..(UInt64(3)&127):(22|1)), var66, ((UInt16(233)&127)..=(UInt16(69)&127):(103|1)), var425, (-33.0), (), var400), var1766, Option<Enum757>.Some(var935)) } else { (var259, var2745, var2748, var1766, Option<Enum757>.Some(var935)) } 
    }, namedParam2025 : try { // block id: 2768
        if (false) { ([var917, UInt16(149), UInt16(16), UInt16(218), UInt16(152), var917, var2780, UInt16(78), var2780, UInt16(110)], var2013, ((UInt8(57)&127)..(UInt8(176)&127):(((-29)|1))), Float32(35.0), var2013, UInt8(241)) } else { (var2795, UInt32(86), ((UInt8(46)&127)..=(UInt8(16)&127):((-53)|1)), Float32(-81.0), UInt32(185), UInt8(124)) } 
    } finally { // block id: 2802
        ();
        @echo let var2808 : Unit = ();
        @echo var var2813 : UInt8 = UInt8(Int8(UInt8(Int8(UInt8(200)))));
        (Float32(-110.0), var2780, var2808, 'Q', Int8(116), var2813);
        ([UInt16(181), UInt16(16), UInt16(1), UInt16(1), UInt16(46), UInt16(252), UInt16(149), UInt16(239), UInt16(118), UInt16(43)], UInt32(113), ((var1248&127)..=(UInt8(247)&127):((var2826|1))), Float32(35.0), var2013, var2813)
    }, namedParam2026 : (var2837 ?? (var66, (-56), var2392, UInt16(230), var2510, var2402, var1277))), match (match (((var300, var2780, (), var2745, var2003, var1248), ((Int32(64)&127)..(Int32(68)&127):((-125)|1)), (var300, var2862, (), '5', Int8(-23), var1248), Int8(-1))) {
            case ((115.0,_ : (Float64*Range<Int32>*(Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))*Enum757*Array<UInt16>*UInt64*Range<Int8>),() | () | (),'0' | 'd',_ : Int32,_),_ : ((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>),_,-3) => 
                var1303;
                @echo var var2875 : Result<Range<UInt32>> = Result<Range<UInt32>>.Ok(((UInt32(Int16(Int8(-41)))&127)..(UInt32(UInt8(Int8(47)))&127):((103|1))));
                var2875
            
            case _ => 
                var2888
            
        }) {
        case _ => 
            ();
            true
        
    }, (var2901 is (Float64*Range<Int32>*(Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))*Enum757*Array<UInt16>*UInt64*Range<Int8>)), try { // block id: 2905
        [false, true, var1280, true, false, var1280, false, var1280, var2510, false]
    } catch (_) { // block id: 2917
        var870;
        var425;
        @echo let var2929 : Bool = false;
        [var1280, var1280, true, var2510, var2510, true, false, var2929, var207, false]
    } finally { // block id: 2933
        @echo let var2935 : Array<Bool> = [(Enum757.enumValue783(((UInt16(251)&127)..=(UInt16(56)&127):((44|1))), Class15(), Result<String>.Ok("hy\"(.Hon\"z"), ((UInt16(44)&127)..(UInt16(13)&127):((81|1)))) is Int32), (Aggregate332('L', ((Int16(109)&127)..(Int16(-87)&127):(100|1))) is (Float64*Range<Int32>*(Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))*Enum757*Array<UInt16>*UInt64*Range<Int8>)), false, (((58&127)..((-105)&127):(110|1)) is Result<Result<Range<UInt32>>>), ((Float32(Float32(2.0)), UInt16(Int16(-31)), (), 'w', Int8(86), UInt8(129)) is Result<Range<Int8>>), (((UInt16(196)&127)..(UInt16(146)&127):((Int64(Int16(90))|1))) is (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)), ([Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception"))] is Class15), true, (Class15([(), (), (), (), (), (), (), (), (), ()], namedParam3015 : Result<String>.Ok(###"a{WG?0T%.,p"###), optionalParam3016 : Enum757.enumValue2501(((([UInt16(39), UInt16(84), UInt16(160), UInt16(131), UInt16(118), UInt16(65), UInt16(32), UInt16(245), UInt16(11), UInt16(116)], UInt32(134), ((UInt8(15)&127)..(UInt8(137)&127):((-120)|1)), Float32(35.0), UInt32(217), UInt8(48)), UInt32(152), Int8(-58), Int8(65)), ((Int16(70)&127)..(Int16(-57)&127):((28|1))), (-86), ((UInt8(51)&127)..(UInt8(110)&127):((-38)|1)), UInt16(253)), UInt8(249))) is Option<(Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)>), true];
        var2935
    }[3], try { // block id: 3293
        var1057 > var1057
    } catch (e: Exception) { // block id: 3297
        var2510
    } finally { // block id: 3299
        ((var1277&127)..(Int32(-96)&127):((72|1)));
        (-8.0) == 31.0
    }, (var572 is (Enum757) -> UInt16), true, UInt64(var1228) != [UInt64(166), UInt64(136), UInt64(172), UInt64(52), UInt64(219), UInt64(104), UInt64(24), UInt64(68), UInt64(160), UInt64(20)][5], true, match ((Result<Range<UInt8>>.Err(Exception("LangFuzz Inner Exception")) ?? ((UInt8(104)&127)..(UInt8(60)&127):((-75)|1)))) {
        case _ => 
            ();
            false
        
    }]
}

@echo public func func1438(param1439 : (Array<Bool>) -> Unit) : Range<Int8> { // block id: 1442
    @echo let var1505 : Range<UInt8> = ((UInt8(122)&127)..(UInt8(60)&127):(111|1));
    @echo let var1508 : (Int32*UInt8*UInt64*Range<Int8>*Array<Result<Unit>>*UInt8*Unit) = (Int32(-30), UInt8(UInt8(Int8(UInt8(90)))), UInt64(151), ((Int8(72)&127)..(Int8(-103)&127):((-66)|1)), [Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(())], UInt8(59), ());
    @echo let var1586 : UInt16 = UInt16(Int8(Int8(UInt8(UInt8(67)))));
    @echo let var1602 : Array<Result<Unit>> = Array<Result<Unit>>(10){ i => Result<Unit>.Ok(()) };
    @echo func func1447(namedParam1448 ! : Range<Int64>, namedParam1449 ! : Result<UInt32>, optionalParam1450 ! : Aggregate332 = Aggregate332('d', ((Int16(UInt16(167))&127)..=(Int16(86)&127):(((-125)|1)))), optionalParam1458 ! : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) = ((Float32(Float32(Float32(-63.0))), UInt16(228), (), '6', Int8(Int8(UInt8(134))), UInt8(192)), ((Int32(121)&127)..(Int32(Int8(25))&127):((Int64((-2))|1))), (Float32(Float32(Float32(30.0))), UInt16(UInt8(227)), (), 'f', Int8(59), UInt8(Int8(-58))), Int8(-10))) : Array<Result<Unit>> { // block id: 1489
        var1492[7];
        @echo var var1571 : Array<UInt16> = [UInt16(2), UInt16(96), UInt16(251), UInt16(194), UInt16(65), UInt16(237), UInt16(184), UInt16(32), UInt16(200), UInt16(136)];
        @echo let var1580 : UInt16 = UInt16(UInt16(226));
        @echo let var1670 : Result<Unit> = Result<Unit>.Err(Exception("LangFuzz Inner Exception"));
        match (var353) {
            case caseVar1501 : Option<Enum757> => 
                var654;
                var1505;
                var1508
            
            case caseVar1538 => 
                var66 += var66;
                @echo let var1550 : Result<Unit> = Result<Unit>.Err(Exception("LangFuzz Inner Exception"));
                (var561, UInt8(67), var963, ((Int8(21)&127)..(Int8(16)&127):(29|1)), [var1550, var1550, Result<Unit>.Err(Exception("LangFuzz Inner Exception")), var1550, Result<Unit>.Ok(var425), var1550, Result<Unit>.Ok(()), var1550, var1550, Result<Unit>.Err(Exception("LangFuzz Inner Exception"))], UInt8(135), ())
            
            case _ : Range<UInt64> => 
                if (var207) { var1571 } else { [UInt16(159), UInt16(9), var917, var917, UInt16(105), var1580, UInt16(156), UInt16(197), var1586, UInt16(90)] } ;
                (Int32(31), UInt8(253), var963, ((var1228&127)..(var1228&127):((var66|1))), var1602, var1248, var1307)
            
            case _ : Range<UInt64> => 
                @echo let var1628 : UInt32 = UInt32(193);
                UInt32(86) & var1628;
                if (var1280) { (Int32(-106), var1248, UInt64(16), ((var1228&127)..(var1228&127):((var66|1))), [Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), var1645, var1645, var1645, Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), var1645, Result<Unit>.Ok(var1303)], UInt8(116), ()) } else { var1508 } 
            
            case _ => 
                (var1277, UInt8(89), UInt64(229), ((Int8(-30)&127)..=(Int8(-124)&127):((-47)|1)), [Result<Unit>.Err(Exception("LangFuzz Inner Exception")), var1670, var1670, var1645, Result<Unit>.Ok(()), var1645, Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), Result<Unit>.Ok(var1307), Result<Unit>.Err(Exception("LangFuzz Inner Exception"))], UInt8(76), ())
            
        }[4]
    }
;
    @echo let var3331 : ((Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))) -> Array<Bool> = func1701;
    @echo let var3347 : Int8 = Int8(UInt8(UInt8(UInt8(UInt8(159)))));
    (func1447(namedParam1448 : (((-70)&127)..=((-60)&127):(71|1)), namedParam1449 : Result<UInt32>.Err(Exception("LangFuzz Inner Exception")), optionalParam1458 : (var572, var1691, var572, Int8(11)))[3] ?? func735(((((UInt64(146)&127)..(UInt64(59)&127):((var2826|1))), Int16(-109), UInt32(70), var1277, (var2571, UInt16(254), (), var1747, var3347, UInt8(233)))|>var3331)));
    ((Int8(24)&127)..(Int8(19)&127):((-121)|1))
}

@echo public func func3358(param736 : Array<Bool>) : Unit { // block id: 737

}


@echo public func func1219(param1220 : Result<Option<Result<String>>>) : Bool { // block id: 1221
    @echo var var1266 : UInt32 = UInt32(Int32(UInt8(66)));
    @echo let var1289 : Result<Array<UInt16>> = Result<Array<UInt16>>.Ok([UInt16(156), UInt16(244), UInt16(34), UInt16(64), UInt16(133), UInt16(48), UInt16(168), UInt16(119), UInt16(50), UInt16(254)]);
    @echo var var1326 : Range<Int8> = ((Int8(-72)&127)..=(Int8(-46)&127):((-27)|1));
    @echo var var1332 : Bool = (Int32(UInt16(Int16(Int8(36)))) is Option<Bool>);
    @echo let var3361 : (Array<Bool>) -> Unit = func3358;
    if (match (match (((Int8(-86)&127)..(var1228&127):((var66|1)))) {
            case _ => 
                var561 * Int32(-22);
                @echo var var1240 : ?Bool = Option<Bool>.None;
                var1240
            
        }) {
        case _ => 
            Option<Enum757>.None;
            var1248 %= ((var1248) | 1);
            var207
        
        case _ : (Float64*Range<Int32>*(Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))*Enum757*Array<UInt16>*UInt64*Range<Int8>) => 
            Int8(16) & var1228;
            var207
        
        case caseVar1262 => 
            var1266 >>= ((UInt32(138)) & 7);
            Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception"));
            var207
        
        case _ => 
            var1277--;
            var1280
        
    }) { // block id: 1282
        (var1289 ?? [UInt16(50), UInt16(50), UInt16(246), UInt16(72), UInt16(46), UInt16(51), UInt16(8), UInt16(143), UInt16(164), UInt16(136)]);
        [var425, (), (), var425, var227, (), var425, var1303, (), var1307][7];
        (Result<UInt32>.Ok(var1266) ?? var1266)
    } else if (match ((Result<Range<Int8>>.Ok(((Int8(8)&127)..=(Int8(-117)&127):((var66|1)))) ?? var1326)) {
        case _ => 
            if (var1332) { var1339 } else { var1339 } ;
            var66 *= 39;
            false
        
    }) { // block id: 1386
        match (Enum757.enumValue838([var1303, (), (), (), (), var425, (), (), (), var227])) {
            case enumValue838(caseVar1402 : Array<Unit>) => 
                Int32(29) % ((Int32(-6)) | 1)
            
            case _ => 
                if (false) { var1412 } else { Class15() } ;
                Int32(-98) & Int32(82)
            
        };
        if (var1280) { // block id: 1420
            var870 *= Int16(-27);
            ()
        };
        @echo var var1429 : Unit = ();
        if (true) { // block id: 1427
            var1429;
            UInt32(198) ^ var1266
        } else { // block id: 1434
            UInt32(62)
        }
    } else { // block id: 1436
        @echo var var3356 : ((Array<Bool>) -> Unit) -> Range<Int8> = func1438;
        var3361|>var3356;
        UInt32(246) & UInt32(55)
    };
    @echo var var3375 : Range<Int64> = ((Int64(UInt64(Int32(UInt32(193))))&127)..((-3)&127):((Int64(Int16(-102))|1)));
    @echo var var3407 : Unit = ();
    @echo let var3424 : Float32 = Float32(Float32(Float32(Float32(118.0))));
    @echo var var3481 : UInt8 = UInt8(210);
    ((Option<Result<Unit>>.None ?? match (var3375) {
        case caseVar3386 => 
            var3389;
            var1645
        
        case caseVar3404 : ((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8) => 
            var3407;
            if (true) { var2402 } else { var2402 } ;
            Result<Unit>.Ok(var425)
        
        case _ => 
            Result<Unit>.Ok(var227)
        
    }) ?? try { // block id: 3420
        var2571 /= Float32((Int32(var3424)) | 1);
        if (true) { var3432 } else { [((UInt64(164)&127)..=(UInt64(87)&127):(81|1)), ((UInt64(175)&127)..=(UInt64(153)&127):((-16)|1)), ((UInt64(207)&127)..(UInt64(179)&127):(86|1)), ((UInt64(249)&127)..=(UInt64(218)&127):((-98)|1)), ((UInt64(231)&127)..=(UInt64(83)&127):((-29)|1)), ((UInt64(39)&127)..=(UInt64(126)&127):((-100)|1)), ((UInt64(22)&127)..=(UInt64(198)&127):((-21)|1)), ((UInt64(49)&127)..=(UInt64(232)&127):((-79)|1)), ((UInt64(52)&127)..(UInt64(197)&127):(22|1)), ((UInt64(41)&127)..=(UInt64(138)&127):((-64)|1))] } ;
        var3407
    } catch (_) { // block id: 3473
        param1220;
        ()
    } finally { // block id: 3476
        var1057--;
        var3481 ^= UInt8(206)
    });
    @echo let var3493 : ?(Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32) = ([((UInt16(217)&127)..(UInt16(177)&127):(0|1)), ((UInt16(165)&127)..(UInt16(190)&127):(100|1)), ((UInt16(248)&127)..=(UInt16(37)&127):(5|1)), ((UInt16(249)&127)..=(UInt16(228)&127):((-19)|1)), ((UInt16(169)&127)..=(UInt16(220)&127):(71|1)), ((UInt16(189)&127)..=(UInt16(177)&127):((-27)|1)), ((UInt16(202)&127)..(UInt16(198)&127):(107|1)), ((UInt16(7)&127)..(UInt16(11)&127):(38|1)), ((UInt16(101)&127)..=(UInt16(227)&127):(98|1)), ((UInt16(111)&127)..(UInt16(77)&127):((-53)|1))] as (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32));
    match (if ((var3488 ?? var1280)) { Option<(Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)>.None } else { var3493 } ) {
        case _ => 
            var3375;
            var1332 ||= var207;
            !false
        
    }
}

@echo func func1214(param1215 : (Float64*Range<Int32>*(Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))*Enum757*Array<UInt16>*UInt64*Range<Int8>)) : Option<Enum757> { // block id: 1216
    @echo var var3505 : (Result<Option<Result<String>>>) -> Bool = func1219;
    @echo let var3508 : Result<Option<Result<String>>> = Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception"));
    @echo var loopTimeVar3512 : Int64 = 0;
    do {
        loopTimeVar3512++;

    } while (((var3508|>var3505)) && loopTimeVar3512 < 100 ) ;
    !(var3488 ?? if (var1280) { // block id: 3518
        ();
        ();
        var1280
    } else if (var3523) { // block id: 3525
        ();
        ();
        var207
    } else { // block id: 3529
        var227;
        var3523
    });
    var3533
}

@echo func func977(param978 : UInt16) : Enum757 { // block id: 979
    @echo var var992 : Array<Bool> = [((Float64(Float32(-56.0)), ((Int32(36)&127)..=(Int32(30)&127):((-64)|1)), (((UInt64(7)&127)..=(UInt64(143)&127):(32|1)), Int16(-93), UInt32(189), Int32(-54), (Float32(-26.0), UInt16(136), (), 'y', Int8(22), UInt8(133))), Enum757.enumValue783(((UInt16(41)&127)..(UInt16(201)&127):((-112)|1)), Class15(), Result<String>.Ok("qut6k;wa{;+"), ((UInt16(146)&127)..(UInt16(86)&127):((-31)|1))), [UInt16(156), UInt16(39), UInt16(239), UInt16(201), UInt16(199), UInt16(85), UInt16(192), UInt16(104), UInt16(219), UInt16(174)], UInt64(UInt64(90)), ((Int8(91)&127)..(Int8(-78)&127):((-76)|1))) is Range<Int16>), (Enum757.enumValue783(((UInt16(184)&127)..=(UInt16(176)&127):(44|1)), Class15(), Result<String>.Err(Exception("LangFuzz Inner Exception")), ((UInt16(206)&127)..=(UInt16(214)&127):((-84)|1))) is Result<Option<Result<String>>>), false, (Class15(namedParam1041 : ((-127), 10, ((UInt8(162)&127)..=(UInt8(19)&127):(((-128)|1))), UInt16(203), true, ((Int16(22)&127)..(Int16(-87)&127):(((-100)|1))), Int32(-82)), optionalParam1042 : UInt32(163), namedParam1044 : ((Float32(-38.0), UInt16(217), (), '4', Int8(-106), UInt8(62)), ((Int32(-125)&127)..=(Int32(-56)&127):((-72)|1)), (Float32(71.0), UInt16(100), (), 'T', Int8(-106), UInt8(141)), Int8(99)), optionalParam1045 : Result<UInt32>.Ok(UInt32(207))) is Unit), false, false, (Option<Bool>.Some(false) is Float64), false, (Float64(Float32(63.0)) is Int16), false];
    try { // block id: 981
        @echo var loopTimeVar988 : Int64 = 0;
        while ((true) && loopTimeVar988 < 100 ) {
            loopTimeVar988++;
            var227;
            var917
        };
        if (var207) { var992 } else { [true, false, false, false, false, false, false, true, false, false] } 
    } catch (e: Exception) { // block id: 1117
        @echo var loopTimeVar1124 : Int64 = 0;
        do {
            loopTimeVar1124++;
            ();
            Enum757.defaultValue
        } while ((var207) && loopTimeVar1124 < 100 ) ;
        @echo var var1140 : Bool = (Class15(namedParam1041 : (Int64(UInt32(34)), (-36), ((UInt8(182)&127)..(UInt8(245)&127):(62|1)), UInt16(UInt8(235)), false, ((Int16(-104)&127)..(Int16(87)&127):((-42)|1)), Int32(-10)), namedParam1044 : ((Float32(-21.0), UInt16(18), (), 'u', Int8(8), UInt8(77)), ((Int32(-8)&127)..=(Int32(-91)&127):((24|1))), (Float32(-37.0), UInt16(214), (), 'o', Int8(3), UInt8(5)), Int8(116)), optionalParam1045 : Result<UInt32>.Ok(UInt32(172))) is (Int32) -> Enum757);
        [[true, false, false, true, false, false, true, true, true, true], [true, true, true, true, true, false, true, false, false, false], [var207, false, true, var207, var207, var207, true, var207, var1140, var207], [false, var1140, false, var207, var1140, var207, true, true, false, true], var992, var992, var992, [true, var1140, true, var207, var1140, var207, var207, true, false, true], var992, var992][1]
    };
    if (var992[0]) { ((var1339|>func1214) ?? Enum757.enumValue2501(var654, var1248)) } else { (Option<Enum757>.None ?? if (true) { var935 } else { var935 } ) } 
}

@echo public func func3550(param3551 : Int32) : UInt16 { // block id: 3552
    @echo var var3580 : Float32 = Float32(109.0);
    if (var1280) { ((((var1057&127)..(UInt64(116)&127):((95|1))) as (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)) ?? if (true) { ((([var917, UInt16(101), UInt16(231), var917, var917, UInt16(249), UInt16(62), var917, var917, UInt16(213)], UInt32(157), var2392, var3580, UInt32(73), var3584), UInt32(221), Int8(38), Int8(-95)), ((Int16(-45)&127)..=(Int16(-12)&127):((-86)|1)), (-82), ((var1248&127)..=(UInt8(67)&127):((var66|1))), UInt16(92)) } else { (var361, var2402, 94, ((var1248&127)..=(var3584&127):((var66|1))), UInt16(33)) } ) } else { match (try { // block id: 3608
            var20
        } finally { // block id: 3610
            if (var207) { var725 } else { Class15() } 
        }) {
        case _ => 
            Class15();
            var654
        
        case caseVar3622 : Option<(Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)> => 
            @echo var var3676 : UInt16 = UInt16(Int16(Int16(Int8(Int8(111)))));
            if (var207) { ((var3629, var3665, var2003, Int8(123)), ((Int16(-108)&127)..(Int16(99)&127):((-110)|1)), (-59), ((UInt8(196)&127)..=(UInt8(41)&127):((-103)|1)), var3676) } else { var1939 } 
        
        case _ => 
            if (var207) { [false, true, true, true, true, false, false, false, true, false] } else { [true, false, false, false, false, false, true, false, true, false] } ;
            @echo let var3692 : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) = ((Float32(-119.0), UInt16(152), (), 'M', Int8(UInt8(Int8(-29))), UInt8(Int8(Int8(-64)))), ((Int32(-116)&127)..(Int32(-111)&127):(98|1)), (Float32(Float32(Float32(-127.0))), UInt16(167), (), 'l', Int8(UInt8(Int8(-104))), UInt8(149)), Int8(Int8(UInt8(218))));
            if (var207) { var3692 } else { (var572, var1691, (var2571, UInt16(164), (), 'd', Int8(-24), var1248), Int8(95)) } ;
            if (false) { (var361, ((var870&127)..=(Int16(-72)&127):((var2826|1))), var66, var2392, var917) } else { ((([UInt16(91), UInt16(133), UInt16(204), UInt16(77), UInt16(160), UInt16(167), UInt16(34), UInt16(131), UInt16(96), UInt16(50)], var3665, ((UInt8(108)&127)..(UInt8(134)&127):((-108)|1)), Float32(123.0), var3665, var1248), var3665, Int8(108), Int8(-27)), var2402, 18, var2392, var917) } 
        
    } } ;
    UInt16(107)
}




@echo func func753(param754 : UInt8) : Result<Option<Result<String>>> { // block id: 755
    @echo var var3548 : (UInt16) -> Enum757 = func977;
    @echo var var3762 : (Int32*UInt8*UInt64*Range<Int8>*Array<Result<Unit>>*UInt8*Unit) = (Int32(104), UInt8(111), UInt64(UInt32(165)), ((Int8(76)&127)..(Int8(-35)&127):((Int64(UInt64(Int16(-99)))|1))), [Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(())], UInt8(UInt8(214)), ());
    match ((match (var3762) {
            case caseVar3797 => 
                -Int32(84)
            
            case (-61 | -44,177,_,_ : Array<Result<Unit>>,caseVar3803,233,caseVar3804 : Result<Array<UInt16>>) => 
                var1303;
                ();
                -var1277
            
            case _ => 
                var561
            
        }|>(func3550~>var3548))) {
        case enumValue2501(_ : Option<(Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)>, _) => 
            if (true) { Class15() } else { var1412 } 
        
        case _ => 
            var1280 &&= true;
            if (false) { var792 } else { var792 } ;
            if (false) { Class15() } else { Class15() } 
        
    };
    @echo let var3849 : ??Result<Result<Option<Result<String>>>> = (Option<Enum757>.None as Option<Result<Result<Option<Result<String>>>>>);
    @echo let var3863 : ?(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64) = Option<(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)>.None;
    @echo var var3897 : Result<Option<Result<String>>> = Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception"));
    (((var3849 ?? Option<Result<Result<Option<Result<String>>>>>.Some(Result<Result<Option<Result<String>>>>.Ok(var3855))) ?? match (var2826) {
        case 59 | -103 => 
            var3863;
            ();
            @echo let var3872 : ?Result<String> = (UInt32(108) as Result<String>);
            if (false) { Result<Result<Option<Result<String>>>>.Err(Exception("LangFuzz Inner Exception")) } else { Result<Result<Option<Result<String>>>>.Ok(Result<Option<Result<String>>>.Ok(var3872)) } 
        
        case 22 | 79 | 107 | -106 => 
            [var917, UInt16(49), UInt16(159), UInt16(175), UInt16(98), var917, var917, var2780, UInt16(54), UInt16(175)];
            var1248;
            if (var1280) { var3893 } else { Result<Result<Option<Result<String>>>>.Ok(var3897) } 
        
        case -69 | 123 | -63 | 33 => 
            Result<Result<Option<Result<String>>>>.Ok(Result<Option<Result<String>>>.Ok(Option<Result<String>>.None))
        
        case -67 | -95 | -109 | -69 => 
            @echo var var3910 : Bool = ([[(Option<Option<Result<Result<Option<Result<String>>>>>>.None is ((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>)), true, ([false, true, true, false, true, false, false, true, true, false] is (Float32*UInt16*Unit*Rune*Int8*UInt8)), true, (Result<Range<UInt32>>.Err(Exception("LangFuzz Inner Exception")) is (((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>), (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8), (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)) -> Bool), false, ([(), (), (), (), (), (), (), (), (), ()] is (UInt64) -> Enum757), (Result<String>.Ok(###"|2l9q`,F.v"###) is (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)), (Result<Range<UInt32>>.Ok(((UInt32(125)&127)..(UInt32(177)&127):(((-90)|1)))) is Int64), ('L' is (Result<Range<Int8>>) -> UInt32)], [(((UInt32(229)&127)..(UInt32(185)&127):((-112)|1)) is (Float64*Range<Int32>*(Range<UInt64>*Int16*UInt32*Int32*(Float32*UInt16*Unit*Rune*Int8*UInt8))*Enum757*Array<UInt16>*UInt64*Range<Int8>)), true, ((Int32(31), UInt8(157), UInt64(219), ((Int8(-109)&127)..(Int8(15)&127):((-32)|1)), [Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Ok(()), Result<Unit>.Err(Exception("LangFuzz Inner Exception")), Result<Unit>.Err(Exception("LangFuzz Inner Exception"))], UInt8(82), ()) is Result<Result<Option<Result<String>>>>), true, true, false, (Option<Bool>.None is (Float32*UInt16*Unit*Rune*Int8*UInt8)), (UInt16(16) is Float64), true, false], [true, (([UInt16(172), UInt16(168), UInt16(81), UInt16(53), UInt16(30), UInt16(186), UInt16(110), UInt16(171), UInt16(155), UInt16(54)], UInt32(62), ((UInt8(193)&127)..=(UInt8(170)&127):(53|1)), Float32(0.0), UInt32(209), UInt8(122)) is Int8), (UInt8(69) is Array<Range<UInt16>>), ([((UInt64(35)&127)..(UInt64(16)&127):(((-98)|1))), ((UInt64(25)&127)..(UInt64(254)&127):((23|1))), ((UInt64(147)&127)..(UInt64(179)&127):(((-90)|1))), ((UInt64(178)&127)..=(UInt64(129)&127):((30|1))), ((UInt64(220)&127)..=(UInt64(187)&127):((-18)|1)), ((UInt64(159)&127)..(UInt64(150)&127):(((-35)|1))), ((UInt64(115)&127)..=(UInt64(176)&127):((-22)|1)), ((UInt64(120)&127)..(UInt64(164)&127):(79|1)), ((UInt64(3)&127)..=(UInt64(179)&127):(((-83)|1))), ((UInt64(202)&127)..=(UInt64(143)&127):((-101)|1))] is Option<(Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)>), false, (Option<Result<String>>.None is ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8)), true, false, ((((-52)&127)..=(124&127):(((-42)|1))) is ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8)), false], [true, (Result<Result<Range<UInt32>>>.Err(Exception("LangFuzz Inner Exception")) is (((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>), (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8), (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)) -> Bool), false, (Int8(-96) is (Range<Int64>, Result<UInt32>, Aggregate332, ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8)) -> Array<Result<Unit>>), false, true, false, (Int16(98) is Result<Range<UInt32>>), ([[true, true, true, true, false, false, true, true, false, false], [true, true, false, true, false, true, true, true, false, false], [true, true, true, false, false, false, true, true, true, true], [true, false, false, false, true, false, true, true, false, false], [true, true, true, true, true, false, true, false, false, true], [true, true, false, false, false, true, true, false, false, true], [true, true, true, true, false, false, true, false, true, false], [false, true, true, false, true, false, false, true, false, false], [false, false, true, true, false, true, true, false, false, false], [true, true, true, false, false, false, true, true, true, false]] is (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)), true], [false, false, true, true, true, true, true, false, false, true], [false, true, true, false, false, true, true, false, false, true], [true, false, false, false, true, false, true, false, true, true], [false, true, true, false, true, false, true, true, false, true], [false, (Result<Array<UInt16>>.Err(Exception("LangFuzz Inner Exception")) is (UInt16) -> Enum757), (Int16(-11) is ((Float32*UInt16*Unit*Rune*Int8*UInt8), Range<UInt16>, (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)) -> (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)), (Option<Result<Result<Option<Result<String>>>>>.Some(Result<Result<Option<Result<String>>>>.Err(Exception("LangFuzz Inner Exception"))) is (Int32*UInt8*UInt64*Range<Int8>*Array<Result<Unit>>*UInt8*Unit)), false, ((Float32(75.0), UInt16(38), (), '7', Int8(-36), UInt8(106)) is Array<UInt16>), true, (UInt32(223) is Option<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)>), ([UInt16(54), UInt16(50), UInt16(238), UInt16(219), UInt16(186), UInt16(114), UInt16(163), UInt16(33), UInt16(125), UInt16(69)] is (Array<Bool>) -> Unit), false], [(Result<Result<Range<UInt32>>>.Err(Exception("LangFuzz Inner Exception")) is Array<Range<UInt64>>), true, true, (((UInt32(183)&127)..=(UInt32(142)&127):(((-76)|1))) is (Float64) -> Range<UInt32>), ([((UInt16(60)&127)..(UInt16(36)&127):(32|1)), ((UInt16(132)&127)..=(UInt16(203)&127):((-72)|1)), ((UInt16(224)&127)..=(UInt16(217)&127):(92|1)), ((UInt16(100)&127)..(UInt16(161)&127):((-29)|1)), ((UInt16(7)&127)..=(UInt16(213)&127):(60|1)), ((UInt16(244)&127)..=(UInt16(67)&127):((-39)|1)), ((UInt16(185)&127)..=(UInt16(169)&127):((-72)|1)), ((UInt16(81)&127)..=(UInt16(170)&127):((-124)|1)), ((UInt16(248)&127)..(UInt16(118)&127):((-38)|1)), ((UInt16(208)&127)..=(UInt16(67)&127):((-19)|1))] is (Float64, UInt64, Array<Bool>) -> UInt64), (UInt16(24) is (Result<Option<Result<String>>>) -> Bool), (Enum757.defaultValue is Result<Result<Option<Result<String>>>>), (((UInt32(13)&127)..(UInt32(139)&127):((7|1))) is Interface18), false, ((Float32(45.0), UInt16(64), (), 'g', Int8(-85), UInt8(148)) is (Array<Bool>) -> Unit)]] is Enum757);
            if (var3910) { Result<Result<Option<Result<String>>>>.Ok(var3855) } else { Result<Result<Option<Result<String>>>>.Ok(var3897) } 
        
        case _ => 
            var3893
        
    }) ?? try { // block id: 4178
        ();
        @echo var var4184 : Range<UInt32> = ((UInt32(227)&127)..=(UInt32(140)&127):(73|1));
        if (false) { Result<Range<UInt32>>.Ok(var4184) } else { Result<Range<UInt32>>.Ok(var4184) } ;
        if (var3523) { Result<Option<Result<String>>>.Ok(var4192) } else { Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception")) } 
    } finally { // block id: 4195
        var1303;
        if (true) { var1813 } else { var1813 } ;
        if (false) { var4204 } else { Result<Option<Result<String>>>.Err(Exception("LangFuzz Inner Exception")) } 
    })
}

@echo public func func1701() : Option<Result<String>> { // block id: 745
    (match ((var3584|>func753)) {
        case _ => 
            if (var207) { Result<Option<Result<String>>>.Ok(Option<Result<String>>.None) } else { Result<Option<Result<String>>>.Ok(Option<Result<String>>.None) } 
        
    } ?? Option<Result<String>>.None)
}

@echo public func func739(param740 : Bool) : Unit { // block id: 741
    match (func1701()) {
        case _ => 
            var963 ^ var1057
        
    };
    var1277 %= ((var561) | 1);
    match ((try { // block id: 4229
            if (false) { var3533 } else { Option<Enum757>.None } 
        } finally { // block id: 4234
            Option<Result<String>>.None;
            Option<Enum757>.Some(var935)
        } ?? try { // block id: 4239
            var917 |= var4243;
            ();
            Enum757.enumValue838([var1303, (), (), var425, var227, (), (), var425, (), ()])
        } finally { // block id: 4258
            if (param740) { var935 } else { Enum757.defaultValue } 
        })) {
        case enumValue783(_, caseVar4265, caseVar4266, _) => 
            var2571;
            ()
        
        case _ : (Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8) => 
            @echo let var4300 : Bool = ([((UInt16(42)&127)..(UInt16(200)&127):((-124)|1)), ((UInt16(26)&127)..=(UInt16(2)&127):(110|1)), ((UInt16(227)&127)..(UInt16(221)&127):((-98)|1)), ((UInt16(0)&127)..(UInt16(203)&127):(45|1)), ((UInt16(104)&127)..=(UInt16(60)&127):((-82)|1)), ((UInt16(49)&127)..(UInt16(88)&127):(124|1)), ((UInt16(118)&127)..=(UInt16(79)&127):(22|1)), ((UInt16(203)&127)..(UInt16(58)&127):(34|1)), ((UInt16(85)&127)..(UInt16(142)&127):(8|1)), ((UInt16(96)&127)..=(UInt16(164)&127):(88|1))] is Int16);
            var4275 ||= var4300
        
        case _ : UInt64 => 
            var227;
            var1307;
            var425
        
        case defaultValue => 
            var1307;
            @echo var var4316 : Int64 = Int64(UInt16(132));
            var66 |= var4316;
            ()
        
        case _ => 
            var917 &= UInt16(237)
        
    }
}

@echo public func func4328(param4329 : Array<Bool>) : Bool { // block id: 4330
    try { // block id: 4332
        if (false) { Result<Option<Enum757>>.Err(Exception("LangFuzz Inner Exception")) } else { Result<Option<Enum757>>.Ok(var3533) } 
    } finally { // block id: 4338
        @echo let var4363 : ((Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)*Rune*(Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)*(Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*Option<Enum757>) = ((117, 70, ((UInt8(UInt8(32))&127)..=(UInt8(195)&127):((95|1))), UInt16(157), true, ((Int16(UInt16(65))&127)..=(Int16(Int16(25))&127):(((-104)|1))), Int32(-126)), '8', (((UInt64(97)&127)..(UInt64(235)&127):((-65)|1)), (-82), ((UInt16(118)&127)..(UInt16(216)&127):((-105)|1)), (), (-90.0), (), Float64(Float32(Float32(-63.0)))), ([UInt16(3), UInt16(1), UInt16(107), UInt16(159), UInt16(102), UInt16(200), UInt16(8), UInt16(44), UInt16(28), UInt16(119)], UInt32(Int8(39)), ((UInt8(Int8(-95))&127)..(UInt8(UInt8(241))&127):((Int64((-2))|1))), Float32(-78.0), UInt32(206), UInt8(128)), ([((UInt16(48)&127)..=(UInt16(169)&127):((-54)|1)), ((UInt16(78)&127)..=(UInt16(39)&127):(((-96)|1))), ((UInt16(117)&127)..(UInt16(38)&127):((-84)|1)), ((UInt16(3)&127)..=(UInt16(92)&127):(((-125)|1))), ((UInt16(111)&127)..=(UInt16(242)&127):((9|1))), ((UInt16(215)&127)..(UInt16(70)&127):((116|1))), ((UInt16(165)&127)..(UInt16(23)&127):(8|1)), ((UInt16(34)&127)..(UInt16(106)&127):((-66)|1)), ((UInt16(9)&127)..(UInt16(178)&127):((59|1))), ((UInt16(241)&127)..=(UInt16(59)&127):(5|1))] as Enum757));
        match (var4192) {
            case _ => 
                var1303
            
            case caseVar4347 => 
                ((var2780&127)..=(var4352&127):((61|1)));
                ()
            
            case _ : Unit => 
                if (false) { var4363 } else { var4363 } ;
                Result<Result<Option<Result<String>>>>.Ok(var4204);
                var917 |= UInt16(32)
            
            case _ => 
                @echo let var4443 : Range<Int8> = ((Int8(Int8(UInt8(69)))&127)..(Int8(Int8(89))&127):(((-19)|1)));
                var4443;
                @echo var var4453 : Float32 = Float32(40.0);
                var4453 += Float32(24.0);
                var1303
            
        };
        Result<Option<Enum757>>.Err(Exception("LangFuzz Inner Exception"))
    };
    ();
    var4460
}



@echo func func731(param732 : Unit) : Rune { // block id: 733
    @echo var var4326 : (Bool) -> Unit = func739;
    [false, true, true, true, false, false, true, false, false, false]|>(func4328~>var4326);
    @echo var loopTimeVar4564 : Int64 = 0;
    do {
        loopTimeVar4564++;

    } while ((try { // block id: 4467
        @echo var var4469 : Bool = ((Float64(30.0), ((Int32(47)&127)..=(Int32(110)&127):(81|1)), (((UInt64(184)&127)..=(UInt64(93)&127):((84|1))), Int16(84), UInt32(Int16(-39)), Int32(UInt8(233)), (Float32(-14.0), UInt16(125), (), '9', Int8(-29), UInt8(30))), Enum757.enumValue783(((UInt16(37)&127)..=(UInt16(132)&127):(((-111)|1))), Class15(namedParam1041 : ((-19), 66, ((UInt8(190)&127)..=(UInt8(192)&127):((91|1))), UInt16(11), false, ((Int16(-101)&127)..(Int16(69)&127):((65|1))), Int32(-16)), optionalParam1042 : UInt32(128), namedParam1044 : ((Float32(-128.0), UInt16(245), (), 'S', Int8(29), UInt8(160)), ((Int32(-124)&127)..=(Int32(-86)&127):(95|1)), (Float32(72.0), UInt16(136), (), 'y', Int8(-58), UInt8(74)), Int8(25)), optionalParam1045 : Result<UInt32>.Ok(UInt32(115))), Result<String>.Ok("|5Eq,0~I\"W"), ((UInt16(194)&127)..=(UInt16(40)&127):(20|1))), [UInt16(Int16(36)), UInt16(8), UInt16(UInt16(26)), UInt16(UInt8(41)), UInt16(1), UInt16(UInt16(170)), UInt16(242), UInt16(Int16(-85)), UInt16(253), UInt16(90)], UInt64(137), ((Int8(Int8(90))&127)..=(Int8(Int8(-13))&127):(((-66)|1)))) is (Float64, UInt64, Array<Bool>) -> UInt64);
        var4469
    } catch (e: Exception) { // block id: 4558
        var4275
    } finally { // block id: 4560
        var1280
    }) && loopTimeVar4564 < 100 ) ;
    match (if ((!true)) { (Option<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)>.None ?? var4576) } else { (var4630 ?? (var361, ((Int16(-55)&127)..(Int16(69)&127):((-7)|1)), var66, var2392, var4352)) } ) {
        case _ => 
            var4642;
            ();
            if (false) { '4' } else { '8' } 
        
        case _ : Option<Result<Unit>> => 
            var2392;
            var1303;
            var1747
        
        case _ => 
            if (var4275) { 'U' } else { var1747 } 
        
    }
}



@echo func func698(param699 : Range<Int64>) : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) { // block id: 700
    @echo let var4710 : Range<Int8> = ((Int8(15)&127)..(Int8(Int8(Int8(-51)))&127):((Int64(UInt32(85))|1)));
    @echo func func702(optionalParam703 ! : String = """
EB\\\"C
?T]JH
""", optionalParam705 ! : Result<UInt32> = Result<UInt32>.Err(Exception("LangFuzz Inner Exception")), optionalParam707 ! : Int8 = Int8(UInt8(241)), optionalParam710 ! : Int32 = Int32(Int16(UInt16(137)))) : Unit { // block id: 714
        var20.func718(namedParam719 : Int8(Int8(-24)), namedParam720 : (Result<Range<Int8>>.Ok(var4710) ?? var4710), namedParam721 : (Result<UInt16>.Err(Exception("LangFuzz Inner Exception")) ?? UInt16(79)))
    }
;
    func702();
    @echo var var4812 : Bool = true;
    (if (match ("wN$LaUPa#c") {
        case """
2T][ 
8OU=^
""" | ###"f9U-y\"F#j:"### | "hZ;\\<PaMV`" | ###"ZrUelt2%2c"### => 
            ();
            UInt32(47) >= UInt32(71)
        
        case _ => 
            @echo var var4746 : UInt64 = UInt64(81);
            var1057 ^= var4746;
            true
        
    }) { try { // block id: 4750
        var4752
    } finally { // block id: 4754
        @echo var var4757 : Int32 = Int32(UInt32(Int8(UInt8(171))));
        var4757 |= var4757;
        var4752
    } } else { match (Result<Range<UInt32>>.Err(Exception("LangFuzz Inner Exception"))) {
        case _ : Array<UInt16> => 
            var4752
        
        case _ => 
            @echo let var4775 : Result<Option<Option<Result<Result<Option<Result<String>>>>>>> = Result<Option<Option<Result<Result<Option<Result<String>>>>>>>.Err(Exception("LangFuzz Inner Exception"));
            if (var3523) { var4775 } else { Result<Option<Option<Result<Result<Option<Result<String>>>>>>>.Err(Exception("LangFuzz Inner Exception")) } 
        
    } }  ?? try { // block id: 4779
        ((Int16(-102)&127)..(Int16(-67)&127):((var66|1)));
        @echo var var4789 : Result<Result<Option<Result<String>>>> = Result<Result<Option<Result<String>>>>.Err(Exception("LangFuzz Inner Exception"));
        @echo let var4793 : ?Result<Result<Option<Result<String>>>> = Option<Result<Result<Option<Result<String>>>>>.None;
        if (true) { Option<Option<Result<Result<Option<Result<String>>>>>>.Some(Option<Result<Result<Option<Result<String>>>>>.Some(var4789)) } else { Option<Option<Result<Result<Option<Result<String>>>>>>.Some(var4793) } 
    } catch (e: Exception) { // block id: 4795
        ();
        @echo let var4798 : Array<Range<UInt64>> = [((UInt64(51)&127)..=(UInt64(83)&127):(81|1)), ((UInt64(185)&127)..(UInt64(1)&127):(107|1)), ((UInt64(216)&127)..(UInt64(79)&127):(53|1)), ((UInt64(191)&127)..(UInt64(186)&127):((-4)|1)), ((UInt64(110)&127)..=(UInt64(66)&127):(55|1)), ((UInt64(225)&127)..(UInt64(47)&127):((-71)|1)), ((UInt64(79)&127)..=(UInt64(156)&127):(31|1)), ((UInt64(6)&127)..(UInt64(144)&127):(74|1)), ((UInt64(23)&127)..=(UInt64(4)&127):((-108)|1)), ((UInt64(59)&127)..(UInt64(194)&127):((-44)|1))];
        var4798;
        @echo var var4801 : ??Result<Result<Option<Result<String>>>> = ('x' as Option<Result<Result<Option<Result<String>>>>>);
        var4801
    } finally { // block id: 4804
        @echo let var4806 : Result<Range<UInt8>> = Result<Range<UInt8>>.Ok(((UInt8(156)&127)..=(UInt8(41)&127):(5|1)));
        var4806;
        [true, var4812, false, var3523, var207, var1280, var207, true, var3523, var207];
        @echo let var4828 : ??Result<Result<Option<Result<String>>>> = Option<Option<Result<Result<Option<Result<String>>>>>>.None;
        if (var207) { var4825 } else { var4828 } 
    });
    if (((UInt32(85) * UInt32(62)) > if (false) { // block id: 4837
        ();
        UInt32(161) ** (var3665 & 3)
    } else { // block id: 4842
        UInt32(112)
    })) { (if (var4812) { ((Float32(55.0), var917, (), 'I', var1228, var1248), ((Int32(95)&127)..=(Int32(-5)&127):((-100)|1)), (var300, var917, (), 'Y', var2003, var3584), var1228) } else { (var572, var1691, var572, var1228) } ) } else { var4869 } 
}

@echo public func func583<T0>(param584 : Array<Bool>) : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) where T0 <: Array<Result<Unit>> { // block id: 585
    false|>{ lambdaParameter687 : Bool => @echo var var690 : UInt16 = UInt16(Int16(-92)); var690 };
    var572[2];
    @echo let var4910 : Float32 = Float32(-66.0);
    @echo let var4920 : Array<Bool> = [true, true, true, true, true, false, false, true, true, false];
    match (try { // block id: 4892
            var3665++;
            ([UInt16(253), UInt16(129), var4352, var917, UInt16(134), var4352, UInt16(156), UInt16(189), var917, var2780], UInt32(190), var2392, var4910, var3665, var3584);
            ((var1057&127)..=(UInt64(188)&127):(((-106)|1)))
        } finally { // block id: 4918
            var4920;
            ();
            ((UInt64(178)&127)..(UInt64(107)&127):((122|1)))
        }) {
        case caseVar4929 => 
            if (var207) { Class15() } else { var1412 } ;
            var3665 **= (var3665 & 3);
            (((-88)&127)..((-109)&127):(((-43)|1)))
        
        case _ => 
            ();
            if (var4460) { ((var66&127)..=((-52)&127):((var2826|1))) } else { (((-69)&127)..((-20)&127):((-26)|1)) } 
        
    }|>func698
}


@echo func func160(param161 : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8), param162 : Range<Int32>, optionalParam163 ! : Range<UInt32> = ((UInt32(152)&127)..(UInt32(240)&127):(114|1))) : ((Float32*UInt16*Unit*Rune*Int8*UInt8)*Range<Int32>*(Float32*UInt16*Unit*Rune*Int8*UInt8)*Int8) { // block id: 165
    @echo var var174 : Result<String> = Result<String>.Ok("r4e]ay\\l0+");
    @echo let var178 : String = "i#S /Fa{&*|";
    @echo let var181 : (Float32*UInt16*Unit*Rune*Int8*UInt8) = (Float32(Float32(-75.0)), UInt16(191), (), 'R', Int8(UInt8(Int8(-41))), UInt8(UInt8(151)));
    @echo var var223 : Float32 = Float32(80.0);
    @echo var var237 : UInt16 = UInt16(192);
    @echo let var242 : Int8 = Int8(UInt8(188));
    @echo let var252 : Int64 = Int64(UInt8(UInt8(154)));
    @echo var var294 : Int32 = Int32(87);
    if (((var174 ?? var178) is Result<String>)) { var181 } else { match ((Option<Result<String>>.None ?? Result<String>.Err(Exception("LangFuzz Inner Exception")))) {
        case caseVar203 => 
            if (var207) { var181 } else { var181 } 
        
        case _ : UInt16 => 
            ();
            @echo let var232 : UInt8 = UInt8(0);
            if (true) { (var223, UInt16(226), var227, 'O', Int8(77), var232) } else { (Float32(37.0), var237, (), 'E', var242, var232) } 
        
        case _ => 
            ((50&127)..(var66&127):((var252|1)));
            if (var207) { var259 } else { (var66, (-77), ((UInt8(147)&127)..(UInt8(229)&127):((-37)|1)), var237, var207, ((Int16(-111)&127)..(Int16(-35)&127):(((-123)|1))), var294) } ;
            @echo let var305 : Rune = 'R';
            if (var207) { (var300, var237, (), var305, Int8(-110), UInt8(211)) } else { var181 } 
        
    } } ;
    @echo let var327 : UInt16 = UInt16(Int16(-77));
    @echo let var533 : Int32 = Int32(Int32(57));
    @echo let var565 : Int32 = Int32(Int16(UInt16(Int16(-124))));
    @echo func func312(param313 : UInt8, namedParam314 ! : Unit, optionalParam315 ! : Range<UInt16> = ((UInt16(224)&127)..=(UInt16(210)&127):((-110)|1))) : (Float32*UInt16*Unit*Rune*Int8*UInt8) { // block id: 317
        @echo let var500 : ?Bool = Option<Bool>.Some((((Int64(Int32(-55))&127)..=(Int64(Int8(-63))&127):((Int64(Int16(-87))|1))) is (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32)));
        @echo var var523 : Int8 = Int8(-126);
        @echo var var546 : Rune = 'g';
        if (try { // block id: 320
            true
        } finally { // block id: 322
            ((UInt32(49)&127)..=(UInt32(66)&127):((-113)|1));
            UInt16(53) > var327
        }) { // block id: 330
            @echo let var336 : Aggregate332 = Aggregate332('g', ((Int16(-94)&127)..(Int16(-59)&127):((-37)|1)));
            var336.var450;
            try { // block id: 453
                if (true) { ((Int16(-84)&127)..=(Int16(-96)&127):((var252|1))) } else { ((Int16(-128)&127)..(Int16(-25)&127):(31|1)) } ;
                ();
                @echo var var464 : Int8 = Int8(97);
                var464 /= ((var464) | 1)
            } catch (_) { // block id: 467
                ();
                @echo var var470 : Int16 = Int16(-124);
                var470;
                ()
            };
            var20.var476
        } else if ((var500 ?? [true, true, true, false, false, true, false, false, false, false][3])) { // block id: 514
            var227;
            match (Option<Result<String>>.Some(Result<String>.Err(Exception("LangFuzz Inner Exception")))) {
                case _ => 
                    var523 *= Int8(43);
                    namedParam314;
                    @echo var var538 : Int64 = Int64(Int8(-114));
                    if (false) { (var181, ((var533&127)..=(Int32(75)&127):((var538|1))), (var300, var327, (), var546, var242, param313), Int8(-32)) } else { ((Float32(56.0), UInt16(251), var227, 'n', Int8(0), UInt8(249)), ((var561&127)..(var565&127):((var538|1))), var572, Int8(-27)) } 
                
            }
        } else { // block id: 581
            @echo let var4954 : Array<Bool> = [true, false, true, true, true, true, true, true, false, true];
            var4954|>func583<Array<Result<Unit>>>
        };
        if (false) { // block id: 4958
            @echo var loopTimeVar4963 : Int64 = 0;
            do {
                loopTimeVar4963++;

            } while ((var1280) && loopTimeVar4963 < 100 ) ;
            if (true) { // block id: 4966
                var207 &&= true;
                var4275 &&= false
            }
        };
        var572
    }
;
    @echo var var5040 : (Float32*UInt16*Unit*Rune*Int8*UInt8) = (Float32(Float32(Float32(Float32(5.0)))), UInt16(UInt16(Int8(Int8(64)))), (), 'T', Int8(6), UInt8(Int8(Int8(UInt8(52)))));
    (func312(UInt8(Int8(81)), namedParam314 : (), optionalParam315 : ((var237&127)..(UInt16(230)&127):((var252|1)))), var1691, if (if (var4460) { // block id: 4985
        @echo var var4989 : Float32 = Float32(-6.0);
        var223 **= Float32(Int32(var4989) & 3);
        UInt64(14) > var1057
    } else if (true) { // block id: 4995
        var425;
        @echo let var5000 : UInt16 = UInt16(191);
        var237 **= (var5000 & 3);
        UInt16(160) < UInt16(19)
    } else { // block id: 5005
        ((113&127)..(114&127):(86|1));
        ();
        Int8(6) > Int8(-25)
    }) { // block id: 5011
        (Float32(75.0), UInt16(170), var1303, 'L', Int8(5), UInt8(42))
    } else if (Int32(82) > Int32(77)) { // block id: 5022
        if (false) { Result<Range<Int8>>.Err(Exception("LangFuzz Inner Exception")) } else { Result<Range<Int8>>.Err(Exception("LangFuzz Inner Exception")) } ;
        Option<Result<Unit>>.None;
        if (false) { (Float32(-105.0), var2780, var5034, 'X', Int8(20), UInt8(224)) } else { var5040 } 
    } else { // block id: 5057
        @echo var var5061 : ?(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16) = ([UInt64(219), UInt64(83), UInt64(Int16(52)), UInt64((-84)), UInt64(17), UInt64(Int32(UInt8(229))), UInt64(102), UInt64(UInt32(175)), UInt64(UInt16(205)), UInt64(29)] as (((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16));
        if (true) { var5061 } else { Option<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)>.Some(var654) } ;
        var174;
        (Float32(118.0), UInt16(34), var1303, 'w', var1228, var1248)
    }, (match (()) {
        case () => 
            var3523;
            Result<Int8>.Ok(Int8(30))
        
        case _ => 
            Result<Int8>.Ok(Int8(111))
        
        case caseVar5110 : Range<Int32> => 
            var425;
            if (var1280) { var3432 } else { [((UInt64(103)&127)..(UInt64(231)&127):((-50)|1)), ((UInt64(181)&127)..(UInt64(40)&127):((-83)|1)), ((UInt64(216)&127)..(UInt64(106)&127):((-101)|1)), ((UInt64(199)&127)..=(UInt64(133)&127):(119|1)), ((UInt64(241)&127)..=(UInt64(205)&127):((-28)|1)), ((UInt64(50)&127)..=(UInt64(111)&127):((-91)|1)), ((UInt64(5)&127)..=(UInt64(254)&127):(79|1)), ((UInt64(84)&127)..=(UInt64(196)&127):(70|1)), ((UInt64(30)&127)..=(UInt64(181)&127):((-117)|1)), ((UInt64(16)&127)..=(UInt64(210)&127):(87|1))] } ;
            if (false) { var5120 } else { var5120 } 
        
        case () => 
            var870;
            var4275 &&= var1280;
            Result<Int8>.Err(Exception("LangFuzz Inner Exception"))
        
        case _ => 
            Result<Int8>.Ok(var1228)
        
    } ?? Int8(-98)))
}

@echo public func func154(param155 : Array<UInt16>) : Int16 { // block id: 156
    func160(var4869, ((Int32(2)&127)..(var561&127):((var66|1))), optionalParam163 : ((UInt32(38)&127)..(var3665&127):((42|1))))[0];
    try { // block id: 5147
        Int16(105)
    } catch (e: Exception) { // block id: 5149
        var227;
        @echo var loopTimeVar5157 : Int64 = 0;
        do {
            loopTimeVar5157++;
            ();
            var425
        } while ((var3523) && loopTimeVar5157 < 100 ) ;
        Int16(-8)
    }
}


@echo func func101(param102 : (Int64*Int64*Range<UInt8>*UInt16*Bool*Range<Int16>*Int32), param103 : Interface18) : Rune { // block id: 104
    var20.var109 |= var116[4][1];
    match (((UInt64(254)&127)..(UInt64(138)&127):((-117)|1))) {
        case _ => 
            ();
            var66;
            ()
        
    };
    @echo var var5164 : Array<UInt64> = [UInt64(49), UInt64(172), UInt64(59), UInt64(UInt64(246)), UInt64(UInt32(UInt16(253))), UInt64(216), UInt64(UInt32(UInt16(Int8(-68)))), UInt64(4), UInt64(Int8(119)), UInt64(15)];
    @echo let var5219 : Bool = false;
    @echo let var5225 : Bool = (((Int8(51)&127)..=(Int8(-13)&127):((Int64(UInt32(29))|1))) is Option<Bool>);
    @echo let var5314 : ?Unit = (((Int8(122)&127)..(Int8(-66)&127):(116|1)) as Unit);
    if (([UInt16(126), UInt16(18), UInt16(193), UInt16(133), UInt16(35), UInt16(171), UInt16(222), UInt16(74), UInt16(149), UInt16(71)]|>func154) < var870) { // block id: 5162
        var5164;
        @echo let var5189 : ?Unit = (Int32(56) as Unit);
        (var5189 ?? ());
        @echo let var5205 : Array<Bool> = [true, false, false, true, true, true, false, true, true, true];
        @echo var var5234 : Bool = true;
        try { // block id: 5194
            'o'
        } catch (e: Exception) { // block id: 5196
            var207;
            if (var207) { 'J' } else { var1747 } 
        } finally { // block id: 5202
            [var5205, var5205, var5205, [false, false, true, true, true, false, false, false, true, true], [false, var4460, var4275, var1280, true, true, var4275, var5219, var207, var4460], [var5225, var3523, var5234, var5237, true, var1280, var4275, true, true, false], [false, true, var5251, false, true, var207, true, var5237, var5219, false], [false, false, false, false, false, false, true, true, true, false], var5205, [true, true, true, false, true, var5234, var3523, true, true, var207]];
            'M'
        }
    } else { // block id: 5299
        try { // block id: 5301
            ((var2780&127)..(UInt16(244)&127):(((-10)|1)));
            var425;
            if (false) { var1747 } else { var1747 } 
        } finally { // block id: 5311
            Result<Range<UInt32>>.Err(Exception("LangFuzz Inner Exception"));
            var5314;
            var1747
        }
    }
}

@echo public func func97() : Unit { // block id: 98
    match (func101(((-110), var2826, ((UInt8(142)&127)..=(var3584&127):(((-7)|1))), UInt16(129), true, ((var870&127)..=(Int16(21)&127):((var66|1))), var1277), if (var1280) { var1412 } else { var1412 } )) {
        case caseVar5338 => 
            ()
        
        case caseVar5343 => 
            var1813;
            var5034
        
        case _ => 
            var917 /= ((UInt16(37)) | 1)
        
    };
    try { // block id: 5353

    } finally { // block id: 5354
        ();
        var259;
        (Result<Unit>.Ok(()) ?? ())
    };
    try { // block id: 5362
        ();
        @echo var loopTimeVar5369 : Int64 = 0;
        do {
            loopTimeVar5369++;
            ()
        } while ((true) && loopTimeVar5369 < 100 ) 
    } finally { // block id: 5370

    }
}


@echo func func93(param94 : Int8) : Int64 { // block id: 95
    func97();
    @echo var var5399 : Bool = (("@V\"gf7LaRS" as (Range<UInt64>*Int64*Range<UInt16>*Unit*Float64*Unit*Float64)) is ((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8));
    try { // block id: 5372
        ();
        try { // block id: 5375
            [var5378, [true, true, false, true, false, false, false, true, true, true], var5378, var5378, [true, true, true, false, false, true, false, true, true, false], [false, false, true, false, true, false, false, true, true, false], [false, true, true, false, true, true, true, true, false, false], [true, false, true, true, true, false, false, false, true, false], [var5237, false, var5391, var4460, true, true, var4275, var4275, var5399, false], var5378];
            var66 |= 3
        } finally { // block id: 5408
            Float32(119.0);
            var870 ^= var870
        };
        Int64(UInt8(69))
    } finally { // block id: 5415
        (Option<Result<(((Array<UInt16>*UInt32*Range<UInt8>*Float32*UInt32*UInt8)*UInt32*Int8*Int8)*Range<Int16>*Int64*Range<UInt8>*UInt16)>>.None ?? var4630);
        var66 * var2826
    }
}


main(): Int64 {
    try {
        @echo func func7(namedParam8 ! : Int16, optionalParam9 ! : Int8 = Int8(28), namedParam11 ! : UInt64) : Int64 { // block id: 12
            Int64((var20.func23(namedParam24 : Float32(-32.0), namedParam25 : Int16(-21))));
            var82;
            @echo var var5429 : Result<Range<Int8>> = Result<Range<Int8>>.Ok(((Int8(11)&127)..=(Int8(-95)&127):((-119)|1)));
            @echo var var5438 : Int8 = Int8(75);
            match (var5429) {
                case _ : Int8 => 
                    var2003 + var5438;
                    var1277;
                    Int8(47)
                
                case _ : Interface18 => 
                    var5120;
                    Int8(61)
                
                case caseVar5449 => 
                    ();
                    if (var3523) { var116 } else { (var82, var870, var3665, var561, var572) } ;
                    Int8(62)
                
                case _ : Result<Result<Range<UInt32>>> => 
                    ();
                    var5467
                
                case _ => 
                    var917 ^= UInt16(2);
                    ();
                    Int8(109)
                
            }|>func93
        }
;
        func7(namedParam8 : Int16(var4352), namedParam11 : (Option<UInt64>.None ?? UInt64(226)))
        // CRC Check All Variables
        var crccheck = CrcCheck(5000, 32)
        crccheck.updateBuffer(UInt64(var5467*var5467), 64)
        crccheck.crcCheck()
        crccheck.getCrcOutput()
        ()
    } catch (e: NoneValueException) { println("Exception: NoneValueException") }

    return 0;
}

class CrcCheck {
    var buffer: Array<Int64>
    var poly: Array<Int64>
    var crc_output: Array<Int64>
    var poly_n: Int64
    var buffer_index: Int64
    var crc_output_n: Int64

    init(buffer_n: Int64, crc_n: Int64) {
        buffer_index = 0
        crc_output_n = 0
        crc_output = Array<Int64>(crc_output_n, { i => 0 })
        buffer = Array<Int64>(buffer_n, { i => 0 })
        poly_n = crc_n + 1
        if (crc_n == 32) {
            poly = [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1]
        } else if (crc_n == 16) {
            poly = [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1]
        } else if (crc_n == 8) {
            poly = [1, 0, 0, 0, 0, 0, 1, 1, 1]
        } else {
            poly = [1, 1, 0, 0, 1]
        }
    }

    func updateBuffer(input: UInt64, byte_n: Int64): Unit {
        var value = input
        if (byte_n == 64) {
            value = value & 0xffffffffffffffff
        } else if (byte_n == 32) {
            value = value & 0xffffffff
        } else if (byte_n == 16) {
            value = value & 0xffff
        } else {
            value = value & 0xff
        }
        var byteArray = Array<Int64>(byte_n, { i => 0 })
        var byte_c = 1
        var byte_index = 0
        while(value != 0) {
            if (value % 2 == 1) {
                byte_index = byte_n - byte_c
                byteArray[byte_index] = 1
            }
            byte_c++
            value = value >> 1
        }
        var i = 0
        while (i + byte_index < byte_n) {
            buffer[i + buffer_index] = byteArray[i + byte_index]
            i++
        }
        buffer_index = buffer_index + i
    }

    func crcCheck(): Unit {
        crc_output_n = buffer_index + poly_n - 1
        var crc_buffer = Array<Int64>(crc_output_n, { i => 0 })
        var i = 0
        while (i < buffer_index) {
            crc_buffer[i] = buffer[i]
            i++
        }
        i = 0
        while (i < buffer_index) {
            if (crc_buffer[i] == 1) {
                var j = 0
                while (j < poly_n) {
                    crc_buffer[j + i] = crc_buffer[j + i] ^ poly[j]
                    j++
                }
            }
            i++
        }
        let check_code = crc_buffer[buffer_index..]
        var byte_add = 3 - crc_output_n % 3
        crc_output_n = byte_add + crc_output_n
        crc_output = Array<Int64>(crc_output_n, { i => 0 })
        i = 0
        while (i < crc_output_n - byte_add) {
            if (i < buffer_index) {
                crc_output[i + byte_add] = buffer[i]
            } else {
                crc_output[i + byte_add] = check_code[i - buffer_index]
            }
            i++
        }
    }

    func getCrcOutput(): Unit {
        var i = 0
        while (i < crc_output_n) {
            var hex_value = 2**2 * crc_output[i] + 2**1 * crc_output[i + 1] + 1 * crc_output[i + 2]
            print(hex_value.toString())
            i = i + 3
        }
        print("\n")
    }
}
extend Enum757 {

}

extend Aggregate332 {

}

extend Class15 {

}
// ASSERT: scan parse_expected_character
// ASSERT: scan parse_expected_decl
// ASSERT: scan parse_expected_expression
// ASSERT: scan parse_expected_expr_or_decl_in
// ASSERT: scan parse_expected_left_brace
// ASSERT: scan parse_expected_right_delimiter
// ASSERT: scan parse_illegal_modifier_in_scope
// ASSERT: scan parse_unexpected_declaration_in_scope
// ASSERT: scan parse_unmatched_right_delimiter
