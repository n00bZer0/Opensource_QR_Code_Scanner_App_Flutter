//  Configure Repositories for Dependencies
allprojects {
    repositories {
        google()  // Google's Maven repository (Required for Android dependencies)
        mavenCentral()  // Central Maven repository (Used for Java/Kotlin dependencies)
    }
}

//  Set a Custom Build Directory (Moves `build/` folder to project's root)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

//  Configure Subprojects to Use the Custom Build Directory
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

//  Ensure `app` Module is Evaluated Before Other Modules
subprojects {
    project.evaluationDependsOn(":app")
}

//  Register a `clean` Task (Deletes the Build Directory)
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)  // Removes `build/` folder on `gradle clean`
}
