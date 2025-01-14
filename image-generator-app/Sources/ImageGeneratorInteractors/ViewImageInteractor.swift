import Foundation

import ImageGeneratorUseCases
import ImageGeneratorCore

public class ViewImageInteractor: ViewImageUseCase {
    
    public struct Gateway {
        let loadImage: (_ image: AIImageId) async throws -> AIImage
        
        public init(loadImage: @escaping (_: AIImageId) async throws -> AIImage) {
            self.loadImage = loadImage
        }
    }
    
    private let gateway: Gateway
    
    public init(gateway: Gateway) {
        self.gateway = gateway
    }
    
    public func execute(imageId: String, presenter: any ViewImagePresenter) async {
        do {
            let imageId = try AIImageId.createAIImageId(for: imageId)
            presenter.isLoadingImage()
            let image = try await gateway.loadImage(imageId)
            presenter.onImageLoaded(image: image.content)
        } catch {
            presenter.onError(error: error)
        }
    }
}
