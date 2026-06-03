// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args


func throwMemberAccessException() {
    throw MemberAccessException("Test 1")
}

func throwFunctionAccessException() {
    throw FunctionAccessException("Test 2")
}

func throwFunctionCallException() {
    throw FunctionCallException("Test 3")
}

func throwIndexAccessException() {
    throw IndexAccessException("Test 4")
}

func throwExternDynamicException() {
    throw ExternDynamicException("Test 5")
}

func throwExternConversionException() {
    throw ExternConversionException("Test 6")
}

main () {
    try {
        throwMemberAccessException()
        throw Exception("MemberAccessException not thrown")
    } catch (e: MemberAccessException) {
        println("Caught MemberAccessException: " + e.message)
        if (e.message != "Test 1") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwFunctionAccessException()
        throw Exception("FunctionAccessException not thrown")
    } catch (e: FunctionAccessException) {
        println("Caught FunctionAccessException: " + e.message)
        if (e.message != "Test 2") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwFunctionCallException()
        throw Exception("FunctionCallException not thrown")
    } catch (e: FunctionCallException) {
        println("Caught FunctionCallException: " + e.message)
        if (e.message != "Test 3") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwIndexAccessException()
        throw Exception("IndexAccessException not thrown")
    } catch (e: IndexAccessException) {
        println("Caught IndexAccessException: " + e.message)
        if (e.message != "Test 4") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwExternDynamicException()
        throw Exception("ExternDynamicException not thrown")
    } catch (e: ExternDynamicException) {
        println("Caught ExternDynamicException: " + e.message)
        if (e.message != "Test 5") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwExternConversionException()
        throw Exception("ExternConversionException not thrown")
    } catch (e: ExternConversionException) {
        println("Caught ExternConversionException: " + e.message)
        if (e.message != "Test 6") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    0
}