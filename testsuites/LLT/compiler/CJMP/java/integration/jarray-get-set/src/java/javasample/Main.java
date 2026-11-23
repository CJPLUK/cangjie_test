// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package javasample;

public final class Main {
    private Main() {}

    public static void main(String[] args) {
        TestImpl impl = new TestImpl();

        testPrimitiveArrays(impl);
        testStringArray(impl);
        testMirrorObjectArray(impl);
        testJavaImplArray(impl);
        testJObjectArray(impl);
        testExceptions(impl);

        System.out.println("ALL JArray get/set regression tests: PASS");
    }

    private static void testPrimitiveArrays(TestImpl impl) {
        boolean[] booleans = {true, true};
        byte[] bytes = {1, 1};
        char[] chars = {1, 1};
        short[] shorts = {1, 1};
        int[] ints = {1, 1};
        long[] longs = {1, 1};
        float[] floats = {1.0f, 1.0f};
        double[] doubles = {1.0, 1.0};

        impl.testPrimitiveArrays(booleans, bytes, chars, shorts, ints, longs, floats, doubles);

        check(!booleans[0] && booleans[1], "Java readback boolean[]");
        check(bytes[0] == 2 && bytes[1] == 3, "Java readback byte[]");
        check(chars[0] == 2 && chars[1] == 3, "Java readback char[]");
        check(shorts[0] == -2 && shorts[1] == 3, "Java readback short[]");
        check(ints[0] == 2 && ints[1] == 3, "Java readback int[]");
        check(longs[0] == 2 && longs[1] == 3, "Java readback long[]");
        check(floats[0] == 2.5f && floats[1] == -3.5f, "Java readback float[]");
        check(doubles[0] == 2.25 && doubles[1] == -3.75, "Java readback double[]");
        System.out.println("primitive arrays: PASS");
    }

    private static void testStringArray(TestImpl impl) {
        String[] values = {"initial", "initial"};
        impl.testStringArray(values);
        check("written-by-cangjie".equals(values[0]), "Java readback String[0]");
        check("你好，JNI".equals(values[1]), "Java readback String[1]");
        System.out.println("string array: PASS");
    }

    private static void testMirrorObjectArray(TestImpl impl) {
        Item[] values = {new Item(1), new Item(1)};
        impl.testMirrorObjectArray(values);
        check(values[0].getValue() == 2, "Java readback Item[0]");
        check(values[1].getValue() == 3, "Java readback Item[1]");
        System.out.println("JavaMirror Item[] get/set and Java readback: PASS");
    }

    private static void testJavaImplArray(TestImpl impl) {
        Item[] values = {new SpecialItem(11), new Item(1)};
        impl.testJavaImplArray(values);
        check(values[0] instanceof SpecialItem, "JavaImpl instance received from Java remains SpecialItem");
        check(values[0].getValue() == 1011, "Java readback JavaImpl instance from Java");
        check(values[1] instanceof SpecialItem, "Cangjie-written JavaImpl instance remains SpecialItem");
        check(values[1].getValue() == 1022, "Java readback Cangjie-written JavaImpl instance");
        System.out.println("JavaImpl subclass in Item[]: PASS");
    }

    private static void testJObjectArray(TestImpl impl) {
        Item first = new Item(11);
        Item second = new Item(22);
        Object[] values = {first, second};
        impl.testJObjectArray(values);
        check(values[0] == second, "Java readback Object[0] identity after swap");
        check(values[1] == first, "Java readback Object[1] identity after swap");
        System.out.println("JObject/Object[] get/set and identity: PASS");
    }

    private static void testExceptions(TestImpl impl) {
        int[] primitiveValues = {1};
        Item[] itemValues = {new Item(1)};
        String[] strings = {"cannot-store-Item"};

        expectRuntimeException("primitive get out of bounds", () -> impl.primitiveGetOutOfBounds(primitiveValues));
        expectRuntimeException("primitive set out of bounds", () -> impl.primitiveSetOutOfBounds(primitiveValues));
        expectRuntimeException("object get out of bounds", () -> impl.objectGetOutOfBounds(itemValues));
        expectRuntimeException("object set out of bounds", () -> impl.objectSetOutOfBounds(itemValues));
        expectRuntimeException("object set ArrayStoreException propagation", () -> impl.objectSetArrayStoreException(strings));
    }

    private static void check(boolean condition, String message) {
        if (!condition) {
            throw new AssertionError("FAIL: " + message);
        }
    }

    private static void expectRuntimeException(String name, Runnable operation) {
        try {
            operation.run();
        } catch (RuntimeException expected) {
            System.out.println(name + ": PASS");
            return;
        }
        throw new AssertionError("FAIL: " + name + " did not throw RuntimeException");
    }
}
