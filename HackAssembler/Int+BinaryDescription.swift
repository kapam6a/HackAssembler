//
//  Int.swift
//  HackAssembler
//
//  Created by Yakimenko, Aleksey (Agoda) on 31.01.2021.
//  Copyright © 2021 Yakimenko, Aleksey (Agoda). All rights reserved.
//

import Foundation

extension Int {

    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        for _ in (0...14) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
        }
        return binaryString
    }
}

extension String {

    var isInt: Bool {
        Int(self) != nil
    }
}
