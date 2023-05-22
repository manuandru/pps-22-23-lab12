plugins {
    application
    java
    scala
}

sourceSets {
    main {
        withConvention(ScalaSourceSet::class) {
            scala {
                setSrcDirs(listOf("src/main/scala", "src/main/java"))
            }
        }
        java {
            setSrcDirs(listOf("/none"))
        }
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.scala-lang:scala3-library_3:3.2.2")
    implementation("it.unibo.alice.tuprolog:2p-core:4.1.1")
    implementation("it.unibo.alice.tuprolog:2p-ui:4.1.1")

}

tasks.withType<ScalaCompile> {
}


application {
    // Define the main class for the application
    mainClassName = "it.unibo.u12lab.code.TicTacToeApp"
}
