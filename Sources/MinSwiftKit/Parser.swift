import Foundation
import SwiftSyntax

class Parser: SyntaxVisitor {
    private(set) var tokens: [TokenSyntax] = []
    private var index = 0
    private(set) var currentToken: TokenSyntax!

    // MARK: Practice 1

    override func visit(_ token: TokenSyntax) {
        print("Parsing \(token.tokenKind)")
        tokens.append(token)
    }

    @discardableResult
    func read() -> TokenSyntax {
//        fatalError("Not Implemented")
//        return currentToken?.tokenKind
        let hoge = tokens[index]
        currentToken = hoge
        index += 1
        return hoge
    }

    func peek(_ n: Int = 0) -> TokenSyntax {
//        fatalError("Not Implemented")
        let hoge = tokens[index + n]
        return hoge
    }

    // MARK: Practice 2

    private func extractNumberLiteral(from token: TokenSyntax) -> Double? {
//        fatalError("Not Implemented")
//        let double = Double?(Double(token.hashValue))
        switch token.tokenKind {
        case .integerLiteral(let value):
            let hoge = Double(value)
            return hoge
        case .floatingLiteral(let value):
            let hoge = Double(value)
            return hoge
        default:
            return nil
        }
//        return Double?(token.tokenKind)
    }

    func parseNumber() -> Node {
        guard let value = extractNumberLiteral(from: currentToken) else {
            fatalError("any number is expected")
        }
        read() // eat literal
        return NumberNode(value: value)
    }

    private func extractVariableIdentifier(from token: TokenSyntax) -> String? {
        switch token.tokenKind {
        case .identifier(let value):
            return value
        default:
            return nil
        }
    }

    func parseIdentifierExpression() -> Node {
        guard let value = extractVariableIdentifier(from: currentToken) else {
            fatalError("Not Implemented")
        }
        read()

//        guard case .identifier(let value1) = currentToken.tokenKind else {
//            fatalError()
//        }
//        read()

        var arguments: Array<CallExpressionNode.Argument> = []
        while true {
            if case .rightParen = currentToken.tokenKind {
                break
            } else if case .identifier(let argumentName) = currentToken.tokenKind {
                read()

                guard case .colon = currentToken.tokenKind else {
                    fatalError()
                }
                read()

                let value = parseExpression()
                let argument = CallExpressionNode.Argument(label: argumentName, value: value!)
                arguments.append(argument)
            } else if case .comma = currentToken.tokenKind {
                read()
            }
        }

        return CallExpressionNode(callee: value1, arguments: arguments)
//
//        guard  case .leftParen = currentToken.tokenKind else {
//            return VariableNode(identifier: value1)
//        }
//        read()
//
//        switch currentToken.tokenKind {
//        case .rightParen:
//            read()
//            return CallExpressionNode(callee: value1, arguments: [])
//        default:
//            let body: CallExpressionNode.Argument = parseExpression() as! CallExpressionNode.Argument
//            return CallExpressionNode(callee: value1, arguments: body)
//        }
    }

    // MARK: Practice 3

    func extractBinaryOperator(from token: TokenSyntax) -> BinaryExpressionNode.Operator? {
//        fatalError("Not Implemented")
        switch token.tokenKind {
        case .spacedBinaryOperator(let value):
            return BinaryExpressionNode.Operator.init(rawValue: value)
        default:
            return nil
        }
    }

    private func parseBinaryOperatorRHS(expressionPrecedence: Int, lhs: Node?) -> Node? {
        var currentLHS: Node? = lhs
        while true {
            let binaryOperator = extractBinaryOperator(from: currentToken!)
            let operatorPrecedence = binaryOperator?.precedence ?? -1
            
            // Compare between nextOperator's precedences and current one
            if operatorPrecedence < expressionPrecedence {
                return currentLHS
            }
            
            read() // eat binary operator
            var rhs = parsePrimary()
            if rhs == nil {
                return nil
            }
            
            // If binOperator binds less tightly with RHS than the operator after RHS, let
            // the pending operator take RHS as its LHS.
            let nextPrecedence = extractBinaryOperator(from: currentToken)?.precedence ?? -1
            if (operatorPrecedence < nextPrecedence) {
                // Search next RHS from currentRHS
                // next precedence will be `operatorPrecedence + 1`
                rhs = parseBinaryOperatorRHS(expressionPrecedence: operatorPrecedence + 1, lhs: rhs)
                if rhs == nil {
                    return nil
                }
            }
            
            guard let nonOptionalRHS = rhs else {
                fatalError("rhs must be nonnull")
            }
            
            currentLHS = BinaryExpressionNode(binaryOperator!,
                                              lhs: currentLHS!,
                                              rhs: nonOptionalRHS)
        }
    }

    // MARK: Practice 4

    func parseFunctionDefinitionArgument() -> FunctionNode.Argument {
//        fatalError("Not Implemented")
        var hoge: FunctionNode.Argument
        switch currentToken.tokenKind {
        case .identifier(let value):
            hoge = .init(label: value, variableName: value)
            read()
        default:
            fatalError("Not Implemented")
        }
        read()
        read()
//        switch currentToken.tokenKind {
//        case .colon:
//            read()
//        default:
//            fatalError("Not Implemented")
//        }
//        switch currentToken.tokenKind {
//        case .identifier(let value):
//            hoge = .init(label: value, variableName: value)
//            read()
//            return hoge
//        default:
//            fatalError("Not Implemented")
//        }
        return hoge
    }

    func parseFunctionDefinition() -> Node {
        switch currentToken.tokenKind {
        case .funcKeyword:
            read()
        default:
            fatalError("Not Implemented")
        }

        guard case .identifier(let functionName) = currentToken.tokenKind else {
            fatalError()
        }
        read()

        guard case .leftParen = currentToken.tokenKind else {
            fatalError()
        }
        read()

        guard case .rightParen = currentToken.tokenKind else {
            fatalError()
        }
        read()

        guard case .arrow = currentToken.tokenKind else {
            fatalError()
        }
        read()

        guard case .identifier(let _) = currentToken.tokenKind else {
            fatalError()
        }
        read()

        guard case .leftBrace = currentToken.tokenKind else {
            fatalError()
        }
        read()

//        guard case .rightParen = currentToken.tokenKind else {
//            fatalError()
//        }
//        read()

        guard let body = parseExpression() else {
            fatalError()
        }

        guard case .rightBrace = currentToken.tokenKind else {
            fatalError()
        }
        read()

        let hoge: FunctionNode = FunctionNode.init(name: functionName, arguments: [], returnType: .double, body: body)
        return hoge
    }

    // MARK: Practice 7

    func parseIfElse() -> Node {
        fatalError("Not Implemented")
    }

    // PROBABLY WORKS WELL, TRUST ME

    func parse() -> [Node] {
        var nodes: [Node] = []
        read()
        while true {
            switch currentToken.tokenKind {
            case .eof:
                return nodes
            case .funcKeyword:
                let node = parseFunctionDefinition()
                nodes.append(node)
            default:
                if let node = parseTopLevelExpression() {
                    nodes.append(node)
                    break
                } else {
                    read()
                }
            }
        }
        return nodes
    }

    private func parsePrimary() -> Node? {
        switch currentToken.tokenKind {
        case .identifier:
            return parseIdentifierExpression()
        case .integerLiteral, .floatingLiteral:
            return parseNumber()
        case .leftParen:
            return parseParen()
        case .funcKeyword:
            return parseFunctionDefinition()
        case .returnKeyword:
            return parseReturn()
        case .ifKeyword:
            return parseIfElse()
        case .eof:
            return nil
        default:
            fatalError("Unexpected token \(currentToken.tokenKind) \(currentToken.text)")
        }
        return nil
    }

    func parseExpression() -> Node? {
        guard let lhs = parsePrimary() else {
            return nil
        }
        return parseBinaryOperatorRHS(expressionPrecedence: 0, lhs: lhs)
    }

    private func parseReturn() -> Node {
        guard case .returnKeyword = currentToken.tokenKind else {
            fatalError("returnKeyword is expected but received \(currentToken.tokenKind)")
        }
        read() // eat return
        if let expression = parseExpression() {
            return ReturnNode(body: expression)
        } else {
            // return nothing
            return ReturnNode(body: nil)
        }
    }

    private func parseParen() -> Node? {
        read() // eat (
        guard let v = parseExpression() else {
            return nil
        }

        guard case .rightParen = currentToken.tokenKind else {
                fatalError("expected ')'")
        }
        read() // eat )

        return v
    }

    private func parseTopLevelExpression() -> Node? {
        if let expression = parseExpression() {
            // we treat top level expressions as anonymous functions
            let anonymousPrototype = FunctionNode(name: "main", arguments: [], returnType: .int, body: expression)
            return anonymousPrototype
        }
        return nil
    }
}

private extension BinaryExpressionNode.Operator {
    var precedence: Int {
        switch self {
        case .addition, .subtraction: return 20
        case .multication, .division: return 40
        case .lessThan:
            fatalError("Not Implemented")
        }
    }
}
