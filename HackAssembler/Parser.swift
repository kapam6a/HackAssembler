//
//  Parser.swift
//  HackAssembler
//
//  Created by Yakimenko, Aleksey (Agoda) on 26.01.2021.
//  Copyright © 2021 Yakimenko, Aleksey (Agoda). All rights reserved.
//

import Foundation

enum Command {
    case a
    case c
    case l
    case comment
}

final class Parser {

    private let lines: [String]
    private var currentCoomand: String = ""
    private var currentIndex: Int = 0

    init(_ source: String) {
        self.lines = source.components(separatedBy: .newlines).map{ String($0) }.filter{ !$0.isEmpty }
    }

    /*
    Are there more commands in the input?
    */
    func hasMoreCommands() -> Bool {
        while lines.count > currentIndex {
            if lines[currentIndex].hasPrefix("//") {
                currentIndex += 1
            } else {
                return true
            }
        }
        return false
    }

    /*
    Reads the next command from
    the input and makes it the current command. Should be called only
    if hasMoreCommands() is true. Initially there is no current command.
    */
    func advance() {
        let currentLine = lines[currentIndex]
        currentCoomand = currentLine.components(separatedBy: "//").first!.trimmingCharacters(in: .whitespaces)
        currentIndex += 1
    }

    /*
    Returns the type of the current command:
    - A_COMMAND for @Xxx where Xxx is either a symbol or a decimal number
    - C_COMMAND for dest=comp;jump
    - L_COMMAND (actually, pseudo- command) for (Xxx) where Xxx is a symbol.
    */
    func commandType() -> Command {
        switch currentCoomand.prefix(1) {
        case "@":  return .a
        case "(":  return .l
        case "//": return .comment
        default:   return .c
        }
    }

    /*
    Returns the symbol or decimal Xxx of the current command @Xxx or (Xxx).
    Should be called only when commandType() is A_COMMAND or L_COMMAND.
    */
    func symbol() -> String {
        let noPrefixCommand = currentCoomand.dropFirst()
        switch currentCoomand.prefix(1) {
        case "@": return String(noPrefixCommand)
        default: return String(noPrefixCommand.dropLast())
        }
    }

    /*
    Returns the dest mnemonic in the current C-command (8 possibilities).
    Should be called only when commandType() is C_COMMAND.
    */
    func dest() -> String? {
        currentCoomand.split(separator: "=").first.map(String.init)
    }

    /*
    Returns the comp mnemonic in the current C-command (28 possibilities).
    Should be called only when commandType() is C_COMMAND.
    */
    func comp() -> String {
        currentCoomand.split(separator: "=").last
        .map { $0.split(separator: ";").first! }
        .map(String.init)!
    }

    /*
    Returns the jump mnemonic in the current C-command (8 pos- sibilities).
    Should be called only when commandType() is C_COMMAND.
     */
    func jump() -> String? {
        if currentCoomand.contains(";") {
            return  currentCoomand.split(separator: ";").last.map(String.init)
        } else {
            return nil
        }
    }

    func reset() {
        currentIndex = 0
        currentCoomand = ""
    }
}
