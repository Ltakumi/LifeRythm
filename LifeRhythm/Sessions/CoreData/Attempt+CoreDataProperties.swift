//
//  Attempt+CoreDataProperties.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/10.
//
//

import Foundation
import CoreData
import SwiftUI

extension Attempt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attempt> {
        return NSFetchRequest<Attempt>(entityName: "Attempt")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var outcome: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var additional: String?
    @NSManaged public var idClimb: Climb?
    @NSManaged public var inSession: Session?
    
    func formatAttempt() -> String {
        let boulderID = idClimb?.name ?? "Unknown"
        let timeFormatted = DateUtils.formatTime(timestamp)
        let outcomeText = outcome ?? "Unknown Outcome"
        return "\(timeFormatted) - \(boulderID) - \(outcomeText)"
    }
    
    var outcomeColor: Color {
        switch outcome {
        case "Progress":
            return .orange
        case "No Progress":
            return .red
        case "No start":
            return Color.customPink
        case "Practice":
            return Color.lightPink
        case "Few moves":
            return Color.palePink
        case "Most moves":
            return Color.lightTeal
        case "Very close": // Corrected case
            return Color.mediumTeal
        case "Send":
            return Color.darkTeal
        default:
            return .black // Default color for unknown outcomes
        }
    }
}



extension Attempt : Identifiable {

}
