//
//  exporter.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/14.
//

import Foundation
import CoreData



struct LocationExport: Codable {
    var id: UUID?
    var name: String?
    var address: String?
    var locationType: String?
    var additional: String?
    var climbType: String?
    // If you want to export sets as well, you need a similar struct for Set
}


func convertToExportable(locations: [Location]) -> [LocationExport] {
    return locations.map { location in
        LocationExport(
            id: location.id,
            name: location.name,
            address: location.address,
            locationType: location.locationType,
            additional: location.additional,
            climbType: location.climbType
            // For sets, you'll need to iterate and convert them as well
        )
    }
}

func encodeToJson(locations: [LocationExport]) -> Data? {
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // For readable JSON
        let jsonData = try encoder.encode(locations)
        return jsonData
    } catch {
        print("Error encoding locations to JSON: \(error)")
        return nil
    }
}
