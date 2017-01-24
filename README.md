# Catalyst

Catalyst is a dead simple dynamic type converter for Swift. Register a converter with Catalyst.register, then convert with Catalyst.convert.

## Registration

You can register a converter simply:

    Catalyst.register { (converter: ConverterTo<URL>) in 
        converter.append( URL.init(string:) )
    }

## Usage

You can use your converter anywhere:

    let x: Any // we've got this from JSON or somewhere, it could be anything
    if let url: URL = Catalyst.convert(x) {
        // url is now definitely a valid URL
    }

    // Alternative form
    if let url = Catalyst.convert(x, to: URL.self) {
        // url is still of type URL, here
    }

## Totally dynamic

You can use Catalyst to convert between objects whose types are completely unknown at build time. This is the problem we often run into when trying to build dynamic systems with Swift. Neither the source nor destination objects' types need to be known.

    let x: Any = 100
    var y: Any = "99"

    y = Catalyst.convert(x, for: y)
