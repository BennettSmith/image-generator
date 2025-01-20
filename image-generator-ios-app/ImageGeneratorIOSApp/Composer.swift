import ImageGeneratorApp

protocol ImageGeneratorFactory {
    func makeGenerateImageUseCase() -> GenerateImage
    func makeViewImageUseCase() -> ViewImage
}
