
import Testing
import ImageGeneratorCore

@Test func creatingIdFromInvalidStringThrowsError() {
    #expect(throws: AIImageIdError.invalidValue) {
        try AIImageId.createAIImageId(for: "invalid")
    }
}

@Test func makingNewIdWorks() throws {
    _ = try AIImageId.newAIImageId()
}

@Test func uppercaseIdHasCorrectStringValue() throws {
    let knownId = try AIImageId.createAIImageId(for: "28C5F171-B95F-4C07-8ED9-D01044C3B3DB")
    #expect(knownId.description == "28C5F171-B95F-4C07-8ED9-D01044C3B3DB")
}

@Test func lowercaseIdHasCorrectStringValue() throws {
    let knownId = try AIImageId.createAIImageId(for: "28c5f171-b95f-4c07-8ed9-d01044c3b3db")
    #expect(knownId.description == "28C5F171-B95F-4C07-8ED9-D01044C3B3DB")
}

@Test func equalValuesCompareEqual() throws {
    let id1 = try AIImageId.createAIImageId(for: "28c5f171-b95f-4c07-8ed9-d01044c3b3db")
    let id2 = try AIImageId.createAIImageId(for: "28c5f171-b95f-4c07-8ed9-d01044c3b3db")
    #expect(id1 == id2)
}

@Test func unequalValuesCompareNotEqual() throws {
    let id1 = try AIImageId.newAIImageId()
    let id2 = try AIImageId.newAIImageId()
    #expect(id1 != id2)
}
