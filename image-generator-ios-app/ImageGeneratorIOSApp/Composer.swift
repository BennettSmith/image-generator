import ImageGeneratorApp

protocol ImageGeneratorFactory {
    func makeGenerateImageUseCase() -> GenerateImageUseCase
    func makeViewImageUseCase() -> ViewImageUseCase
}
