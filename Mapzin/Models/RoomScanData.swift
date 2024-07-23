//
//  RoomScanData.swift
//  Mapzin
//
//  Created by Amir Malamud on 23/06/2024.
//

struct RoomScanData: Codable {
    let rooms: [Room]
}

struct Room: Codable {
    let name: String
    let objects: [Object]
}

struct Object: Codable {
    let name: String
    let position: Position
}
