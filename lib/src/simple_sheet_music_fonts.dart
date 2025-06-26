import 'font_manager.dart';
import 'font_types.dart';

/// A utility class for preloading fonts globally to enable synchronous rendering.
/// 
/// This class provides convenient methods to preload fonts at application startup,
/// ensuring that SimpleSheetMusic widgets can render immediately without showing
/// loading indicators.
/// 
/// Example usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Preload all fonts for immediate access
///   await SimpleSheetMusicFonts.preloadAllFonts();
///   
///   runApp(MyApp());
/// }
/// ```
class SimpleSheetMusicFonts {
  static final FontManager _fontManager = FontManager();

  /// Preloads all available fonts for immediate synchronous access.
  /// 
  /// This method should be called during app initialization to ensure
  /// all fonts are available for immediate rendering.
  static Future<void> preloadAllFonts() async {
    final futures = FontType.values.map((fontType) => 
      _fontManager.preloadFont(fontType)
    );
    await Future.wait(futures);
  }

  /// Preloads a specific font for immediate synchronous access.
  /// 
  /// [fontType] The font type to preload.
  static Future<void> preloadFont(FontType fontType) async {
    await _fontManager.preloadFont(fontType);
  }

  /// Checks if a specific font is loaded and ready for synchronous access.
  /// 
  /// [fontType] The font type to check.
  /// Returns true if the font is loaded and can be accessed synchronously.
  static bool isFontLoaded(FontType fontType) {
    return _fontManager.isFontLoaded(fontType);
  }

  /// Checks if all fonts are loaded and ready for synchronous access.
  /// 
  /// Returns true if all fonts are loaded and can be accessed synchronously.
  static bool areAllFontsLoaded() {
    return FontType.values.every((fontType) => _fontManager.isFontLoaded(fontType));
  }

  /// Clears the cache for a specific font.
  /// 
  /// This might be useful for memory management or testing purposes.
  /// [fontType] The font type to clear from cache.
  static void clearFont(FontType fontType) {
    _fontManager.clearFont(fontType);
  }

  /// Clears all cached fonts.
  /// 
  /// This might be useful for memory management or testing purposes.
  static void clearAllFonts() {
    _fontManager.clearAll();
  }
}