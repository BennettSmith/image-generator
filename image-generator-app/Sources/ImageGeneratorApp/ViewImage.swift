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
    public typealias Response = ViewImageResponse
    public typealias Presenter = Void
    
    private let gateway: ViewImageGateway
    
    public init(gateway: ViewImageGateway) {
        self.gateway = gateway
    }
    
    public func execute(request: Request, presenter: Presenter = Presenter()) async -> Result<Response, Error> {
        do {
            let imageId = try GeneratedImageId.createAIImageId(for: request.imageId)
            let image = try await gateway.loadImage(imageId)
            return .success(Response(imageId: imageId.description, image: image.content))
        } catch {
            return .failure(error)
        }
    }
}

public struct ViewImageRequest: Sendable {
    public let imageId: String
    public init(imageId: String) {
        self.imageId = imageId
    }
}

public struct ViewImageResponse: Sendable {
    public let imageId: String
    public let image: Data
    public init(imageId: String, image: Data) {
        self.imageId = imageId
        self.image = image
    }
}

public protocol ViewImagePresenter  {
    func onLoadImage(imageId: String)
    func onPresentImage(imageId: String, image: Data)
    func onError(error: Error)
}

public protocol ViewImageGateway {
    func loadImage(_ image: GeneratedImageId) async throws -> GeneratedImage
}

