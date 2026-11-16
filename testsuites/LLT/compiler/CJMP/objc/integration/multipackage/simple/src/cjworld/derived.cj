package cjworld

import objc.lang.*
import cjbase.*

@ObjC
public class Derived <: Base {
    public init() {}
    public func foo(): Int64 { 2 }
}
