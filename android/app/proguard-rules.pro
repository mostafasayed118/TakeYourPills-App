# Flutter / TakeYourPills release shrinker rules
# Keep Flutter engine entry points and plugin registrants.

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# flutter_local_notifications + desugar / scheduling
-keep class com.dexterous.** { *; }

# Drift / sqlite
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Play Core is only referenced for deferred components (unused here).
# R8 fails minify without these dontwarn rules on modern Flutter embeds.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Keep Gson/serialization style reflective models if plugins use them
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
