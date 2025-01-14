
import Foundation
import ImageGeneratorCore

public class InMemoryAIImageRepository {
    private var images: [AIImageId: AIImage] = [:]
    
    public init() {}
}

extension InMemoryAIImageRepository: AIImageRepository {
    public func delete(image: AIImageId) async throws {
        guard let _ = images.removeValue(forKey: image) else {
            throw AIImageRepositoryError.notFound
        }
    }
    
    public func deleteAll() async throws {
        images.removeAll()
    }
    
    public func load(image: AIImageId) async throws -> AIImage {
        if let image = images[image] {
            return image
        } else {
            throw AIImageRepositoryError.notFound
        }
    }
    
    public func loadAll() async throws -> [AIImage] {
        images.values.map { image in image }
    }
    
    public func save(image: AIImage) async throws {
        images[image.id] = image
    }
}
