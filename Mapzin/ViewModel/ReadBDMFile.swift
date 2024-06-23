//
//  BDMFileManger.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

import Foundation

struct BdmManagerData {
    
    func readBDMFile(filePath: String) -> RoomScanData? {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath) else {
            print("File not found: \(filePath)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let decoder = JSONDecoder() // Example assuming BDM is JSON format
            let roomScanData = try decoder.decode(RoomScanData.self, from: data)
            return roomScanData
        } catch {
            print("Error reading or parsing BDM file: \(error)")
            return nil
        }
    }
}
