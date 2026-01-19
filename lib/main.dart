import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

import 'package:sloth_photo_sorter/feature/main_page.dart';

import 'core/di/injection.dart';
import 'core/theme/theme_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjection();
  // set min size on desktop platform
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(800, 600));
  }
  final themeStore = ThemeStore();
  await themeStore.load();
  runApp(MyApp(themeStore: themeStore));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.themeStore});
  final ThemeStore themeStore;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeState>(
      valueListenable: themeStore,
      builder: (context, themeState, _) {
        return MaterialApp(
          title: 'SlothPhotoSorter',
          debugShowCheckedModeBanner: false,
          theme: themeStore.lightTheme,
          darkTheme: themeStore.darkTheme,
          themeMode: themeState.mode,
          home: MainPage(themeStore: themeStore),
        );
      },
    );
  }
}
