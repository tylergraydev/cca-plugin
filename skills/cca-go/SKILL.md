---
name: cca-go
description: CCA language context for Go projects. Auto-loaded when go.mod is detected.
---

# CCA: Go Context

## Language Detection
This context applies when any of these files exist:
- `go.mod`
- `go.sum`
- `*.go` files

## Build-Test-Improve Commands

### Build
```bash
# Build
go build ./...

# Build with race detector
go build -race ./...

# Install binary
go install ./cmd/myapp
```

### Test
```bash
# Run all tests
go test ./...

# Verbose
go test -v ./...

# With coverage
go test -cover ./...
go test -coverprofile=coverage.out ./...

# Specific package
go test ./pkg/mypackage

# Run specific test
go test -run TestFunctionName ./...
```

### Lint/Format
```bash
# Format (built-in)
go fmt ./...
gofmt -w .

# Vet (built-in static analysis)
go vet ./...

# golangci-lint (comprehensive)
golangci-lint run

# staticcheck
staticcheck ./...
```

## Common Patterns

### Error Handling
```go
// Always handle errors explicitly
result, err := riskyOperation()
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}

// Custom errors
var ErrNotFound = errors.New("not found")

type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("%s: %s", e.Field, e.Message)
}
```

### Struct Patterns
```go
// Constructor functions
func NewUser(name string) *User {
    return &User{
        ID:        uuid.New(),
        Name:      name,
        CreatedAt: time.Now(),
    }
}

// Options pattern for complex construction
type Option func(*Config)

func WithTimeout(d time.Duration) Option {
    return func(c *Config) {
        c.Timeout = d
    }
}
```

### Concurrency
```go
// Use context for cancellation
func Process(ctx context.Context, items []Item) error {
    g, ctx := errgroup.WithContext(ctx)
    
    for _, item := range items {
        item := item // capture loop variable
        g.Go(func() error {
            return processItem(ctx, item)
        })
    }
    
    return g.Wait()
}

// Channels for communication
results := make(chan Result, len(items))
```

### Interface Patterns
```go
// Keep interfaces small
type Reader interface {
    Read(p []byte) (n int, err error)
}

// Accept interfaces, return structs
func NewService(repo Repository) *Service {
    return &Service{repo: repo}
}
```

## Project Structure Conventions

```
myproject/
├── cmd/
│   └── myapp/
│       └── main.go         # Entry point
├── internal/               # Private packages
│   ├── handler/
│   ├── service/
│   └── repository/
├── pkg/                    # Public packages
│   └── mylib/
├── api/                    # API definitions (OpenAPI, proto)
├── go.mod
└── go.sum
```

## Module Management
```bash
# Initialize module
go mod init github.com/user/project

# Add dependencies
go get github.com/pkg/errors

# Tidy dependencies
go mod tidy

# Update all dependencies
go get -u ./...
```

## Common Gotchas
- No unused imports or variables (compile error)
- Loop variable capture in goroutines (use `item := item`)
- `defer` executes at function end, not block end
- Slices share underlying arrays (copy if needed)
- `nil` map/slice is valid for reading, panics on write
- Check `context.Context` for cancellation in long operations
