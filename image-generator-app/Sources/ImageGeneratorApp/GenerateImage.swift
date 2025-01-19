import Foundation
import ImageGeneratorCore

/// Generate Image
///
/// Requests an AI image generator to produce an image based on a prompt. The generated
/// image is stored locally. On success you will receive the image identfier as well as the location
/// of the image content. On failure you will receive an error.
public protocol GenerateImageUseCase {
    func execute(prompt: String, presenter: GenerateImagePresenter) async
}

/// Presenter for GenerateImage use case
public protocol GenerateImagePresenter {
    /// Called when the use case makes the request to generate the image.
    func isGeneratingImage()
    
    /// Called when the use case downloads the generated image from the AI image generator's cloud.
    func isDownloadingImage()
    
    /// Called when the image is available to display.
    func onImageGenerated(imageId: String)
    
    /// Called if there is an execution error.
    func onError(error: Error)
}

public final class GenerateImageInteractor: GenerateImageUseCase {
    private let gateway: GenerateImageGateway
    
    public init(gateway: GenerateImageGateway) {
        self.gateway = gateway
    }

    public func execute(prompt: String, presenter: any GenerateImagePresenter) async {
        do {
            presenter.isGeneratingImage()
            let remoteImageUrl = try await gateway.generateImage(prompt)
            
            presenter.isDownloadingImage()
            let imageData = try await gateway.downloadImage(remoteImageUrl)
            
            let imageId = try GeneratedImageId.newAIImageId()
            let image = GeneratedImage(id: imageId, prompt: prompt, whenGenerated: .now, content: imageData)
            try await gateway.saveImage(image)
            
            presenter.onImageGenerated(imageId: String(describing: imageId))
        } catch {
            presenter.onError(error: error)
        }
    }
}

public protocol GenerateImageGateway {
    func generateImage(_ prompt: String) async throws -> URL
    func downloadImage(_ from: URL) async throws -> Data
    func saveImage(_ image: GeneratedImage) async throws -> Void
}
