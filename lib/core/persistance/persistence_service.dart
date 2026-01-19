import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// 플랫폼에 최적화된 앱 데이터 영속성 관리 서비스
class PersistenceService {
  PersistenceService._();
  static final PersistenceService instance = PersistenceService._();

  Future<String> get _basePath async {
    // 하이브리드 접근: 데스크톱 배포 안정성을 위해 SupportDirectory 사용
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  Future<File> _getFile(String fileName) async {
    final base = await _basePath;
    final file = File(p.join(base, 'appdata', fileName));
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    return file;
  }

  /// 데이터를 JSON 형식으로 파일에 저장합니다.
  Future<void> save(String fileName, Map<String, dynamic> data) async {
    try {
      final file = await _getFile(fileName);
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      stderr.writeln('PersistenceService.save error: $e');
      rethrow;
    }
  }

  /// 파일에서 JSON 데이터를 읽어옵니다.
  Future<Map<String, dynamic>?> load(String fileName) async {
    try {
      final file = await _getFile(fileName);
      if (await file.exists()) {
        final content = await file.readAsString();
        return jsonDecode(content) as Map<String, dynamic>;
      }
    } catch (e) {
      stderr.writeln('PersistenceService.load error: $e');
    }
    return null;
  }

  /// 파일 존재 여부를 확인합니다.
  Future<bool> exists(String fileName) async {
    final file = await _getFile(fileName);
    return file.exists();
  }
}
