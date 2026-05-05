allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureAndroid = { subproj: Project ->
        val androidExt = subproj.extensions.findByName("android")
        if (androidExt != null) {
            try {
                val clazz = androidExt.javaClass
                val getNamespace = clazz.getMethod("getNamespace")
                val currentNamespace = getNamespace.invoke(androidExt) as String?
                if (currentNamespace.isNullOrEmpty()) {
                    val setNamespace = clazz.getMethod("setNamespace", String::class.java)
                    var targetNamespace = subproj.group.toString()
                    if (targetNamespace.isEmpty() || targetNamespace == "unspecified") {
                        targetNamespace = "com.example." + subproj.name.replace("-", "_")
                    }
                    setNamespace.invoke(androidExt, targetNamespace)
                }

                val compileOptions = clazz.getMethod("getCompileOptions").invoke(androidExt)
                val setSourceCompatibility = compileOptions.javaClass.getMethod("setSourceCompatibility", JavaVersion::class.java)
                val setTargetCompatibility = compileOptions.javaClass.getMethod("setTargetCompatibility", JavaVersion::class.java)
                setSourceCompatibility.invoke(compileOptions, JavaVersion.VERSION_11)
                setTargetCompatibility.invoke(compileOptions, JavaVersion.VERSION_11)
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    if (project.state.executed) {
        configureAndroid(this)
    } else {
        project.afterEvaluate {
            configureAndroid(this)
        }
    }

    project.tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "11"
        targetCompatibility = "11"
    }
    project.tasks.configureEach {
        if (name.contains("compile") && name.contains("Kotlin")) {
            try {
                val kotlinOptions = javaClass.getMethod("getKotlinOptions").invoke(this)
                kotlinOptions.javaClass.getMethod("setJvmTarget", String::class.java).invoke(kotlinOptions, "11")
            } catch (e: Exception) {}
        }
    }
}
