allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library")) {
            val android = extensions.getByType(com.android.build.gradle.LibraryExtension::class.java)
            if (android.namespace == null) {
                android.namespace = "dev.isar.${project.name.replace("-", "_")}"
            }
            // afterEvaluate ensures this overrides isar_flutter_libs's own compileSdk = 30
            android.compileSdkVersion(34)
        }
    }
}


tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
