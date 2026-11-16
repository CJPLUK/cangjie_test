
package javasample

import java.lang.*

@Java ["javasample.FloatFieldTest"]
public foreign open class FloatFieldTest {
    public init()
    public var floatValue: Float32
    public var doubleValue: Float64
    public func printValues(): Unit
}

@Java ["javasample.TestImpl"]
public class TestImpl {
    public init() {}

    public func testFloat(): Unit {
        let expectedFloat = 1.2345678f32
        let expectedDouble = -1234.567890123

        let obj = FloatFieldTest()

        // Write values through Java Mirror.
        obj.floatValue = expectedFloat
        obj.doubleValue = expectedDouble

        // Read values back through Java Mirror.
        println("Cangjie readback:")
        println("float OK: ${obj.floatValue == expectedFloat}")
        println("double OK: ${obj.doubleValue == expectedDouble}")

        // Read the same Java fields directly from Java.
        obj.printValues()
    }
}
