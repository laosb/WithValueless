import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension String {
  func capitalizingFirstLetterOnly() -> String {
    return prefix(1).uppercased() + dropFirst()
  }
}

public struct WithValuelessMacro: PeerMacro {
  public enum WithValuelessError: CustomStringConvertible, Error {
    case onlyApplicableToEnum
    
    public var description: String {
      switch self {
      case .onlyApplicableToEnum: return "This macro can only be applied to an enum."
      }
    }
  }
  
  private static func generateCaseName(for element: EnumCaseElementListSyntax.Element) -> String {
    if let values = element.parameterClause?.parameters {
      element.name.text + values.map { value in
        let firstName = value.firstName?.text.capitalizingFirstLetterOnly() ?? ""
        let secondName = value.secondName?.text.capitalizingFirstLetterOnly() ?? ""
        let type = value.type.description
        return [firstName, secondName, type].joined()
      }.joined()
    } else {
      element.name.text
    }
  }
  
  public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    print("hello")
    guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
      throw WithValuelessError.onlyApplicableToEnum
    }
    
    var comformanceDeclaration = ""
    if
      case let .argumentList(arguments) = node.arguments,
      let firstArgument = arguments.first,
      firstArgument.label?.text == "conformsTo",
      let array = firstArgument.expression.as(ArrayExprSyntax.self)
    {
      let protocolNames = array.elements.compactMap { $0.expression.as(StringLiteralExprSyntax.self)?.representedLiteralValue }
      comformanceDeclaration = ": \(protocolNames.joined(separator: ", "))"
    }
    
    let members = enumDecl.memberBlock.members
    let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
    let newCases = caseDecls.map { caseDecl in
      "case " + caseDecl.elements.map(generateCaseName).joined(separator: ", ")
    }
    
    let enumString = """
    enum Valueless\(enumDecl.name.text)\(comformanceDeclaration) {
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
