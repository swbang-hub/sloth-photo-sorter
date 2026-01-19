import 'package:flutter/material.dart';
import '../persistance/persistence_service.dart';

enum AppColorSeed { indigo, blue, teal, green, amber, orange, pink, purple }

extension AppColorSeedX on AppColorSeed {
  String get label => switch (this) {
    AppColorSeed.indigo => 'Indigo',
    AppColorSeed.blue => 'Blue',
    AppColorSeed.teal => 'Teal',
    AppColorSeed.green => 'Green',
    AppColorSeed.amber => 'Amber',
    AppColorSeed.orange => 'Orange',
    AppColorSeed.pink => 'Pink',
    AppColorSeed.purple => 'Purple',
  };

  Color get color => switch (this) {
    AppColorSeed.indigo => Colors.indigo,
    AppColorSeed.blue => Colors.blue,
    AppColorSeed.teal => Colors.teal,
    AppColorSeed.green => Colors.green,
    AppColorSeed.amber => Colors.amber,
    AppColorSeed.orange => Colors.orange,
    AppColorSeed.pink => Colors.pink,
    AppColorSeed.purple => Colors.purple,
  };
}

/// 앱 테마 클래스
///
/// 이 클래스는 불변(Immutable) 객체로 설계되어 상태 변경 시 [copyWith]를 사용해야 하며,
/// JSON 직렬화 및 역직렬화를 통해 설정 정보를 로컬에 저장.
class ThemeState {
  final AppColorSeed seed;
  final ThemeMode mode;
  const ThemeState({required this.seed, required this.mode});
  ThemeState copyWith({AppColorSeed? seed, ThemeMode? mode}) {
    return ThemeState(seed: seed ?? this.seed, mode: mode ?? this.mode);
  }

  Map<String, dynamic> toJson() => {'seed': seed.name, 'mode': mode.name};

  static ThemeState fromJson(Map<String, dynamic> json) {
    final seedName = json['seed'] as String?;
    final modeName = json['mode'] as String?;

    AppColorSeed seed = AppColorSeed.indigo;
    if (seedName != null) {
      seed = AppColorSeed.values.firstWhere(
        (element) => element.name == seedName,
        orElse: () => seed,
      );
    }

    ThemeMode mode = ThemeMode.system;
    if (modeName != null) {
      mode = ThemeMode.values.firstWhere(
        (element) => element.name == modeName,
        orElse: () => mode,
      );
    }

    return ThemeState(seed: seed, mode: mode);
  }
}

/// Theme Store
class ThemeStore extends ValueNotifier<ThemeState> {
  ThemeStore()
    : super(
        const ThemeState(seed: AppColorSeed.indigo, mode: ThemeMode.system),
      );

  ThemeData get lightTheme => _themeFor(Brightness.light);
  ThemeData get darkTheme => _themeFor(Brightness.dark);

  ThemeData _themeFor(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: value.seed.color,
      brightness: brightness,
    );
    return ThemeData(colorScheme: colorScheme, useMaterial3: true);
  }

  Future<void> load() async {
    try {
      final data = await PersistenceService.instance.load('theme.json');
      if (data != null) {
        value = ThemeState.fromJson(data);
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    try {
      await PersistenceService.instance.save('theme.json', value.toJson());
    } catch (_) {}
  }

  void setSeed(AppColorSeed seed) {
    value = value.copyWith(seed: seed);
    _persist();
  }

  void setMode(ThemeMode mode) {
    value = value.copyWith(mode: mode);
    _persist();
  }
}
