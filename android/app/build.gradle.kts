//  Apply essential plugins for Android & Flutter
plugins {
    id("com.android.application")  // Android app plugin
    id("kotlin-android")  // Kotlin support for Android
    id("dev.flutter.flutter-gradle-plugin")  // Flutter Gradle plugin
}

android {
    //  Define the package namespace for your Flutter app
    namespace = "com.opensource.qr_code_scanner"

    //  Specify the Android SDK versions
    compileSdk = 35 // Use the latest stable version for best compatibility

    defaultConfig {
        applicationId = "com.opensource.qr_code_scanner" // Unique app identifier
        minSdk = 21  // Minimum Android version supported (Android 5.0 - Lollipop)
        targetSdk = 34  // The latest Android version your app is tested against
        versionCode = 1  // Internal app version (Increment for updates)
        versionName = "1.0"  // Displayed version name (e.g., 1.0, 1.1, etc.)
    }

    buildTypes {
        release {
            isMinifyEnabled = false  // ❌ Disables ProGuard (Set to `true` to shrink code)
            isShrinkResources = false  // ❌ Disables unused resource removal

            //  Use debug signing config (Replace with release signing for Play Store)
            signingConfig = signingConfigs.getByName("debug") 
        }
    }

    //  Java Compatibility settings for performance & stability
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11  // Use Java 11 features
        targetCompatibility = JavaVersion.VERSION_11
    }

    //  Kotlin JVM target version
    kotlinOptions {
        jvmTarget = "11"
    }
}

//  Set the Flutter module location
flutter {
    source = "../.."  // Path to Flutter project root
}
