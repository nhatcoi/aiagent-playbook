---
name: api-scaffold
description: Generates a complete NestJS module scaffold (module + controller + service + DTO + spec). Triggers on "scaffold module X", "generate NestJS module", "create API for X".
---

# API Scaffold Plugin

Generates a standard NestJS CRUD module following project conventions.

## Input

User provides: **resource name** (e.g., `product`, `order`, `invoice`)

## Output Files Generated

```
apps/api/src/<resource>/
├── <resource>.module.ts
├── <resource>.controller.ts
├── <resource>.service.ts
├── dto/
│   ├── create-<resource>.dto.ts
│   └── update-<resource>.dto.ts
└── <resource>.service.spec.ts
```

## Template

### module
```ts
@Module({
  controllers: [<Resource>Controller],
  providers: [<Resource>Service],
  exports: [<Resource>Service],
})
export class <Resource>Module {}
```

### controller
```ts
@Controller('<resource>')
@UseGuards(JwtAuthGuard)
export class <Resource>Controller {
  constructor(private readonly service: <Resource>Service) {}

  @Post()    create(@Body() dto: Create<Resource>Dto) { ... }
  @Get()     findAll() { ... }
  @Get(':id') findOne(@Param('id') id: string) { ... }
  @Patch(':id') update(@Param('id') id: string, @Body() dto: Update<Resource>Dto) { ... }
  @Delete(':id') remove(@Param('id') id: string) { ... }
}
```

### DTO
```ts
export class Create<Resource>Dto {
  @IsString() @IsNotEmpty()
  name: string;
}

export class Update<Resource>Dto extends PartialType(Create<Resource>Dto) {}
```

## Rules

- Always register the new module in `app.module.ts`
- Always add a Prisma model to `schema.prisma` and instruct user to run `pnpm db:migrate`
- 🚫 Never generate logic in controller — stub only
