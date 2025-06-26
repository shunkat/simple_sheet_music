import 'package:flutter_test/flutter_test.dart';
import 'package:simple_sheet_music/src/simple_sheet_music_fonts.dart';
import 'package:simple_sheet_music/src/font_types.dart';

void main() {
  group('SimpleSheetMusicFonts', () {
    setUp(() {
      // Clear any existing cache before each test
      SimpleSheetMusicFonts.clearAllFonts();
    });

    test('should initially have no fonts loaded', () {
      expect(SimpleSheetMusicFonts.isFontLoaded(FontType.bravura), false);
      expect(SimpleSheetMusicFonts.isFontLoaded(FontType.petaluma), false);
      expect(SimpleSheetMusicFonts.areAllFontsLoaded(), false);
    });

    test('should track font loading state correctly', () {
      expect(SimpleSheetMusicFonts.areAllFontsLoaded(), false);
      
      // Note: In a real integration test, we would test the actual preloading
      // For unit tests, we focus on the API and state management
    });

    test('should clear fonts correctly', () {
      SimpleSheetMusicFonts.clearFont(FontType.bravura);
      expect(SimpleSheetMusicFonts.isFontLoaded(FontType.bravura), false);
      
      SimpleSheetMusicFonts.clearAllFonts();
      expect(SimpleSheetMusicFonts.areAllFontsLoaded(), false);
    });
  });
}