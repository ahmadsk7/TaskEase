import Foundation

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = URL(string: "https://your-api-base-url.com")!
    private var authToken: String?
    
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
    
    func fetchTasks() async throws -> [Task] {
        guard let authToken else { throw APIError.unauthorized }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("tasks"))
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode([Task].self, from: data)
    }
    
    func createTask(_ task: Task) async throws {
        guard let authToken else { throw APIError.unauthorized }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("tasks"))
        request.httpMethod = "POST"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(task)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw APIError.invalidResponse
        }
    }
    
    func updateTask(_ task: Task) async throws {
        guard let authToken else { throw APIError.unauthorized }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("tasks/\(task.id)"))
        request.httpMethod = "PUT"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(task)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
    }
    
    func deleteTask(_ taskId: UUID) async throws {
        guard let authToken else { throw APIError.unauthorized }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("tasks/\(taskId)"))
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
    }
    
    enum APIError: Error {
        case unauthorized
        case invalidResponse
        case unknown
    }
} 