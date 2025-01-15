
import Foundation

public enum AIImageIdError: Error {
    case invalidValue
}

public struct GeneratedImageId: Equatable, Hashable {
    private typealias ValueType = UUID
    private typealias Validator = (UUID) throws -> Void
    private let value: ValueType
    private init(_ value: ValueType, validator: @escaping Validator = { _ in }) throws {
        try validator(value)
        self.value = value
    }
    
    public static func createAIImageId(for value: String) throws -> GeneratedImageId {
        guard let value = UUID(uuidString: value) else {
            throw AIImageIdError.invalidValue
        }
        return try GeneratedImageId(value)
    }
    
    public static func newAIImageId() throws -> GeneratedImageId {
        try GeneratedImageId(UUID())
    }
}

extension GeneratedImageId: CustomStringConvertible {
    public var description: String {
        return value.uuidString
    }
}
