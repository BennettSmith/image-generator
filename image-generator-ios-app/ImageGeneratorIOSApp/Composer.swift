import Foundation

import ImageGenerator
import ImageGeneratorInteractors
import ImageGeneratorRepositories

import OpenAIClient

protocol ImageGeneratorFactory {
    func makeGenerateImageUseCase() -> GenerateImageUseCase
    func makeViewImageUseCase() -> ViewImageUseCase
}

struct ProductionComposer: ImageGeneratorFactory {
    // Services
    let openAiClient: OpenAIClient
    
    // Repositories
    let imageRepository: InMemoryAIImageRepository
    
    init() {
        self.openAiClient = OpenAIClient(apiKey: "<API-KEY-GOES-HERE> ")
        self.imageRepository = InMemoryAIImageRepository()
    }
    
    func makeGenerateImageUseCase() -> any GenerateImageUseCase {
        let gateway = GenerateImageInteractor.Gateway(generateImage: { prompt in
            try await openAiClient.generateImage(prompt: prompt)
        }, downloadImage: { from in
            let (data, _) = try await URLSession.shared.data(from: from)
            return data
        }, saveImage: { image in
            try await imageRepository.save(image: image)
        })
        return GenerateImageInteractor(gateway: gateway)
    }
    
    func makeViewImageUseCase() -> any ViewImageUseCase {
        let gateway = ViewImageInteractor.Gateway(loadImage: { image in
            try await imageRepository.load(image: image)
        })
        return ViewImageInteractor(gateway: gateway)
    }
}
