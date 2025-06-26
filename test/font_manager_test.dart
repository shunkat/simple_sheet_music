import 'package:flutter_test/flutter_test.dart';
import 'package:simple_sheet_music/src/font_manager.dart';
import 'package:simple_sheet_music/src/font_types.dart';

void main() {
  group('FontManager', () {
    late FontManager fontManager;

    setUp(() {
      fontManager = FontManager();
      // Clear any existing cache
      fontManager.clearAll();
    });

    test('should be a singleton', () {
      final instance1 = FontManager();
      final instance2 = FontManager();
      expect(instance1, same(instance2));
    });

    test('should initially have no fonts loaded', () {
      expect(fontManager.isFontLoaded(FontType.bravura), false);
      expect(fontManager.isFontLoaded(FontType.petaluma), false);
    });

    test('should track font loading state correctly', () async {
      expect(fontManager.isFontLoaded(FontType.bravura), false);
      
      // Note: In a real test environment, we might need to mock the asset loading
      // For now, we just test the state management logic
      
      // The preloadFont method would be tested in an integration test
      // where Flutter's asset bundle is available
    });

    test('should clear fonts correctly', () {
      // This tests the cache clearing functionality
      fontManager.clearFont(FontType.bravura);
      expect(fontManager.isFontLoaded(FontType.bravura), false);
      
      fontManager.clearAll();
      expect(fontManager.isFontLoaded(FontType.bravura), false);
      expect(fontManager.isFontLoaded(FontType.petaluma), false);
    });
  });
}