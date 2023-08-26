import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(WithValuelessMacros)
import WithValuelessMacros

let testMacros: [String: Macro.Type] = [
    "ＷithValueless": WithValuelessMacro.self,
]
#endif

final class WithValuelessTests: XCTestCase {
  func testMacro() throws {
#if canImport(WithValuelessMacros)
    assertMacroExpansion(
      """
      @WithValueless indirect enum Unit {
      case ton, kilogram, gram
      case kilometer, meter, decimeter, centimeter
      case currency(code: String)
      case derived(Unit, power: Int)
      case derived(Unit, by: Unit)
      case custom(String)
      }
      """,
      expandedSource: """
      @WithValueless indirect enum Unit {
      case ton, kilogram, gram
      case kilometer, meter, decimeter, centimeter
      case currency(code: String)
      case derived(Unit, power: Int)
      case derived(Unit, by: Unit)
      case custom(String)
      enum ValuelessUnit {
      case ton, kilogram, gram
      case kilometer, meter, decimeter, centimeter
      case currencyCodeString
      case derivedUnitPowerInt
      case derivedUnitByUnit
      case customString
      }
      """,
      macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
  }
}
