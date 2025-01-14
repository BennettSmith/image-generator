import Foundation
import ImageGeneratorRepositories
import OpenAIClient
import ImageGeneratorInteractors
import ImageGeneratorUseCases

struct ProductionComposer: ImageGeneratorFactory {
    // Services
    let openAiClient: OpenAIClient
    
    // Repositories
    let imageRepository: InMemoryAIImageRepository
    
    init(openAiAPIKey: String = "<missing-key>") {
        self.openAiClient = OpenAIClient(apiKey: openAiAPIKey)
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
        return GenerateImageInteractor(gateway: gateway) as GenerateImageUseCase
    }
    
    func makeViewImageUseCase() -> any ViewImageUseCase {
        let gateway = ViewImageInteractor.Gateway(loadImage: { image in
            try await imageRepository.load(image: image)
        })
        return ViewImageInteractor(gateway: gateway) as ViewImageUseCase
    }
}
