import Foundation

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
