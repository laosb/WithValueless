// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro produces a copy of enum without any associated values.
///
/// The copy will be named as `Valueless{YourEnum}`.
@attached(peer, names: prefixed(Valueless))
public macro WithValueless(conformsTo protocols: [StaticString] = []) = #externalMacro(module: "WithValuelessMacros", type: "WithValuelessMacro")
