import Foundation
import ImageGeneratorCore
import os.log

/// Generate Image
///
/// Requests an AI image generator to produce an image based on a prompt. The generated
/// image is stored locally. On success you will receive the image identfier as well as the location
/// of the image content. On failure you will receive an error.
public struct GenerateImage: UseCase {
    
    public typealias Request = GenerateImageRequest
    public typealias Response = Void
    public typealias Presenter = GenerateImagePresenter
    
    private let gateway: GenerateImageGateway
    
    public init(gateway: GenerateImageGateway) {
        self.gateway = gateway
    }
    
    public func execute(request: Request, presenter: Presenter) async -> Response {
        do {
            presenter.isGeneratingImage()
            let remoteImageUrl = try await gateway.generateImage(request.prompt)
            
            presenter.isDownloadingImage()
            let imageData = try await gateway.downloadImage(remoteImageUrl)
            
            let imageId = try GeneratedImageId.newAIImageId()
            let image = GeneratedImage(id: imageId, prompt: request.prompt, whenGenerated: .now, content: imageData)
            try await gateway.saveImage(image)
            
            presenter.onImageGenerated(imageId: String(describing: imageId))
        } catch {
            presenter.onError(error: error)
        }
    }
}

public struct GenerateImageRequest {
    let prompt: String
    
    public init(prompt: String) {
        self.prompt = prompt
    }
}

public protocol GenerateImagePresenter {
    func isGeneratingImage()
    func isDownloadingImage()
    func onImageGenerated(imageId: String)
    func onError(error: Error)
}

public protocol GenerateImageGateway {
    func generateImage(_ prompt: String) async throws -> URL
    func downloadImage(_ from: URL) async throws -> Data
    func saveImage(_ image: GeneratedImage) async throws -> Void
}

private struct LoggingPresenter: GenerateImagePresenter {
    let logger: Logger = Logger(subsystem: "image-generator-app", category: "Presenter")
    
    func isGeneratingImage() {
        logger.debug(">>> Generating image...")
    }
    
    func isDownloadingImage() {
        logger.debug(">>> Downloading image...")
    }
    
    func onImageGenerated(imageId: String) {
        logger.debug(">>> Image generated: \(imageId)")
    }
    
    func onError(error: any Error) {
        logger.error(">>> Error: \(error)")
    }
}
