---
name: cca-csharp
description: CCA language context for C#/.NET projects. Auto-loaded when .csproj, .sln, or .cs files are detected.
---

# CCA: C#/.NET Context

## Language Detection
This context applies when any of these files exist:
- `*.csproj`
- `*.sln`
- `global.json`
- `*.cs` files

## Build-Test-Improve Commands

### Build
```bash
# Build solution/project
dotnet build
dotnet build --configuration Release

# Restore packages
dotnet restore
```

### Test
```bash
# Run all tests
dotnet test

# Verbose output
dotnet test --logger "console;verbosity=detailed"

# Specific project
dotnet test ./tests/MyProject.Tests

# With coverage
dotnet test --collect:"XPlat Code Coverage"
```

### Format/Analyze
```bash
# Format code
dotnet format

# Code analysis
dotnet build /p:TreatWarningsAsErrors=true
```

## Common Patterns

### Error Handling
```csharp
// Use Result pattern for expected failures
public record Result<T>
{
    public bool IsSuccess { get; init; }
    public T? Value { get; init; }
    public string? Error { get; init; }
    
    public static Result<T> Success(T value) => new() { IsSuccess = true, Value = value };
    public static Result<T> Failure(string error) => new() { IsSuccess = false, Error = error };
}

// Exceptions for unexpected failures
try
{
    var result = await RiskyOperationAsync();
}
catch (SpecificException ex)
{
    _logger.LogError(ex, "Operation failed");
    throw;
}
```

### Null Safety
```csharp
// Enable nullable reference types in .csproj
// <Nullable>enable</Nullable>

// Use null-conditional and null-coalescing
var name = user?.Name ?? "Unknown";

// Pattern matching
if (result is { IsSuccess: true, Value: var value })
{
    Process(value);
}
```

### Async Patterns
```csharp
// Always use async/await, not .Result or .Wait()
public async Task<List<User>> GetUsersAsync(CancellationToken ct = default)
{
    var users = await _repository.GetAllAsync(ct);
    return users.ToList();
}

// Parallel operations
var tasks = ids.Select(id => GetUserAsync(id, ct));
var users = await Task.WhenAll(tasks);
```

### Dependency Injection
```csharp
// Register services in Program.cs or Startup.cs
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddSingleton<ICacheService, CacheService>();
builder.Services.AddTransient<IEmailService, EmailService>();
```

## Project Structure Conventions

```
Solution.sln
src/
├── Project.Api/              # Web API
│   ├── Controllers/
│   ├── Program.cs
│   └── Project.Api.csproj
├── Project.Core/             # Business logic
│   ├── Services/
│   ├── Models/
│   └── Project.Core.csproj
├── Project.Infrastructure/   # Data access, external services
│   ├── Repositories/
│   └── Project.Infrastructure.csproj
tests/
├── Project.Tests.Unit/
└── Project.Tests.Integration/
```

## Framework Detection
- `Microsoft.AspNetCore` → ASP.NET Core Web
- `Microsoft.NET.Sdk.BlazorWebAssembly` → Blazor WASM
- `Microsoft.NET.Sdk.Worker` → Background Worker
- `Microsoft.Azure.Functions` → Azure Functions

## Common Gotchas
- Check `TargetFramework` in .csproj (net8.0, net9.0, etc.)
- Use `ILogger<T>` not `Console.WriteLine` for logging
- `ConfigureAwait(false)` in library code, not in ASP.NET Core
- EF Core migrations: `dotnet ef migrations add Name`
- Secrets: use `dotnet user-secrets` for local development
