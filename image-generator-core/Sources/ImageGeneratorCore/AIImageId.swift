
import Foundation

public enum AIImageIdError: Error {
    case invalidValue
}

public struct AIImageId: Equatable, Hashable {
    private typealias ValueType = UUID
    private typealias Validator = (UUID) throws -> Void
    private let value: ValueType
    private init(_ value: ValueType, validator: @escaping Validator = { _ in }) throws {
        try validator(value)
        self.value = value
    }
    
    public static func createAIImageId(for value: String) throws -> AIImageId {
        guard let value = UUID(uuidString: value) else {
            throw AIImageIdError.invalidValue
        }
        return try AIImageId(value)
    }
    
    public static func newAIImageId() throws -> AIImageId {
        try AIImageId(UUID())
    }
}

extension AIImageId: CustomStringConvertible {
    public var description: String {
        return value.uuidString
    }
}
