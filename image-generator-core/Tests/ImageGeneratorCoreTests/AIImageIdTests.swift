
import Testing
import ImageGeneratorCore

@Test func creatingIdFromInvalidStringThrowsError() {
    #expect(throws: AIImageIdError.invalidValue) {
        try GeneratedImageId.createAIImageId(for: "invalid")
    }
}

@Test func makingNewIdWorks() throws {
    _ = try GeneratedImageId.newAIImageId()
}

@Test func uppercaseIdHasCorrectStringValue() throws {
    let knownId = try GeneratedImageId.createAIImageId(for: "28C5F171-B95F-4C07-8ED9-D01044C3B3DB")
    #expect(knownId.description == "28C5F171-B95F-4C07-8ED9-D01044C3B3DB")
}

@Test func lowercaseIdHasCorrectStringValue() throws {
    let knownId = try GeneratedImageId.createAIImageId(for: "28c5f171-b95f-4c07-8ed9-d01044c3b3db")
    #expect(knownId.description == "28C5F171-B95F-4C07-8ED9-D01044C3B3DB")
}

@Test func equalValuesCompareEqual() throws {
    let id1 = try GeneratedImageId.createAIImageId(for: "28c5f171-b95f-4c07-8ed9-d01044c3b3db")
    let id2 = try GeneratedImageId.createAIImageId(for: "28c5f171-b95f-4c07-8ed9-d01044c3b3db")
    #expect(id1 == id2)
}

@Test func unequalValuesCompareNotEqual() throws {
    let id1 = try GeneratedImageId.newAIImageId()
    let id2 = try GeneratedImageId.newAIImageId()
    #expect(id1 != id2)
}
