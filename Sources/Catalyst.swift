public struct Catalyst {

    private static var _registry = [AnyObject]()
    private static var _defaultsLoaded = false

    public static func convert<V>(_ value: Any) -> V? {
        return self.convert(value, to: V.self)
    }

    public static func convert<V>(_ value: Any, to type: V.Type) -> V? {
        if let same = value as? V {
            return same
        }

        if !_defaultsLoaded {
            loadDefaults()
        }

        for case let converter as ConverterTo<V> in _registry {
            if let result = converter.convert(value) {
                return result
            }
        }

        return nil
    }

    public static func register<V>(converter: ConverterTo<V>, for type: V.Type) {
        _registry.append(converter)
    }

    public static func register<V>(converterSetup: (ConverterTo<V>) -> ()) {
        let converter = ConverterTo<V>(setup: converterSetup)
        self.register(converter: converter, for: V.self)
    }

}

struct AnyInitialiser<T, V> {
    let initialiser: (T) -> V?

    func initialise(_ value: Any) -> V? {
        if let v = value as? T {
            return initialiser(v)
        }
        return nil
    }
}

public class ConverterTo<V> {
    private var initialisers: [ObjectIdentifier:(Any) -> V?] = [:]

    public init() {

    }

    public init(setup: (ConverterTo<V>) -> ()) {
        setup(self)
    }

    public func append<T>(_ initialiser: @escaping (T) -> V?, for type: T.Type) {
        let initialiser = AnyInitialiser(initialiser: initialiser)
        initialisers[ObjectIdentifier(type)] = initialiser.initialise
    }

    open func convert(_ from: Any) -> V? {
        if let v = from as? V {
            return v
        }
        for (typeID, initialiser) in initialisers {
            if ObjectIdentifier(type(of:from)) == typeID {
                return initialiser(from)
            }
        }
        return nil
    }

}

