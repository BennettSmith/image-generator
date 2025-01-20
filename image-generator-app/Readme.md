
# Using `async` Use Cases

## Pros:

* Simplicity: The Use Case can directly interact with asynchronous repositories without additional abstractions.
* Modern Conventions: Embracing async/await directly simplifies the flow of asynchronous operations in Swift, making it easier to reason about.
* Consistency: Since repositories are inherently asynchronous (e.g., API calls or database queries), aligning the Use Case with this reality avoids unnecessary complexity.

## Cons:

* Tight Coupling: The Use Case layer becomes coupled to Swift's concurrency model, making it less portable to environments that don't support async/await (e.g., if you wanted to port the logic to a non-Swift environment).
* Testing Complexity: Writing synchronous unit tests for Use Cases becomes harder because you'll need to deal with async test utilities or mocking.
