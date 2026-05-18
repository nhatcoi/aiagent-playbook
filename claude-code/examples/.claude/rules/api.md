# API Rules: NestJS

These rules apply when working in `apps/api/`.

## Controller Rules

- Controllers own routing and input parsing only
- Delegate all logic to the service layer
- Every endpoint must be guarded — no public endpoints without `@Public()` decorator explicitly
- Use `@ApiOperation()` and `@ApiResponse()` for Swagger on every endpoint

## Service Rules

- Services must be stateless — no class-level mutable state
- Never call another module's repository directly — go through that module's service
- Throw `HttpException` subclasses, not generic `Error`

## DTO Rules

- All request bodies must use a DTO class with `class-validator` decorators
- `@IsOptional()` before nullable fields
- `@Transform()` for type coercion (e.g., string → number from query params)
- `@Exclude()` on response DTOs for sensitive fields (passwords, tokens)

## Dependency Injection

- Register all providers in the module's `providers` array
- Never use `new ServiceClass()` directly — always inject
- Circular dependencies: refactor to extract shared logic into a `common` module

## Response Shape

All API responses follow this envelope:

```ts
{ data: T, meta?: { page, total } }
```

Errors follow NestJS default `HttpException` shape — do not override the global filter.
