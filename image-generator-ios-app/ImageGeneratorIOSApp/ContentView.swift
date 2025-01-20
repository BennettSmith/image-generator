
import SwiftUI

import ImageGeneratorApp

struct ContentView: View {
    
    enum FetchPhase: Equatable {
        case initial
        case loading
        case success(Image)
        case failure(String)
    }

    @Observable
    final class ViewModel: GenerateImagePresenter, ViewImagePresenter {
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
        
        func generateImage() {
            Task {
                let request = GenerateImage.Request(prompt: prompt)
                await generateImageUseCase.execute(request: request, presenter: self)
            }
        }
        
        func isGeneratingImage() {
            fetchPhase = .loading
        }
        
        func isDownloadingImage() {
            fetchPhase = .loading
        }
        
        func onImageGenerated(imageId: String) {
            Task {
                let request = ViewImage.Request(imageId: imageId)
                await viewImageUseCase.execute(request: request, presenter: self)
            }
        }
        
        func onError(error: any Error) {
            fetchPhase = .failure(error.localizedDescription)
        }
        
        func isLoadingImage() {
            fetchPhase = .loading
        }
        
        func onImageLoaded(image: Data) {
            guard let image = UIImage(data: image) else {
                self.fetchPhase = .failure("Failed to download image")
                return
            }
            self.fetchPhase = .success(Image(uiImage: image))
        }
    }

    @State private var viewModel: ViewModel

    init(factory: ImageGeneratorFactory) {
        self.viewModel = ViewModel(factory: factory, fetchPhase: .initial, prompt: "")
    }

    var body: some View {
        VStack(spacing: 16) {
            switch viewModel.fetchPhase {
            case .loading: ProgressView("Requesting an AI image")
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure(let error):
                Text(error).foregroundStyle(Color.red)
            case .initial:
                EmptyView()
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
