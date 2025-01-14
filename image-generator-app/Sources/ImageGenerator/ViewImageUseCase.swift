import Foundation

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
