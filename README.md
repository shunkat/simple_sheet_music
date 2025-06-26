<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

The `simple_sheet_music` library provides a simple way to display sheet music in Flutter applications.
It contains classes for rendering staves, measures, clefs, notes and other notation objects.

<p align="center">
    <img src="https://github.com/tomoyu719/simple_sheet_music/assets/29626818/33364f6a-63ae-4b41-9c98-46998fe3c702" width="30%" style="display: block; margin: 0 auto;">
</p>

## Performance Optimization

The library includes an optimized font loading system that eliminates loading delays for better user experience:

### Synchronous Rendering with Font Preloading

For optimal performance, preload fonts at application startup to enable immediate rendering without loading indicators:

```dart
import 'package:flutter/material.dart';
import 'package:simple_sheet_music/simple_sheet_music.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preload all fonts for immediate rendering
  await SimpleSheetMusicFonts.preloadAllFonts();
  
  runApp(MyApp());
}
```

### Benefits

- **No loading delays**: Sheet music renders immediately when fonts are preloaded
- **Better UX**: Eliminates loading spinners and wait times
- **Backward compatible**: Falls back to async loading if fonts aren't preloaded

### Usage Options

1. **Preload all fonts at startup** (recommended for optimal performance):
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await SimpleSheetMusicFonts.preloadAllFonts();
     runApp(MyApp());
   }
   
   // Then use immediate constructor
   SimpleSheetMusic.immediate(
     measures: measures,
     fontType: FontType.bravura,
   )
   ```

2. **Preload specific fonts**:
   ```dart
   await SimpleSheetMusicFonts.preloadFont(FontType.bravura);
   ```

3. **Ensure fonts are loaded for a specific widget**:
   ```dart
   final widget = await SimpleSheetMusic.withPreloadedFonts(
     measures: measures,
     fontType: FontType.bravura,
   );
   ```

4. **Check loading status**:
   ```dart
   if (SimpleSheetMusicFonts.isFontLoaded(FontType.bravura)) {
     // Font is ready for immediate rendering
   }
   ```
