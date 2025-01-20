
import SwiftUI

import ImageGeneratorApp

struct ContentView: View {
    
    enum FetchPhase: Equatable {
        case initial
        case loading
        case loaded(String, Image)
        case failure(String)
    }

    final class Presenter: GenerateImagePresenter, ViewImagePresenter {
        private var continuation: AsyncThrowingStream<FetchPhase, Error>.Continuation?
        
        func stream() -> AsyncThrowingStream<FetchPhase, Error> {
            AsyncThrowingStream { continuation in
                self.continuation = continuation
            }
        }
        
        func onRequestImageGeneration() {
            continuation?.yield(.loading)
        }
        
        func onRequestImageDownload() {
            continuation?.yield(.loading)
        }
        
        func onPresentImage(imageId: String, image: Data) {
            guard let image = UIImage(data: image) else {
                continuation?.yield(.failure("Failed to download image"))
                continuation?.finish()
                return
            }
            continuation?.yield(.loaded(imageId, Image(uiImage: image)))
        }
        
        func onLoadImage(imageId: String) {
            continuation?.yield(.loading)
        }
        
        func onError(error: any Error) {
            continuation?.yield(.failure(error.localizedDescription))
            continuation?.finish()
        }
    }
    
    @Observable
    final class ViewModel {
        var generateImageUseCase: GenerateImage
        var viewImageUseCase: ViewImage
        var fetchPhase: FetchPhase
        var prompt: String

        init(factory: ImageGeneratorFactory, fetchPhase: FetchPhase, prompt: String) {
            self.generateImageUseCase = factory.makeGenerateImageUseCase()
            self.viewImageUseCase = factory.makeViewImageUseCase()
            self.fetchPhase = fetchPhase
            self.prompt = prompt
        }
        
        var disablePromptEntry: Bool {
            fetchPhase == .loading
        }
        
        var disableImageGeneration: Bool {
            fetchPhase == .loading || prompt.isEmpty
        }
        
        @MainActor
        func generateImage() {
            Task {
                do {
                    let request = GenerateImage.Request(prompt: prompt)
                    let presenter = Presenter()
                    
                    // Start execution of the use case.
                    async let useCaseExecution: Result<GenerateImage.Response, Error> = generateImageUseCase.execute(request: request, presenter: presenter)

                    // Start consuming the stream from the presenter (concurrent with use case execution)
                    for try await phase in presenter.stream() {
                        self.fetchPhase = phase
                    }

                    // Await the completion of the use case (in this case the result is Void)
                    let result: Result<GenerateImage.Response, Error> = await useCaseExecution
                } catch {
                    self.fetchPhase = .failure(error.localizedDescription)
                }
            }
        }
        
        func viewImage(imageId: String) {
            Task {
                let request = ViewImage.Request(imageId: imageId)
                let result = await viewImageUseCase.execute(request: request)
                switch result {
                case .success(let response):
                    guard let image = UIImage(data: response.image) else {
                        self.fetchPhase = .failure("Failed to load image.")
                        return
                    }
                    self.fetchPhase = .loaded(response.imageId, Image(uiImage: image))
                case .failure(let error):
                    self.fetchPhase = .failure(error.localizedDescription)
                }
            }
        }
    }

    @State private var viewModel: ViewModel

    init(factory: ImageGeneratorFactory) {
        self.viewModel = ViewModel(factory: factory, fetchPhase: .initial, prompt: "")
    }

    var body: some View {
        VStack(spacing: 16) {
            switch viewModel.fetchPhase {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView("Requesting an AI image")
            case .loaded(let imageId, let image):
                image.resizable().scaledToFit()
            case .failure(let error):
                Text(error).foregroundStyle(Color.red)
            }
            
            TextField("Enter prompt", text: $viewModel.prompt, prompt: Text("Enter prompt"), axis: .vertical)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.disablePromptEntry)
            
            Button("Generate Image") {
                viewModel.generateImage()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.disableImageGeneration)
        }
        .padding()
        .navigationTitle(Text("Clean Image Generator"))
    }
}

#Preview {
    NavigationStack {
        ContentView(factory: ProductionComposer())
    }
}
