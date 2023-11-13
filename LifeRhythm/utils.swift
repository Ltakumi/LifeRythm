//
//  utils.swift
//  LifeRhythm
//
//  Created by Louis Takumi on 2023/11/12.
//

import Foundation

struct DateUtils {
    static func formatDate(_ date: Date?) -> String {
        guard let validDate = date else {
            return ""  // Or return a placeholder string if you prefer
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: validDate)
    }
    
    static func formatTimestamp(_ date: Date?) -> String {
            guard let validDate = date else {
                return ""  // Returns an empty string if there is no date
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: validDate)
        }
    
    static func formatTime(_ date: Date?) -> String {
            guard let validDate = date else {
                return ""  // Returns an empty string if there is no date
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter.string(from: validDate)
        }
}
