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
    val configureNamespace = { subproj: Project ->
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
            } catch (e: Exception) {
                // Ignore
            }
        }
    }

    if (project.state.executed) {
        configureNamespace(this)
    } else {
        project.afterEvaluate {
            configureNamespace(this)
        }
    }
}
