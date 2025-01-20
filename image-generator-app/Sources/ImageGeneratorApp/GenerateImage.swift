import Foundation
import ImageGeneratorCore

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
    
    public func execute(request: Request, presenter: Presenter) async -> Result<Response, Error> {
        do {
            presenter.onRequestImageGeneration()
            let remoteImageUrl = try await gateway.generateImage(request.prompt)
            
            presenter.onRequestImageDownload()
            let imageData = try await gateway.downloadImage(remoteImageUrl)
            
            let imageId = try GeneratedImageId.newAIImageId()
            let image = GeneratedImage(id: imageId, prompt: request.prompt, whenGenerated: .now, content: imageData)
            try await gateway.saveImage(image)
            
            presenter.onPresentImage(imageId: String(describing: imageId), image: imageData)
            return .success(Response())
        } catch {
            presenter.onError(error: error)
            return .failure(error)
        }
    }
}

public struct GenerateImageRequest: Sendable {
    let prompt: String
    
    public init(prompt: String) {
        self.prompt = prompt
    }
}

public protocol GenerateImagePresenter {
    func onRequestImageGeneration()
    func onRequestImageDownload()
    func onPresentImage(imageId: String, image: Data)
    func onError(error: Error)
}

public protocol GenerateImageGateway {
    func generateImage(_ prompt: String) async throws -> URL
    func downloadImage(_ from: URL) async throws -> Data
    func saveImage(_ image: GeneratedImage) async throws -> Void
}

