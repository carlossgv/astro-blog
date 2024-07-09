---
id: jest-presentaton-post
aliases:
  - Unit Testing with Jest
tags: []
author: Carlos G.
description: ""
featured: false
modDatetime: 2024-07-08T16:10:04.000Z
pubDatetime: 2024-07-08T16:10:04.000Z
title: Unit Testing With Jest
---


# Unit Testing with Jest

Links:
[My Jest Workflow](1-projects/jest-presentation/1720096523-my-jest-workflow.md)
[Jest Typing with TS](1-projects/jest-presentation/1720096529-jest-typing-with-ts.md)
[Jest Docs](https://jestjs.io/docs/getting-started)

Promotions Types:
if nominalDiscountType is `cart` && nominalDiscount > 0: ignore the promotion

TODOS:
- [ ] Check jwt.sign mock with wrong overload (needs string response but detects void). UPDATE: apparently mockImplementation works.
- [ ] Create a case for error handling
- [ ] Class mocking
- [ ] Partial module mocking
- [ ] How to proper test with Typescript (jest.Mock<...>) 
- [ ] [Test This](1-projects/jest-presentation/1720016366-CANK.md)
- [ ] Check [jest-platform](https://jestjs.io/docs/jest-platform) functions.

## Typescript

### Mock Interface or Object
```typescript
let promotionsRepository: jest.Mocked<IPromotionsRepository>;

 promotionsRepository = {
   getPromotions: jest.fn()
 }; // if you need only partial mock, here should be parsed `as unknown as jest.Mocked<IPromotionsRepository>`

promotionsRepository.getPromotions.mockResolvedValue({
  promotions: 'promotions',
  updateDate: 'updateDate',
} as unknown as PromotionsObject);
```

### Mock Module

```typescript
import axios from "axios";
jest.mock("axios");
const axiosMock: jest.Mocked<typeof axios> = axios as jest.Mocked<typeof axios>;
```

### Mock private methods
TODO! (Use brackets notation)

## TDD

## Assertions

### Matchers
[Complete list](https://jestjs.io/docs/expect)

## Properties

> NOTE: `it` and `test` works the same.

- `it.only`: run only this test in the file.
- `it.skip`: skip this test
- `it.todo`: mark this test as a todo. Useful when doing TDD, you can define everything your code should do and then implement it one by one.
- `it.each`: runs the test one time with each set of data. Useful when need to test same method many time.

```typescript
test.each([
  { a: 1, b: 1, expected: 2 }, // expected can change in each test like this, or define it once before.
  { a: 1, b: 2, expected: 3 },
  { a: 2, b: 1, expected: 3 },
])('.add($a, $b)', ({ a, b, expected }) => { // It can use `printf` formatting.
  expect(a + b).toBe(expected);
});
```

## Structure

- Hooks (`beforeEach`, `afterEach`, `beforeAll`, etc) can be placed in root level, this will affect all the tests within a file. If scoped inside a `describe`, it will only affect the tests within that `describe`.

## Testing errors

In async code using `async/await`, you should always use `expect.assertions(number)` to make sure the test do the assertions. If you don't do this, the test may pass because it won't enter the `catch` block.

## Order of execution

Jest will run all of the `describes` first; afterwards, it will run all of the `tests` in the order they are defined. This makes the hooks even more important.

## Jest Mock Functions

- `jest.fn()`: creates a mock function.
- `jest.fn().mock.calls`: array of calls made to the mock function.
- `jest.fn().mock.calls[x][y]`: x is the call number, y is the argument number.
- You can assign names to the mock funtion by using `jest.fn().mockName('name')`. This will help you identify the mock function in the test results.
- There are sugars for `jest.fn()` like `jest.fn().mockReturnValue(value)`, `jest.fn().mockResolvedValue(value)`, `jest.fn().mockRejectedValue(value)`, etc. Which will be the same as `jest.fn().mockImplementation(() => value)`. 


## Jest Mock Modules

- TODO: check partial modules mocking [here](https://jestjs.io/docs/mock-functions#mocking-partials).

## My Workflow

When developing, I usually run the test command like this:
```bash
<test command> --watch --coverage=false <file name>
```

The `watch` flag will make the tests to wait for changes, so you don't have to run them each time you make a change.
The `coverage=false` flag prevents the coverage report to be printed, this way it's easier to check the logs from the test. Coverage can be checked when running all tests.
