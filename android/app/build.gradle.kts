import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// =========================================================================
// SIGNING CONFIGURATION
// =========================================================================
// Load keystore properties from key.properties file (for CI/CD builds)
// This file is created by GitHub Actions and contains secrets
// DO NOT commit key.properties or keystore files to version control!
//
// IMPORTANT: Release builds WILL FAIL if key.properties is missing.
// This prevents accidental debug-signed releases.
// =========================================================================

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasReleaseConfig = keystorePropertiesFile.exists()

if (hasReleaseConfig) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.harvesthub.aishabm"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.harvesthub.aishabm"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ===== SIGNING CONFIGS =====
    signingConfigs {
        // Release signing configuration - uses key.properties from CI/CD
        // This config is REQUIRED for release builds - no debug fallback!
        if (hasReleaseConfig) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // =========================================================
            // CRITICAL: NO DEBUG FALLBACK FOR RELEASE BUILDS
            // =========================================================
            // Release builds MUST use proper release signing.
            // If key.properties is missing, the build will FAIL.
            // This prevents accidentally uploading debug-signed APK/AAB
            // to the Play Store.
            // =========================================================
            
            if (hasReleaseConfig) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                // Fail the build if trying to create a release without proper signing
                // This will cause a clear error: "signingConfig not set"
                signingConfig = null
            }

            // Enable code shrinking and obfuscation
            isMinifyEnabled = true
            isShrinkResources = true

            // ProGuard rules
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            // Debug builds use the default debug keystore (for development only)
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}
