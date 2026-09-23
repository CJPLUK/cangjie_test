// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args


func throwMemberAccessException() {
    throw ExternMemberAccessException("Test 1")
}

func throwFunctionAccessException() {
    throw ExternFunctionAccessException("Test 2")
}

func throwFunctionCallException() {
    throw ExternFunctionCallException("Test 3")
}

func throwIndexAccessException() {
    throw ExternIndexedAccessException("Test 4")
}

func throwExternDynamicException() {
    throw ForeignRuntimeException("Test 5")
}

func throwExternConversionException() {
    throw ExternConversionException("Test 6")
}

func throwCompoundAssignmentException() {
    throw ExternCompoundAssignmentException("Test 7")
}

func throwUnsupportedOperation() {
    throw ExternUnsupportedOperation("Test 8")
}

main () {
    try {
        throwMemberAccessException()
        throw Exception("ExternMemberAccessException not thrown")
    } catch (e: ExternMemberAccessException) {
        println("Caught ExternMemberAccessException: " + e.message)
        if (e.message != "Test 1") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwFunctionAccessException()
        throw Exception("ExternFunctionAccessException not thrown")
    } catch (e: ExternFunctionAccessException) {
        println("Caught ExternFunctionAccessException: " + e.message)
        if (e.message != "Test 2") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwFunctionCallException()
        throw Exception("ExternFunctionCallException not thrown")
    } catch (e: ExternFunctionCallException) {
        println("Caught ExternFunctionCallException: " + e.message)
        if (e.message != "Test 3") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwIndexAccessException()
        throw Exception("ExternIndexedAccessException not thrown")
    } catch (e: ExternIndexedAccessException) {
        println("Caught ExternIndexedAccessException: " + e.message)
        if (e.message != "Test 4") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwExternDynamicException()
        throw Exception("ForeignRuntimeException not thrown")
    } catch (e: ForeignRuntimeException) {
        println("Caught ForeignRuntimeException: " + e.message)
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

    try {
        throwCompoundAssignmentException()
        throw Exception("ExternCompoundAssignmentException not thrown")
    } catch (e: ExternCompoundAssignmentException) {
        println("Caught ExternCompoundAssignmentException: " + e.message)
        if (e.message != "Test 7") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    try {
        throwUnsupportedOperation()
        throw Exception("ExternUnsupportedOperation not thrown")
    } catch (e: ExternUnsupportedOperation) {
        println("Caught ExternUnsupportedOperation: " + e.message)
        if (e.message != "Test 8") {
            throw Exception("Unexpected message: " + e.message)
        }
    }

    0
}