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
    @NSManaged public var idClimb: Climb?
    @NSManaged public var inSession: Session?
    
    func formatAttempt() -> String {
        let boulderID = idClimb?.id ?? "Unknown"
        let timeFormatted = DateUtils.formatTime(timestamp)
        let outcomeText = outcome ?? "Unknown Outcome"
        return "\(timeFormatted) - \(boulderID) - \(outcomeText)"
    }
    
    var outcomeColor: Color {
        switch outcome {
        case "Send":
            return .green
        case "Progress":
            return .orange
        case "No Progress":
            return .red
        default:
            return .black
        }
    }

}



extension Attempt : Identifiable {

}
