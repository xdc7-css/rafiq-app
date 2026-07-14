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
    project.evaluationDependsOn(":app")
}

subprojects {
    val subproject = this
    if (!subproject.state.executed) {
        subproject.afterEvaluate {
            val extension = subproject.extensions.findByType(com.android.build.gradle.BaseExtension::class.java)
            extension?.compileSdkVersion(36)
            extension?.defaultConfig?.targetSdkVersion(36)

            // AGP 8+ requires namespace for all Android library plugins.
            // Some plugins (e.g. isar_flutter_libs) don't set it.
            if (extension != null) {
                val hasLibraryPlugin = plugins.hasPlugin("com.android.library")
                val namespaceSet = extensions.findByName("android")?.let { android ->
                    android.javaClass.getMethod("getNamespace").invoke(android) as? String
                }
                if (hasLibraryPlugin && namespaceSet.isNullOrBlank()) {
                    val manifest = file("src/main/AndroidManifest.xml")
                    if (manifest.exists()) {
                        val content = manifest.readText()
                        val match = Regex("""package="([^"]+)"""").find(content)
                        if (match != null) {
                            val ns = match.groupValues[1]
                            extension.namespace = ns
                            logger.warn("Injected namespace '$ns' into ${project.name} (AGP 8+ compat)")
                        }
                    }
                }
            }
        }
    }
}

subprojects {
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
            force("androidx.browser:browser:1.8.0")
        }
    }
}






tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
