//
//  main.swift
//  HackAssembler
//
//  Created by Yakimenko, Aleksey (Agoda) on 26.01.2021.
//  Copyright © 2021 Yakimenko, Aleksey (Agoda). All rights reserved.
//

import Foundation

if (1...2).contains(CommandLine.arguments.count) {
    print("Please provide input and output file names")
    exit(1)
} else if CommandLine.arguments.count > 3 {
    print("Too many arguments")
    exit(1)
}

let inputFile = CommandLine.arguments[1]
let outPutFile = CommandLine.arguments[2]

do {
    let content = try FileService(fileName: inputFile).read()
    let result = Hack(content).translate()
    try FileService(fileName: outPutFile).write(text: result)
    print(result)
} catch let error as FileServiceError {
    switch error {
    case .readFile:
        print("Could not read the file.")
    case .writeToFile:
        print("Could not save to the file.")
    }
}
