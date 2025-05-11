@testable import PremierMovies
import XCTest

final class APITests: XCTestCase {
    func test_queryParams_appendedToURL() {
        let base = "https://example.com"
        let request = Request<Movie>(
            method: .get,
            path: "/testing",
            parameters: ["key1": "value1", "key2": "value2"]
        )

        let url = request.makeURLRequest(host: base, apiKey: "api123").url!.absoluteString

        XCTAssertTrue(url.contains("key1=value1"))
        XCTAssertTrue(url.contains("key2=value2"))
        XCTAssertTrue(url.contains("api_key=api123"))
        XCTAssertTrue(url.starts(with: base))
    }

    func test_urlBuilder_withNoParameters() {
        let request = Request<Movie>(path: "test")
        let url = request.makeURLRequest(host: "https://example.com", apiKey: "abc").url!

        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "example.com")
        XCTAssertEqual(url.path, "/test")
        XCTAssertTrue(url.query?.contains("api_key=abc") ?? false)
    }

    func test_urlBuilder_encodesQueryParametersCorrectly() {
        let request = Request<Movie>(
            path: "movie",
            parameters: ["search": "Star Wars & More"]
        )

        let urlString = request.makeURLRequest(host: "https://api.example.com", apiKey: "abc123").url!.absoluteString

        XCTAssertTrue(urlString.contains("api_key=abc123"))
        XCTAssertTrue(urlString.contains("search=Star%20Wars%20%26%20More"))
    }

    func test_urlBuilder_preservesBasePath() {
        let request = Request<Movie>(path: "search")
        let url = request.makeURLRequest(host: "https://example.com/api", apiKey: "k").url!

        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "example.com")
        XCTAssertEqual(url.path, "/api/search")
    }

    func test_path_isCorrectlyAppended() {
        let request = Request<Movie>(path: "abc")
        let url = request.makeURLRequest(host: "https://myapi.com", apiKey: "123").url!

        XCTAssertEqual(url.path, "/abc")
        XCTAssertTrue(url.query?.contains("api_key=123") ?? false)
    }
}
