---
name: cca-java
description: CCA language context for Java/Kotlin projects. Auto-loaded when pom.xml, build.gradle, or .java/.kt files are detected.
---

# CCA: Java/Kotlin Context

## Language Detection
This context applies when any of these files exist:
- `pom.xml` (Maven)
- `build.gradle` or `build.gradle.kts` (Gradle)
- `*.java` or `*.kt` files

## Build-Test-Improve Commands

### Maven
```bash
# Build
mvn compile
mvn package

# Test
mvn test
mvn test -Dtest=TestClassName

# Clean
mvn clean
```

### Gradle
```bash
# Build
./gradlew build
./gradlew assemble

# Test
./gradlew test
./gradlew test --tests "TestClassName"

# Clean
./gradlew clean
```

### Lint/Format
```bash
# Spotless (common formatter)
./gradlew spotlessApply

# Checkstyle
./gradlew checkstyleMain

# ktlint (Kotlin)
./gradlew ktlintFormat
```

## Common Patterns

### Error Handling (Java)
```java
// Use specific exceptions
public class NotFoundException extends RuntimeException {
    public NotFoundException(String message) {
        super(message);
    }
}

// Try-with-resources for AutoCloseable
try (var connection = dataSource.getConnection()) {
    // use connection
} catch (SQLException e) {
    logger.error("Database error", e);
    throw new DataAccessException("Failed to query", e);
}
```

### Error Handling (Kotlin)
```kotlin
// Sealed classes for result types
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: Throwable) : Result<Nothing>()
}

// Use runCatching
val result = runCatching { riskyOperation() }
    .getOrElse { default }
```

### Null Safety
```java
// Java - Use Optional
Optional<User> user = userRepository.findById(id);
user.ifPresent(u -> process(u));
String name = user.map(User::getName).orElse("Unknown");

// Use @Nullable/@NonNull annotations
public @Nullable String findName(@NonNull String id)
```

```kotlin
// Kotlin - Built-in null safety
val name: String? = user?.name
val displayName = name ?: "Unknown"

// Safe calls
user?.profile?.avatar?.url
```

### Dependency Injection
```java
// Spring Boot
@Service
public class UserService {
    private final UserRepository repository;
    
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
}

// Annotations
@Autowired // Field injection (less preferred)
@Component, @Service, @Repository, @Controller
```

## Project Structure Conventions

### Maven/Gradle Standard
```
project/
├── src/
│   ├── main/
│   │   ├── java/           # Java source
│   │   ├── kotlin/         # Kotlin source
│   │   └── resources/      # Config files
│   └── test/
│       ├── java/
│       └── resources/
├── pom.xml                 # Maven
└── build.gradle            # Gradle
```

### Spring Boot
```
src/main/java/com/example/
├── Application.java        # Entry point
├── controller/
├── service/
├── repository/
├── model/
└── config/
```

## Framework Detection
- `spring-boot` dependency → Spring Boot
- `quarkus` dependency → Quarkus
- `micronaut` dependency → Micronaut
- `android` plugin → Android

## Common Gotchas
- Check Java version in `pom.xml` or `build.gradle`
- `./gradlew` vs `gradle` - use wrapper when available
- Spring profiles: `application-{profile}.yml`
- Lombok: Check if annotation processing is enabled
- Kotlin: `data class` auto-generates equals/hashCode
