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

