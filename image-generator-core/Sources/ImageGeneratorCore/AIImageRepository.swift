
import Foundation

public enum AIImageRepositoryError: Error {
    case notFound
}

public protocol AIImageRepository {
    func delete(image: AIImageId) async throws
    func deleteAll() async throws
    
    func load(image: AIImageId) async throws -> AIImage
    func loadAll() async throws -> [AIImage]

    func save(image: AIImage) async throws
}
