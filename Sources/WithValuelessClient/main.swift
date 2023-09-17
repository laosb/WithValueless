import WithValueless

@WithValueless(conformsTo: ["Codable", "CaseIterable"]) indirect enum Unit {
  case ton, kilogram, gram
  case kilometer, meter, decimeter, centimeter
  case currency(code: String)
  case derived(Unit, power: Int)
  case derived(Unit, by: Unit)
  case custom(String)
}
