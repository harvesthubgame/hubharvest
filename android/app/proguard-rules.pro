# =========================================================================
# HARVEST HUB - ProGuard Rules
# =========================================================================
# These rules ensure the release build succeeds even without Google Play Core.
# Flutter's Android build may reference Play Core classes for deferred components.
# Since this app doesn't use dynamic feature modules, we suppress these warnings.
# =========================================================================

# ===== FLUTTER =====
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ===== GOOGLE PLAY CORE - Suppress Missing Class Warnings =====
# These classes are referenced by Flutter for deferred components but are not
# used in this app. Safe to ignore since we don't use dynamic feature modules.

-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Additional Play Core classes that may be referenced
-dontwarn com.google.android.play.core.appupdate.**
-dontwarn com.google.android.play.core.install.**
-dontwarn com.google.android.play.core.review.**
-dontwarn com.google.android.play.core.common.**
-dontwarn com.google.android.play.core.listener.**

# ===== FLAME ENGINE =====
-keep class org.libsdl.** { *; }
-keep class com.badlogic.** { *; }

# ===== KOTLIN =====
-dontwarn kotlin.**
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }

# ===== SHARED PREFERENCES =====
-keep class androidx.datastore.** { *; }

# ===== GENERAL ANDROID =====
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelables
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ===== OPTIMIZATION =====
-optimizationpasses 5
-dontusemixedcaseclassnames
-verbose
