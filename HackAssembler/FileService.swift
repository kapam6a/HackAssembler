//
//  FileService.swift
//  HackAssembler
//
//  Created by Yakimenko, Aleksey (Agoda) on 30.01.2021.
//  Copyright © 2021 Yakimenko, Aleksey (Agoda). All rights reserved.
//

import Foundation

enum FileServiceError: Error {
    case readFile
    case writeToFile
}

final class FileService {

    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    func write(text: String) throws {
        do {
            try text.write(to: filePath(), atomically: true, encoding: .ascii)
        } catch {
            throw FileServiceError.writeToFile
        }
    }

    func read() throws -> String {
        do {
            return try String(contentsOf: filePath(), encoding: .utf8)
        } catch {
            throw FileServiceError.readFile
        }
    }
}

extension FileService {

    func filePath() throws -> URL {
        let documentDirectory = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor:nil,
            create:false
        )
        return documentDirectory.appendingPathComponent(fileName)
    }
}
