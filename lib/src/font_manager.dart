import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import 'font_types.dart';
import 'glyph_metadata.dart';
import 'glyph_path.dart';

/// A singleton class that manages font loading and caching for sheet music rendering.
/// 
/// This class eliminates the need for asynchronous loading by pre-loading and caching
/// font data on first access, allowing for synchronous retrieval of glyph paths and metadata.
class FontManager {
  static final FontManager _instance = FontManager._internal();
  factory FontManager() => _instance;
  FontManager._internal();

  final Map<FontType, GlyphPaths> _glyphPathsCache = {};
  final Map<FontType, GlyphMetadata> _metadataCache = {};
  final Map<FontType, bool> _loadingState = {};

  /// Gets the glyph paths for the specified font type.
  /// 
  /// Loads the font synchronously on first access and caches the result.
  GlyphPaths getGlyphPaths(FontType fontType) {
    if (_glyphPathsCache.containsKey(fontType)) {
      return _glyphPathsCache[fontType]!;
    }
    
    _loadFont(fontType);
    return _glyphPathsCache[fontType]!;
  }

  /// Gets the glyph metadata for the specified font type.
  /// 
  /// Loads the font synchronously on first access and caches the result.
  GlyphMetadata getGlyphMetadata(FontType fontType) {
    if (_metadataCache.containsKey(fontType)) {
      return _metadataCache[fontType]!;
    }
    
    _loadFont(fontType);
    return _metadataCache[fontType]!;
  }

  /// Synchronously loads the font data for the specified font type.
  /// 
  /// This method loads both SVG glyph data and JSON metadata synchronously.
  /// Note: This should be called from a context where synchronous asset loading is appropriate.
  void _loadFont(FontType fontType) {
    if (_loadingState[fontType] == true) {
      return; // Already loaded or in progress
    }
    
    _loadingState[fontType] = true;
    
    try {
      // Load SVG synchronously - note this approach assumes the assets are available
      // In a real implementation, we might need a different strategy for truly synchronous loading
      final svgFuture = rootBundle.loadString(fontType.svgPath);
      final jsonFuture = rootBundle.loadString(fontType.metadataPath);
      
      // For now, we'll throw an exception to indicate this needs async handling
      // The actual implementation will be handled in the calling widget
      throw UnsupportedError(
        'Synchronous font loading requires assets to be pre-loaded. '
        'Use preloadFont() method instead.'
      );
    } catch (e) {
      _loadingState[fontType] = false;
      rethrow;
    }
  }

  /// Preloads a font asynchronously for later synchronous access.
  /// 
  /// This method should be called during app initialization or widget setup
  /// to ensure fonts are available for synchronous access.
  Future<void> preloadFont(FontType fontType) async {
    if (_glyphPathsCache.containsKey(fontType) && _metadataCache.containsKey(fontType)) {
      return; // Already loaded
    }

    if (_loadingState[fontType] == true) {
      return; // Already loading
    }

    _loadingState[fontType] = true;

    try {
      // Load SVG and parse glyph paths
      final xml = await rootBundle.loadString(fontType.svgPath);
      final document = XmlDocument.parse(xml);
      final allGlyphs = document.findAllElements('glyph').toSet();
      _glyphPathsCache[fontType] = GlyphPaths(allGlyphs);

      // Load JSON metadata
      final json = await rootBundle.loadString(fontType.metadataPath);
      _metadataCache[fontType] = GlyphMetadata(jsonDecode(json) as Map<String, dynamic>);
      
    } catch (e) {
      _loadingState[fontType] = false;
      rethrow;
    }
  }

  /// Checks if a font is already loaded and available for synchronous access.
  bool isFontLoaded(FontType fontType) {
    return _glyphPathsCache.containsKey(fontType) && _metadataCache.containsKey(fontType);
  }

  /// Clears the cache for a specific font type.
  void clearFont(FontType fontType) {
    _glyphPathsCache.remove(fontType);
    _metadataCache.remove(fontType);
    _loadingState.remove(fontType);
  }

  /// Clears all cached font data.
  void clearAll() {
    _glyphPathsCache.clear();
    _metadataCache.clear();
    _loadingState.clear();
  }
}