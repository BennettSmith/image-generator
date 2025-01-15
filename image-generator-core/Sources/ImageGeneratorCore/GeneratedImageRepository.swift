
import Foundation

public enum AIImageRepositoryError: Error {
    case notFound
}

public protocol GeneratedImageRepository {
    func delete(image: GeneratedImageId) async throws
    func deleteAll() async throws
    
    func load(image: GeneratedImageId) async throws -> GeneratedImage
    func loadAll() async throws -> [GeneratedImage]

    func save(image: GeneratedImage) async throws
}
