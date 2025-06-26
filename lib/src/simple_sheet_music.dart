import 'dart:core';

import 'package:flutter/material.dart';
import 'package:simple_sheet_music/src/glyph_metadata.dart';
import 'package:simple_sheet_music/src/glyph_path.dart';
import 'package:simple_sheet_music/src/measure/measure.dart';
import 'package:simple_sheet_music/src/music_objects/clef/clef_type.dart';
import 'package:simple_sheet_music/src/sheet_music_metrics.dart';
import 'package:simple_sheet_music/src/sheet_music_renderer.dart';

import 'font_manager.dart';
import 'font_types.dart';
import 'music_objects/interface/musical_symbol.dart';
import 'music_objects/key_signature/keysignature_type.dart';
import 'sheet_music_layout.dart';

typedef OnTapMusicObjectCallback = void Function(
  MusicalSymbol musicObject,
  Offset offset,
);

/// The `SimpleSheetMusic` widget is used to display sheet music.
/// It takes a list of `Staff` objects, an initial clef, and other optional parameters to customize the appearance of the sheet music.
/// 
/// For optimal performance, preload fonts using `SimpleSheetMusicFonts.preloadAllFonts()` 
/// at app startup to enable immediate rendering without loading indicators.
class SimpleSheetMusic extends StatefulWidget {
  const SimpleSheetMusic({
    super.key,
    required this.measures,
    this.initialClefType = ClefType.treble,
    this.initialKeySignatureType = KeySignatureType.cMajor,
    this.height = 400.0,
    this.width = 400.0,
    this.lineColor = Colors.black54,
    this.fontType = FontType.bravura,
  });

  /// Creates a SimpleSheetMusic widget that ensures fonts are preloaded.
  /// 
  /// This constructor returns a Future that resolves to the widget once fonts are loaded.
  /// Use this for guaranteed synchronous rendering without loading indicators.
  /// 
  /// Example:
  /// ```dart
  /// final widget = await SimpleSheetMusic.withPreloadedFonts(
  ///   measures: measures,
  ///   fontType: FontType.bravura,
  /// );
  /// ```
  static Future<SimpleSheetMusic> withPreloadedFonts({
    Key? key,
    required List<Measure> measures,
    ClefType initialClefType = ClefType.treble,
    KeySignatureType initialKeySignatureType = KeySignatureType.cMajor,
    double height = 400.0,
    double width = 400.0,
    Color lineColor = Colors.black54,
    FontType fontType = FontType.bravura,
  }) async {
    final fontManager = FontManager();
    await fontManager.preloadFont(fontType);
    
    return SimpleSheetMusic(
      key: key,
      measures: measures,
      initialClefType: initialClefType,
      initialKeySignatureType: initialKeySignatureType,
      height: height,
      width: width,
      lineColor: lineColor,
      fontType: fontType,
    );
  }

  /// Creates a SimpleSheetMusic widget assuming fonts are already loaded.
  /// 
  /// This method creates the widget immediately without checking if fonts are loaded.
  /// Use only when you're certain fonts have been preloaded via `SimpleSheetMusicFonts.preloadAllFonts()`.
  /// 
  /// If fonts aren't loaded, the widget will fall back to async loading with a loading indicator.
  /// 
  /// Example:
  /// ```dart
  /// // After calling SimpleSheetMusicFonts.preloadAllFonts() at app startup
  /// final widget = SimpleSheetMusic.immediate(
  ///   measures: measures,
  ///   fontType: FontType.bravura,
  /// );
  /// ```
  static SimpleSheetMusic immediate({
    Key? key,
    required List<Measure> measures,
    ClefType initialClefType = ClefType.treble,
    KeySignatureType initialKeySignatureType = KeySignatureType.cMajor,
    double height = 400.0,
    double width = 400.0,
    Color lineColor = Colors.black54,
    FontType fontType = FontType.bravura,
  }) {
    return SimpleSheetMusic(
      key: key,
      measures: measures,
      initialClefType: initialClefType,
      initialKeySignatureType: initialKeySignatureType,
      height: height,
      width: width,
      lineColor: lineColor,
      fontType: fontType,
    );
  }

  /// The list of measures to be displayed.
  final List<Measure> measures;

  /// Receive maximum width and height so as not to break the aspect ratio of the score.
  final double height;

  /// Receive maximum width and height so as not to break the aspect ratio of the score.
  final double width;

  /// The font type to be used for rendering the sheet music.
  final FontType fontType;

  /// The initial clef  for the sheet music.
  final ClefType initialClefType;

  // / The initial keySignature for the sheet music.
  final KeySignatureType initialKeySignatureType;

  /// A callback function that is called when a music object is tapped.
  // final OnTapMusicObjectCallback? onTap;

  final Color lineColor;

  @override
  SimpleSheetMusicState createState() => SimpleSheetMusicState();
}

/// The state class for the SimpleSheetMusic widget.
///
/// This class manages the state of the SimpleSheetMusic widget and handles the initialization,
/// font asset loading, and building of the widget.
class SimpleSheetMusicState extends State<SimpleSheetMusic> {
  late final FontManager _fontManager;
  late final Future<void> _fontPreloadFuture;

  FontType get fontType => widget.fontType;

  @override
  void initState() {
    super.initState();
    _fontManager = FontManager();
    _fontPreloadFuture = _fontManager.preloadFont(fontType);
  }

  @override
  Widget build(BuildContext context) {
    final targetSize = Size(widget.width, widget.height);
    
    // Check if font is already loaded for immediate synchronous rendering
    if (_fontManager.isFontLoaded(fontType)) {
      return _buildSheetMusic(targetSize);
    }
    
    // If font is not loaded, use async loading with FutureBuilder
    return FutureBuilder<void>(
      future: _fontPreloadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading font: ${snapshot.error}'),
          );
        }
        
        return _buildSheetMusic(targetSize);
      },
    );
  }

  Widget _buildSheetMusic(Size targetSize) {
    final glyphPath = _fontManager.getGlyphPaths(fontType);
    final metadata = _fontManager.getGlyphMetadata(fontType);
    
    final metricsBuilder = SheetMusicMetrics(
      widget.measures,
      widget.initialClefType,
      widget.initialKeySignatureType,
      metadata,
      glyphPath,
    );
    final layout = SheetMusicLayout(
      metricsBuilder,
      widget.lineColor,
      widgetWidth: widget.width,
      widgetHeight: widget.height,
    );
    return CustomPaint(
      size: targetSize,
      painter: SheetMusicRenderer(layout),
    );
  }
}
