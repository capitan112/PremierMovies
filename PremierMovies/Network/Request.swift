import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
}

struct Request<Value> {
    var method: Method
    var path: String
    var queryParams: [String: String]
    var headers: [String: String] = [:]
    var body: Data?

    init(method: Method = .get, path: String, parameters: [String: String] = [:], headers: [String: String] = [:], body: Data? = nil) {
        self.method = method
        self.path = path
        queryParams = parameters
        self.headers = headers
        self.body = body
    }
}
