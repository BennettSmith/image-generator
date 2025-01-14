import Foundation

import ImageGenerator
import ImageGeneratorCore

public class GenerateImageInteractor: GenerateImageUseCase {
    
    public struct Gateway {
        let generateImage: (_ prompt: String) async throws -> URL
        let downloadImage: (_ from: URL) async throws -> Data
        let saveImage: (_ image: AIImage) async throws -> Void
        
        public init(generateImage: @escaping (_: String) async throws -> URL, downloadImage: @escaping (_: URL) async throws -> Data, saveImage: @escaping (_: AIImage) async throws -> Void) {
            self.generateImage = generateImage
            self.downloadImage = downloadImage
            self.saveImage = saveImage
        }
    }
    
    private let gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }

    public func execute(prompt: String, presenter: any GenerateImagePresenter) async {
        do {
            presenter.isGeneratingImage()
            let remoteImageUrl = try await gateway.generateImage(prompt)
            
            presenter.isDownloadingImage()
            let imageData = try await gateway.downloadImage(remoteImageUrl)
            
            let imageId = try AIImageId.newAIImageId()
            let image = AIImage(id: imageId, prompt: prompt, whenGenerated: .now, content: imageData)
            try await gateway.saveImage(image)
            
            presenter.onImageGenerated(imageId: String(describing: imageId))
        } catch {
            presenter.onError(error: error)
        }
    }
}
