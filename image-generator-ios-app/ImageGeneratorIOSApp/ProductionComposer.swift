import Foundation
import OpenAIClient
import ImageGeneratorApp
import ImageGeneratorCore
import ImageGeneratorRepositories

struct ProductionComposer: ImageGeneratorFactory {
    // Services
    let openAiClient: OpenAIClient
    
    // Repositories
    let imageRepository: InMemoryGeneratedImageRepository
    
    init(openAiAPIKey: String = "<missing-key>") {
        self.openAiClient = OpenAIClient(apiKey: openAiAPIKey)
        self.imageRepository = InMemoryGeneratedImageRepository()
    }
    
    func makeGenerateImageUseCase() -> any GenerateImageUseCase {
        return GenerateImageInteractor(gateway: self) as GenerateImageUseCase
    }
    
    func makeViewImageUseCase() -> any ViewImageUseCase {
        return ViewImageInteractor(gateway: self) as ViewImageUseCase
    }
}

extension ProductionComposer: GenerateImageGateway {
    func generateImage(_ prompt: String) async throws -> URL {
        try await openAiClient.generateImage(prompt: prompt)
    }
    
    func downloadImage(_ from: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: from)
        return data
    }
    
    func saveImage(_ image: ImageGeneratorCore.GeneratedImage) async throws {
        try await imageRepository.save(image: image)
    }
}

extension ProductionComposer: ViewImageGateway {
    func loadImage(_ image: ImageGeneratorCore.GeneratedImageId) async throws -> ImageGeneratorCore.GeneratedImage {
        try await imageRepository.load(image: image)
    }
}
