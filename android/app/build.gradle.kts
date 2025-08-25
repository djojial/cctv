plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cctv_kota"
    compileSdk = flutter.compileSdkVersion
    // ✅ Gunakan NDK versi 27 sesuai kebutuhan plugin
    ndkVersion = "27.0.12077973"

    compileOptions {
        // ✅ Update Java version
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Ganti dengan Application ID unik kamu saat rilis
        applicationId = "com.example.cctv_kota"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // ⚠️ Untuk sementara pakai debug signing agar build jalan
            // Nanti kalau rilis ke Play Store wajib pakai keystore release
            signingConfig = signingConfigs.getByName("debug")

            // Optional: optimisasi size APK
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
