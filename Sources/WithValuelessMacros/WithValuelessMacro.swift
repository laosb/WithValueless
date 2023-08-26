import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct WithValuelessMacro: PeerMacro {
  enum WithValuelessError: CustomStringConvertible, Error {
    case onlyApplicableToEnum
    
    var description: String {
      switch self {
      case .onlyApplicableToEnum: return "This macro can only be applied to an enum."
      }
    }
  }
  
  private static func generateCaseName(for element: EnumCaseElementListSyntax.Element) -> String {
    if let values = element.parameterClause?.parameters {
      element.name.text + values.map { value in
        let firstName = value.firstName?.text.capitalized ?? ""
        let secondName = value.secondName?.text.capitalized ?? ""
        let type = value.type.description
        return [firstName, secondName, type].joined()
      }.joined()
    } else {
      element.name.text
    }
  }
  
  public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
      throw WithValuelessError.onlyApplicableToEnum
    }
    
    let members = enumDecl.memberBlock.members
    let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
    let newCases = caseDecls.map { caseDecl in
      "case " + caseDecl.elements.map(generateCaseName).joined(separator: ", ")
    }
    
    let enumString = """
    enum Valueless\(enumDecl.name.text) {
      \(newCases.joined(separator: "\n"))
    }
    """
    return [DeclSyntax(stringLiteral: enumString)]
  }
}

@main
struct WithValuelessPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    WithValuelessMacro.self,
  ]
}
