# WithValueless

A Swift macro to generate a copy of the enum with no associated values.

```swift
import WithValueless

@WithValueless
indirect enum Unit {
  case ton, kilogram, gram
  case kilometer, meter, decimeter, centimeter
  case currency(code: String)
  case derived(Unit, power: Int)
  case derived(Unit, by: Unit)
  case custom(String)
}

// Expands:

enum ValuelessUnit {
  case ton, kilogram, gram
  case kilometer, meter, decimeter, centimeter
  case currencyCodeString
  case derivedUnitPowerInt
  case derivedUnitByUnit
  case customString
}
```

# License

[MIT](./LICENSE).
