import Foundation
import ImageGeneratorCore

/// View a generated image
///
/// Loads the data for a previously generated image so it can be viewed by the user. On success you
/// will receive the image data. On failure you will receive an error indicating why the image could
/// not be viewed.
public protocol ViewImageUseCase {
    /// Execute the use case
    /// - Parameters:
    ///   - imageId: Unique identifier for the image you wish to view.
    ///   - presenter: Delegate that implements the ```ViewImagePresenter``` protocol.
    func execute(imageId: String, presenter: ViewImagePresenter) async
}

public protocol ViewImagePresenter {
    /// Called when the use case begins loading the image.
    func isLoadingImage()

    /// Called after successfully loading the image data.
    func onImageLoaded(image: Data)
    
    /// Called if an error is encountered while trying to load the image data.
    func onError(error: Error)
}

public final class ViewImageInteractor: ViewImageUseCase {
    
    private let gateway: ViewImageGateway
    
    public init(gateway: ViewImageGateway) {
        self.gateway = gateway
    }
    
    public func execute(imageId: String, presenter: any ViewImagePresenter) async {
        do {
            let imageId = try GeneratedImageId.createAIImageId(for: imageId)
            presenter.isLoadingImage()
            let image = try await gateway.loadImage(imageId)
            presenter.onImageLoaded(image: image.content)
        } catch {
            presenter.onError(error: error)
        }
    }
}

public protocol ViewImageGateway {
    func loadImage(_ image: GeneratedImageId) async throws -> GeneratedImage
}
