// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %compile_exe_opt %n.cj -o %output 2>&1 | compare %f
// EXEC: %run %run_opt %output %run_args
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests constant evaluation of match expressions lowered to a switch on Rune, Bool and on
// the constructor index of an enum with more than 256 constructors.

const func matchRune(x: Rune): Int64 {
    match (x) {
        case r'A' | r'\u{141}' => 1
        case r'\u{1F600}' | r'B' => 2
        case r'\u{100}' => 3
        case _ => 0
    }
}

const func matchBool(x: Bool): Int64 {
    match (x) {
        case true => 1
        case false => 2
    }
}

enum Big {
      E0 | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 | E9 | E10 | E11 | E12 | E13 | E14
    | E15 | E16 | E17 | E18 | E19 | E20 | E21 | E22 | E23 | E24 | E25 | E26 | E27 | E28 | E29
    | E30 | E31 | E32 | E33 | E34 | E35 | E36 | E37 | E38 | E39 | E40 | E41 | E42 | E43 | E44
    | E45 | E46 | E47 | E48 | E49 | E50 | E51 | E52 | E53 | E54 | E55 | E56 | E57 | E58 | E59
    | E60 | E61 | E62 | E63 | E64 | E65 | E66 | E67 | E68 | E69 | E70 | E71 | E72 | E73 | E74
    | E75 | E76 | E77 | E78 | E79 | E80 | E81 | E82 | E83 | E84 | E85 | E86 | E87 | E88 | E89
    | E90 | E91 | E92 | E93 | E94 | E95 | E96 | E97 | E98 | E99 | E100 | E101 | E102 | E103 | E104
    | E105 | E106 | E107 | E108 | E109 | E110 | E111 | E112 | E113 | E114 | E115 | E116 | E117 | E118 | E119
    | E120 | E121 | E122 | E123 | E124 | E125 | E126 | E127 | E128 | E129 | E130 | E131 | E132 | E133 | E134
    | E135 | E136 | E137 | E138 | E139 | E140 | E141 | E142 | E143 | E144 | E145 | E146 | E147 | E148 | E149
    | E150 | E151 | E152 | E153 | E154 | E155 | E156 | E157 | E158 | E159 | E160 | E161 | E162 | E163 | E164
    | E165 | E166 | E167 | E168 | E169 | E170 | E171 | E172 | E173 | E174 | E175 | E176 | E177 | E178 | E179
    | E180 | E181 | E182 | E183 | E184 | E185 | E186 | E187 | E188 | E189 | E190 | E191 | E192 | E193 | E194
    | E195 | E196 | E197 | E198 | E199 | E200 | E201 | E202 | E203 | E204 | E205 | E206 | E207 | E208 | E209
    | E210 | E211 | E212 | E213 | E214 | E215 | E216 | E217 | E218 | E219 | E220 | E221 | E222 | E223 | E224
    | E225 | E226 | E227 | E228 | E229 | E230 | E231 | E232 | E233 | E234 | E235 | E236 | E237 | E238 | E239
    | E240 | E241 | E242 | E243 | E244 | E245 | E246 | E247 | E248 | E249 | E250 | E251 | E252 | E253 | E254
    | E255 | E256 | E257 | E258 | E259 | E260 | E261 | E262 | E263 | E264 | E265 | E266 | E267 | E268 | E269
    | E270 | E271 | E272 | E273 | E274 | E275 | E276 | E277 | E278 | E279 | E280 | E281 | E282 | E283 | E284
    | E285 | E286 | E287 | E288 | E289 | E290 | E291 | E292 | E293 | E294 | E295 | E296 | E297 | E298 | E299
}

const func matchBig(x: Big): Int64 {
    match (x) {
        case E44 | E299 => 1
        case E256 | E0 => 2
        case _ => 0
    }
}

const R_A = matchRune(r'A')
const R_141 = matchRune(r'\u{141}')
const R_1F600 = matchRune(r'\u{1F600}')
const R_100 = matchRune(r'\u{100}')
const R_0 = matchRune(r'\u{0}')
const B_TRUE = matchBool(true)
const B_FALSE = matchBool(false)
const BIG_299 = matchBig(E299)
const BIG_256 = matchBig(E256)
const BIG_44 = matchBig(E44)
const BIG_43 = matchBig(E43)

func check(name: String, c: Int64, r: Int64, expected: Int64): Int64 {
    if (c == expected && r == expected) {
        return 0
    }
    println("${name}: const=${c} runtime=${r} expected=${expected}")
    return 1
}

main(): Int64 {
    var failures = 0
    failures += check("R_A", R_A, matchRune(r'A'), 1)
    failures += check("R_141", R_141, matchRune(r'\u{141}'), 1)
    failures += check("R_1F600", R_1F600, matchRune(r'\u{1F600}'), 2)
    failures += check("R_100", R_100, matchRune(r'\u{100}'), 3)
    failures += check("R_0", R_0, matchRune(r'\u{0}'), 0)
    failures += check("B_TRUE", B_TRUE, matchBool(true), 1)
    failures += check("B_FALSE", B_FALSE, matchBool(false), 2)
    failures += check("BIG_299", BIG_299, matchBig(E299), 1)
    failures += check("BIG_256", BIG_256, matchBig(E256), 2)
    failures += check("BIG_44", BIG_44, matchBig(E44), 1)
    failures += check("BIG_43", BIG_43, matchBig(E43), 0)
    return failures
}
