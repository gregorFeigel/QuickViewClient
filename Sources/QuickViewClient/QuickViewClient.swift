import Foundation

public struct PreviewObject: Codable {
    public init(description: String, img: Data? = nil) {
        self.description = description
        self.img = img
    }
    
    var description: String
    var img: Data?
}

@available(macOS 10.15.0, *)
public final class QuickViewClient {
    
    public init(clientID: String,
         hostname: String = "localhost",
         port: Int = 3434) {
        self.clientID = clientID
        self.port = port
        self.hostname = hostname
    }
    
    let clientID: String
    let port: Int
    let hostname: String
    
    public func updateQuickView(_ previewObject: PreviewObject) async throws {
        guard let url = URL(string: "http://\(hostname):\(port)/img/\(clientID)") else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(previewObject)
        } catch {
            throw error
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Response status code: \(httpResponse.statusCode)")
        }
    }
}

