import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.example.app_default.dev"
            resValue(type = "string", name = "app_name", value = "(Dev) App Default")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.example.app_default"
            resValue(type = "string", name = "app_name", value = "App Default")
        }
    }
}
