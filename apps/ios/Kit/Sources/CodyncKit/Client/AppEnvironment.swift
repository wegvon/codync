import Foundation

/// Read from the containing app or extension, so the shared package follows its build configuration.
public enum AppEnvironment: String, Sendable {
    case main
    case dev

    public static let current = AppEnvironment(
        rawValue: Bundle.main.object(forInfoDictionaryKey: "CodyncEnvironment") as? String ?? "main"
    ) ?? .main

    public var appGroup: String { Self.info("CodyncAppGroup") ?? (self == .dev ? "group.com.pokai.Codync.dev" : "group.com.pokai.Codync") }
    public var urlScheme: String { Self.info("CodyncURLScheme") ?? (self == .dev ? "codync-dev" : "codync") }

    /// A build setting the target's Info.plist carries (a fork sets its own); nil when unset.
    static func info(_ key: String) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty, !value.hasPrefix("$(") else { return nil }
        return value
    }

    public func link(_ destination: String) -> URL {
        // All callers supply a fixed app route.
        URL(string: "\(urlScheme)://\(destination)")!
    }
}
