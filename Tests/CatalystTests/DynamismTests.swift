import XCTest
import Catalyst

protocol SomeValue {}
extension String: SomeValue {}
extension Int: SomeValue {}
extension Data: SomeValue {}

extension SomeValue {

    var stringValue: String? {
        get {
            return self as? String
        }
        set {
            if let v = newValue, let c = Catalyst.convert(v, to: Self.self) {
                self = c
            }
        }
    }

    var intValue: Int? {
        get {
            return self as? Int
        }
        set {
            if let v = newValue, let c = Catalyst.convert(v, to: Self.self) {
                self = c
            }
        }
    }

    var dataValue: Data? {
        get {
            return self as? Data
        }
        set {
            if let v = newValue, let c = Catalyst.convert(v, to: Self.self) {
                self = c
            }
        }
    }

}

class DynamismTests: XCTestCase {

    // Just test that the protocol works as expected
    func testSomeValue() {

        let x: SomeValue = "Hello, world"

        XCTAssertEqual(x.stringValue, "Hello, world")
        XCTAssertNil(x.intValue)
        XCTAssertNil(x.dataValue)

    }

    func testConversion() {

        var x: SomeValue = "Hello, world"

        x.intValue = 100

        XCTAssertEqual(x.stringValue, "100")
        XCTAssertNil(x.intValue)

    }

    func testDynamism() {

        var x: SomeValue = "Hello, world"
        let y: SomeValue = 100

        x.intValue = y.intValue

        XCTAssertEqual(x.stringValue, "100")

    }

    func testDoubleDynamism() {

        let x: Any = UInt32(100)
        var y: Any = Int8(10)

        y = Catalyst.convert(x, for: y) ?? -1

        XCTAssert(y is Int8)
        XCTAssertEqual(y as! Int8, 100)

    }

}
