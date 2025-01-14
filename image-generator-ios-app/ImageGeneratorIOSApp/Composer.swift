import ImageGeneratorUseCases

protocol ImageGeneratorFactory {
    func makeGenerateImageUseCase() -> GenerateImageUseCase
    func makeViewImageUseCase() -> ViewImageUseCase
}

