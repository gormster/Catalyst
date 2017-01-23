import Foundation

protocol IntMaxConvertible {
    init?(intMax:IntMax)
    func toIntMax() -> IntMax
}

protocol _IntMaxConvertible: IntMaxConvertible {
    init(_:IntMax)
    static var max: Self { get }
    static var min: Self { get }
}

extension _IntMaxConvertible {
    init?(intMax v: IntMax) {
        if v < Self.min.toIntMax() || v > Self.max.toIntMax() {
            return nil
        }
        self.init(v)
    }
}

extension Int: _IntMaxConvertible {}
extension Int8: _IntMaxConvertible {}
extension Int16: _IntMaxConvertible {}
extension Int32: _IntMaxConvertible {}
extension Int64: _IntMaxConvertible {}
extension UInt: _IntMaxConvertible {}
extension UInt8: _IntMaxConvertible {}
extension UInt16: _IntMaxConvertible {}
extension UInt32: _IntMaxConvertible {}
extension UInt64: _IntMaxConvertible {}

class ConverterThroughIntMaxTo<V: IntMaxConvertible>: ConverterTo<V> {
    override func convert(_ from: Any) -> V? {
        if let s = super.convert(from) {
            return s
        }

        // Special case: UInt64 is bigger than IntMax.max
        if let fromUInt64 = from as? UInt64 {
            if fromUInt64 > UInt64(IntMax.max) {
                return nil
            }
        }

        if let fromInt = from as? IntMaxConvertible {
            return V(intMax: fromInt.toIntMax())
        }
        return nil
    }
}

func loadDefaults() {
    Catalyst.register { (converter: ConverterTo<String>) in
        converter.append(String.init(_:), for: Int.self)
        converter.append(String.init(_:), for: Int8.self)
        converter.append(String.init(_:), for: Int16.self)
        converter.append(String.init(_:), for: Int32.self)
        converter.append(String.init(_:), for: Int64.self)
        converter.append(String.init(_:), for: UInt.self)
        converter.append(String.init(_:), for: UInt8.self)
        converter.append(String.init(_:), for: UInt16.self)
        converter.append(String.init(_:), for: UInt32.self)
        converter.append(String.init(_:), for: UInt64.self)
        converter.append({ String(data: $0, encoding: .utf8) }, for: Data.self)
    }

    Catalyst.register { (converter: ConverterTo<Data>) in
        converter.append({ $0.data(using: .utf8) }, for: String.self)
    }

    Catalyst.register(converter: ConverterThroughIntMaxTo<Int>(), for: Int.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<Int8>(), for: Int8.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<Int16>(), for: Int16.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<Int32>(), for: Int32.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<Int64>(), for: Int64.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<UInt>(), for: UInt.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<UInt8>(), for: UInt8.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<UInt16>(), for: UInt16.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<UInt32>(), for: UInt32.self)
    Catalyst.register(converter: ConverterThroughIntMaxTo<UInt64>(), for: UInt64.self)
}
