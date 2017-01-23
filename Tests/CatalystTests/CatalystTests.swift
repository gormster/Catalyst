import XCTest
import Catalyst

class CatalystTests: XCTestCase {
    func testSameType() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Catalyst.convert("Hello, World!", to: String.self), "Hello, World!")
    }

    func testStrings() {
        XCTAssertEqual(Catalyst.convert(100, to: String.self), "100")

        // Test that a parameter
        var q = URLQueryItem(name: "test", value: Catalyst.convert(42))
        XCTAssertEqual(q.value, "42")

        q.value = Catalyst.convert(1337)
        XCTAssertEqual(q.value, "1337")
    }

    func testUTF8() {
        let original = "This is some text in a string. 😘"

        guard let data: Data = Catalyst.convert(original) else {
            XCTFail("Did not create Data")
            return
        }
        guard let restored: String = Catalyst.convert(data) else {
            XCTFail("Did not restore String")
            return
        }

        XCTAssertEqual(restored, original)
    }

    func testIntMax() {
        let x: Int8 = 101
        let y = Catalyst.convert(x, to: UInt16.self)

        XCTAssertNotNil(y)
        XCTAssertEqual(y, 101)
        XCTAssert(type(of:y!) == UInt16.self, "\(type(of: y)) is not UInt16")

        // Test edge cases
        let z = Catalyst.convert(-1, to: UInt.self)
        XCTAssertNil(z)

        // This is the only builtin that can't be represented in IntMax, but since it
        // is the only one it can only be converted to itself.
        let q = Catalyst.convert(UInt64.max - 1, to: UInt64.self)
        XCTAssertEqual(q, UInt64.max - 1)

        // Test special case of UInt64 > IntMax.max
        let u = UInt64(IntMax.max) + 1
        let v = Catalyst.convert(u, to: Int64.self)
        XCTAssertNil(v)
    }


    static var allTests : [(String, (CatalystTests) -> () throws -> Void)] {
        return [
            ("testSameType", testSameType),
        ]
    }
}
