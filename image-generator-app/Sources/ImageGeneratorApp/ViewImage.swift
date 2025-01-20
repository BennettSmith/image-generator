import Foundation
import ImageGeneratorCore
import os.log

/// View a generated image
///
/// Loads the data for a previously generated image so it can be viewed by the user. On success you
/// will receive the image data. On failure you will receive an error indicating why the image could
/// not be viewed.
public struct ViewImage: UseCase {
    public typealias Request = ViewImageRequest
    public typealias Response = Void
    public typealias Presenter = ViewImagePresenter
    
    private let gateway: ViewImageGateway
    
    public init(gateway: ViewImageGateway) {
        self.gateway = gateway
    }
    
    public func execute(request: Request, presenter: Presenter) async -> Response {
        do {
            let imageId = try GeneratedImageId.createAIImageId(for: request.imageId)
            presenter.isLoadingImage()
            let image = try await gateway.loadImage(imageId)
            presenter.onImageLoaded(image: image.content)
        } catch {
            presenter.onError(error: error)
        }
    }
}

public struct ViewImageRequest {
    let imageId: String
    
    public init(imageId: String) {
        self.imageId = imageId
    }
}

public protocol ViewImagePresenter  {
    func isLoadingImage()
    func onImageLoaded(image: Data)
    func onError(error: Error)
}

public protocol ViewImageGateway {
    func loadImage(_ image: GeneratedImageId) async throws -> GeneratedImage
}

private struct LoggingPresenter: ViewImagePresenter {
    let logger: Logger = Logger(subsystem: "image-generator-app", category: "Presenter")

    func isLoadingImage() {
        logger.debug(">>> Loading image...")
    }
    
    func onImageLoaded(image: Data) {
        logger.debug(">>> Image loaded: (\(image.count) bytes)")
    }
    
    func onError(error: any Error) {
        logger.error(">>> Error: \(error)")
    }
}
