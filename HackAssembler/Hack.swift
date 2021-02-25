//
//  Hack.swift
//  HackAssembler
//
//  Created by Yakimenko, Aleksey (Agoda) on 30.01.2021.
//  Copyright © 2021 Yakimenko, Aleksey (Agoda). All rights reserved.
//

import Foundation

final class Hack {

    private let parser: Parser
    private let code: Code
    private let symbolTable: SymbolTable
    
    private var translatedCommands: [String] = []
    private var currentCommandAdress = 0
    private var currentVariableAdress = 16

    init(_ source: String) {
        self.parser = Parser(source)
        self.code = Code()
        self.symbolTable = SymbolTable()
    }

    func translate() -> String {
        firstPass()
        reset()
        secondPass()

        return translatedCommands.joined(separator: "\n")
    }
}

private extension Hack {

    func firstPass() {
        while parser.hasMoreCommands() {
            parser.advance()
            switch parser.commandType() {
            case .l: populateSymbolTable()
            case .comment: continue
            default: currentCommandAdress += 1
            }
        }
    }

    func reset() {
        parser.reset()
        currentCommandAdress = 0
    }

    func secondPass() {
        while parser.hasMoreCommands() {
            parser.advance()
            switch parser.commandType() {
            case .a: translateA()
            case .c: translateC()
            case .l,
                 .comment: continue
            }
        }
    }

    func populateSymbolTable() {
        let s = parser.symbol()
        symbolTable.addEntry(symbol: s, address: currentCommandAdress)
    }

    func translateA() {
        let s = parser.symbol()
        let a: Int?
        if s.isInt {
            a = Int(s)
        } else {
            if !symbolTable.contains(symbol: s) {
                symbolTable.addEntry(symbol: s, address: currentVariableAdress)
                currentVariableAdress += 1
            }
            a = symbolTable.address(symbol: s)
        }

        let translatedCode = "0" + a!.binaryDescription
        translatedCommands.append(translatedCode)
    }

    func translateC() {
        let c = parser.comp()
        let d = parser.dest()
        let j = parser.jump()

        let cc = code.comp(c)
        let dd = code.dest(d)
        let jj = code.jump(j)

        let translatedCode = "111" + cc + dd + jj
        translatedCommands.append(translatedCode)
    }
}
