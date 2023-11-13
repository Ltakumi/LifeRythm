import Foundation

struct JsonUtils {
    
    static func mockJsonString() -> String {
        let jsonString = """
        {
            "locations": [
                {
                    "city": "Tokyo",
                    "neighborhood": "NeighborhoodName",
                    "phoneNumber": "1234567890"
                }
            ]
        }
        """
        return jsonString
    }
    
    static func jsonString2Data(_ jsonString: String) -> Data?{
        // Check if we can convert
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to Data.")
            return nil
        }

        do {
            // Optionally, validate if the data can be serialized into a JSON object
            let _ = try JSONSerialization.jsonObject(with: jsonData, options: [])
            print("JSON string successfully converted to Data.")
            return jsonData
        } catch {
            print("Error serializing JSON data: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func mockJsonData() -> Data {
        let jsonString = self.mockJsonString()
        return self.jsonString2Data(jsonString) ?? Data()
    }
    
}
