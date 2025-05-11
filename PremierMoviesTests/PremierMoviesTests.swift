@testable import PremierMovies
import XCTest

struct DummyResponse: Codable, Equatable {
    let id: Int
    let name: String
}

struct DummyModel: Codable, Equatable {
    let id: Int
    let title: String
}

extension DummyModel {
    static var dummyRequest: Request<DummyModel> {
        Request(
            method: .get,
            path: "dummy"
        )
    }
}

final class MockSession: URLSessionProtocol {
    let data: Data
    let response: URLResponse

    init(data: Data, statusCode: Int = 200) {
        self.data = data
        response = HTTPURLResponse(
            url: URL(string: "https://api.themoviedb.org/3/dummy")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    func data(for _: URLRequest) async throws -> (Data, URLResponse) {
        return (data, response)
    }
}

final class MockCache: CacheProtocol {
    private var store: [String: Data] = [:]

    func get(for request: URLRequest) -> Data? {
        store[request.url!.absoluteString]
    }

    func set(_ data: Data, for request: URLRequest, ttl _: TimeInterval?) {
        store[request.url!.absoluteString] = data
    }
}

final class APIServiceTests: XCTestCase {
    func test_execute_returnsDataFromNetwork() async throws {
        let expected = DummyModel(id: 1, title: "FromNetwork")
        let data = try JSONEncoder().encode(expected)

        let api = APIService(
            session: MockSession(data: data),
            cache: MockCache()
        )

        let result: DummyModel = try await api.execute(DummyModel.dummyRequest, cachePolicy: .reloadIgnoringCache)
        XCTAssertEqual(result, expected)
    }

    func test_execute_returnsDataFromCache() async throws {
        let expected = DummyModel(id: 123, title: "FromNetwork")
        let data = try JSONEncoder().encode(expected)

        let api = APIService(
            session: MockSession(data: data),
            cache: MockCache()
        )

        let result: DummyModel = try await api.execute(DummyModel.dummyRequest)
        XCTAssertEqual(result, expected)
    }

    func test_execute_throwsOnBadStatusCode() async {
        let api = APIService(
            session: MockSession(data: Data(), statusCode: 500),
            cache: MockCache()
        )

        do {
            _ = try await api.execute(DummyModel.dummyRequest)
            XCTFail("Expected to throw, but succeeded")
        } catch {
            XCTAssertTrue(error is NetworkError, "Unexpected error: \(error)")
        }
    }
}
