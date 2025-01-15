
import Foundation
import ImageGeneratorCore

public class InMemoryGeneratedImageRepository {
    private var images: [GeneratedImageId: GeneratedImage] = [:]
    
    public init() {}
}

extension InMemoryGeneratedImageRepository: GeneratedImageRepository {
    public func delete(image: GeneratedImageId) async throws {
        guard let _ = images.removeValue(forKey: image) else {
            throw AIImageRepositoryError.notFound
        }
    }
    
    public func deleteAll() async throws {
        images.removeAll()
    }
    
    public func load(image: GeneratedImageId) async throws -> GeneratedImage {
        if let image = images[image] {
            return image
        } else {
            throw AIImageRepositoryError.notFound
        }
    }
    
    public func loadAll() async throws -> [GeneratedImage] {
        images.values.map { image in image }
    }
    
    public func save(image: GeneratedImage) async throws {
        images[image.id] = image
    }
}
