plugins {
    kotlin("jvm") version "2.1.0" // Kotlin version to use
    application
}

group = "com.maddyguthridge" // A company name, for example, `org.jetbrains`
version = "1.0-SNAPSHOT" // Version to assign to the built artifact

repositories { // Sources of dependencies. See 1️⃣
    mavenCentral() // Maven Central Repository. See 2️⃣
}

dependencies { // All the libraries you want to use. See 3️⃣
    // Copy dependencies' names after you find them in a repository
    testImplementation(kotlin("test")) // The Kotlin test library
}

tasks.test { // See 4️⃣
    useJUnitPlatform() // JUnitPlatform for tests. See 5️⃣
}

application {
    mainClass = "com.maddyguthridge.aoc2024.MainKt"
}

// Forward stdin to the application -- for some reason, Gradle doesn't do this
// automatically.
// https://stackoverflow.com/a/46662535/6335363
val run by tasks.getting(JavaExec::class) {
    standardInput = System.`in`
}
