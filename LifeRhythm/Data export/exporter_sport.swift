import Foundation
import CoreData

struct LocationExport: Codable {
    var id: UUID?
    var name: String?
    var address: String?
    var locationType: String?
    var additional: String?
    var climbType: String?
    
    init(from location: Location) {
        self.id = location.id
        self.name = location.name
        self.address = location.address
        self.locationType = location.locationType
        self.additional = location.additional
        self.climbType = location.climbType
    }
}

struct ClimbSetExport: Codable {
    var id: UUID?
    var name: String?
    var periodStart: Date?
    var periodEnd: Date?
    var additional: String?
    var inLocationId: UUID?
    
    init(from climbSet: ClimbSet) {
        self.id = climbSet.id
        self.name = climbSet.name
        self.periodStart = climbSet.period_start
        self.periodEnd = climbSet.period_end
        self.additional = climbSet.additional
        self.inLocationId = climbSet.inLocation?.id
    }
}

struct ExerciseExport: Codable {
    var id: UUID?
    var name: String?
    var detail: String?
    var type: String?

    init(from exercise: Exercise) {
        self.id = exercise.id
        self.name = exercise.name
        self.detail = exercise.detail
        self.type = exercise.type
    }
}

struct ClimbExport: Codable {
    var id: UUID?
    var name: String?
    var grade: String?
    var tags: String?
    var inSetId: UUID?

    init(from climb: Climb) {
        self.id = climb.id
        self.name = climb.name
        self.grade = climb.grade
        self.tags = climb.tags
        self.inSetId = climb.inSet?.id
    }
}

struct SessionExport: Codable {
    var id: UUID?
    var additional: String?
    var end: Date?
    var start: Date?
    var inSetId: UUID?
    var type: String?

    init(from session: Session) {
        self.id = session.id
        self.additional = session.additional
        self.end = session.end
        self.start = session.start
        self.type = session.type
        self.inSetId = session.inSet?.id

    }
}

struct ExerciseLogExport: Codable {
    var id: UUID?
    var rep: String?
    var rest: String?
    var effort: String?
    var additional: String?
    var timestamp: Date?
    var exerciseId: UUID?
    var sessionId: UUID?

    init(from exerciseLog: ExerciseLog) {
        self.id = exerciseLog.id
        self.rep = exerciseLog.rep
        self.rest = exerciseLog.rest
        self.effort = exerciseLog.effort
        self.additional = exerciseLog.additional
        self.timestamp = exerciseLog.timestamp
        self.exerciseId = exerciseLog.idExercise?.id
        self.sessionId = exerciseLog.inSession?.id
    }
}

struct AttemptExport: Codable {
    var id: UUID?
    var outcome: String?
    var timestamp: Date?
    var additional: String?
    var idClimb: UUID?
    var inSession: UUID?

    init(from attempt: Attempt) {
        self.id = attempt.id
        self.outcome = attempt.outcome
        self.timestamp = attempt.timestamp
        self.additional = attempt.additional
        self.idClimb = attempt.idClimb?.id
        self.inSession = attempt.inSession?.id
    }
}

//This approach helps to resolve the type inference issue by wrapping each exportable entity in AnyCodable, which is itself Codable.
// This should allow you to combine different types of Codable objects into a single dictionary and then encode that dictionary to JSON.
struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init<T: Encodable>(_ encodable: T) {
        encodeFunc = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}

func createExportJson(locations: [Location], climbSets: [ClimbSet], exercises: [Exercise], climbs: [Climb], sessions: [Session], exerciseLogs: [ExerciseLog], attempts: [Attempt]) -> Data {
    // Convert locations, climbSets, exercises, climbs, sessions, and exerciseLogs to their exportable formats
    let locationExports = locations.map { AnyEncodable(LocationExport(from: $0)) }
    let climbSetExports = climbSets.map { AnyEncodable(ClimbSetExport(from: $0)) }
    let exerciseExports = exercises.map { AnyEncodable(ExerciseExport(from: $0)) }
    let climbExports = climbs.map { AnyEncodable(ClimbExport(from: $0)) }
    let sessionExports = sessions.map { AnyEncodable(SessionExport(from: $0)) }
    let exerciseLogExports = exerciseLogs.map { AnyEncodable(ExerciseLogExport(from: $0)) }
    let attemptExports = attempts.map { AnyEncodable(AttemptExport(from: $0)) }

    // Combine them into a single dictionary
    let combinedData: [String: [AnyEncodable]] = [
        "locations": locationExports,
        "climbsets": climbSetExports,
        "exercises": exerciseExports,
        "climbs": climbExports,
        "sessions": sessionExports,
        "exerciseLogs": exerciseLogExports,
        "attempts": attemptExports
    ]

    // Encode the combined data to JSON
    return encodeToJson(combinedData: combinedData) ?? Data()
}

func encodeToJson<T: Encodable>(combinedData: T) -> Data? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted // Enable pretty-printed JSON output

    do {
        let jsonData = try encoder.encode(combinedData)
        return jsonData
    } catch {
        print("Error encoding to JSON: \(error)")
        return nil
    }
}
