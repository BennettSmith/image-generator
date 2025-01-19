
import SwiftUI

import ImageGeneratorApp

struct ContentView: View {
    
    enum FetchPhase: Equatable {
        case initial
        case loading
        case success(Image)
        case failure(String)
    }
    
    @State var fetchPhase: FetchPhase = .initial
    @State var prompt: String = ""
    
    let factory: ImageGeneratorFactory
    
    private let generateImageUseCase: GenerateImageUseCase
    private let viewImageUseCase: ViewImageUseCase
    
    init(factory: ImageGeneratorFactory) {
        self.factory = factory
        self.generateImageUseCase = factory.makeGenerateImageUseCase()
        self.viewImageUseCase = factory.makeViewImageUseCase()
    }

    var body: some View {
        VStack(spacing: 16) {
            switch fetchPhase {
            case .loading: ProgressView("Requesting an AI image")
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure(let error):
                Text(error).foregroundStyle(Color.red)
            case .initial:
                EmptyView()
            }
            
            TextField("Enter prompt", text: $prompt, prompt: Text("Enter prompt"), axis: .vertical)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .disabled(fetchPhase == .loading)
            
            Button("Generate Image") {
                Task {
                    await generateImageUseCase.execute(prompt: prompt, presenter: self)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(fetchPhase == .loading || prompt.isEmpty)
        }
        .padding()
        .navigationTitle(Text("Clean Image Generator"))
    }
}

extension ContentView: GenerateImagePresenter {
    func isGeneratingImage() {
        fetchPhase = .loading
    }
    
    func isDownloadingImage() {
        fetchPhase = .loading
    }
    
    func onImageGenerated(imageId: String) {
        Task {
            await viewImageUseCase.execute(imageId: imageId, presenter: self)
        }
    }
    
    func onError(error: any Error) {
        fetchPhase = .failure(error.localizedDescription)
    }
}

extension ContentView: ViewImagePresenter {
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

#Preview {
    NavigationStack {
        ContentView(factory: ProductionComposer())
    }
}
