import 'package:flutter/material.dart';
import 'package:sloth_photo_sorter/core/theme/theme_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.themeStore});

  final ThemeStore themeStore;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sloth Photo Sorter'),
        centerTitle: true,
        actions: [
          // 테마 전환 버튼 (예시)
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // themeStore의 테마 변경 로직 호출 (toggle 등)
              // widget.themeStore.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              '사진 정리를 시작해보세요!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 사진 불러오기 또는 정렬 로직
              },
              child: const Text('사진 불러오기'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 추가 기능 실행
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
