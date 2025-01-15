import Foundation

import ImageGeneratorUseCases
import ImageGeneratorCore

public class ViewImageInteractor: ViewImageUseCase {
    
    public struct Gateway {
        let loadImage: (_ image: GeneratedImageId) async throws -> GeneratedImage
        
        public init(loadImage: @escaping (_: GeneratedImageId) async throws -> GeneratedImage) {
            self.loadImage = loadImage
        }
    }
    
    private let gateway: Gateway
    
    public init(gateway: Gateway) {
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
