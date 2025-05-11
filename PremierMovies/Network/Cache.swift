import Foundation

enum CachePolicy {
    case useCacheIfAvailable
    case reloadIgnoringCache
    case returnCacheThenLoad
}

protocol CacheProtocol {
    func get(for request: URLRequest) -> Data?
    func set(_ data: Data, for request: URLRequest, ttl: TimeInterval?)
}

final class Cache: CacheProtocol {
    private class CacheEntry {
        let data: Data
        let expiryDate: Date

        init(data: Data, ttl: TimeInterval) {
            self.data = data
            expiryDate = Date().addingTimeInterval(ttl)
        }

        var isExpired: Bool {
            return Date() > expiryDate
        }
    }

    private let cache = NSCache<NSString, CacheEntry>()
    private let defaultTTL: TimeInterval

    init(defaultTTL: TimeInterval = 300) {
        self.defaultTTL = defaultTTL
    }

    private func key(for request: URLRequest) -> NSString? {
        request.url?.absoluteString as NSString?
    }

    func get(for request: URLRequest) -> Data? {
        guard let key = key(for: request),
              let entry = cache.object(forKey: key),
              !entry.isExpired
        else {
            return nil
        }
        return entry.data
    }

    func set(_ data: Data, for request: URLRequest, ttl: TimeInterval? = nil) {
        guard let key = key(for: request) else { return }
        let entry = CacheEntry(data: data, ttl: ttl ?? defaultTTL)
        cache.setObject(entry, forKey: key)
    }
}
