import Foundation

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

// Function to encode to jsonData
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

func createCombinedSportData(locations: [Location], climbSets: [ClimbSet], exercises: [Exercise], climbs: [Climb], sessions: [Session], exerciseLogs: [ExerciseLog], attempts: [Attempt]) -> Data {
    
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

func createCombinedTaskData(tasks: [Task], taskDays: [TaskDay]) -> Data {
    // Convert tasks and taskDays to their exportable formats
    let taskExports = tasks.map { AnyEncodable(TaskExport(from: $0)) }
    let taskDayExports = taskDays.map { AnyEncodable(TaskDayExport(from: $0)) }

    // Combine them into a single dictionary
    let combinedData: [String: [AnyEncodable]] = [
        "tasks": taskExports,
        "taskDays": taskDayExports
    ]
    
    // Encode the combined data to JSON
    return encodeToJson(combinedData: combinedData) ?? Data()
}
