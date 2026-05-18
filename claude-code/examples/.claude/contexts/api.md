# Backend Context: NestJS API

## Module Structure

```
apps/api/src/
├── main.ts               # bootstrap, global pipes/filters
├── app.module.ts         # root module
├── auth/                 # JWT auth, guards, decorators
├── users/                # user entity + CRUD
├── common/
│   ├── decorators/       # @CurrentUser, @Roles
│   ├── filters/          # HttpExceptionFilter
│   ├── guards/           # JwtAuthGuard, RolesGuard
│   └── interceptors/     # LoggingInterceptor, TransformInterceptor
└── prisma/               # PrismaService
```

## Conventions

- **Controllers**: HTTP routing only — no business logic
- **Services**: all business logic lives here
- **DTOs**: validate all input with `class-validator`; use `@IsString()`, `@IsEmail()`, etc.
- **Guards**: auth via `JwtAuthGuard`; roles via `RolesGuard` + `@Roles()`
- **Error handling**: throw `HttpException` subclasses (`NotFoundException`, `UnauthorizedException`)

## Example Pattern

```ts
// controller — route + DTO only
@Post('users')
@UseGuards(JwtAuthGuard)
async create(@Body() dto: CreateUserDto, @CurrentUser() user: User) {
  return this.usersService.create(dto, user);
}

// service — business logic
async create(dto: CreateUserDto, actor: User): Promise<User> {
  await this.checkUniqueEmail(dto.email);
  return this.prisma.user.create({ data: dto });
}
```

## Anti-Patterns

- 🚫 Business logic in controllers
- 🚫 Raw SQL queries outside PrismaService wrapper
- 🚫 Skipping DTO validation (any `any` type)
- 🚫 Circular module imports
