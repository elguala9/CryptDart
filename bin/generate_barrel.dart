import 'dart:io';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  print('🔄 Generating barrel file...');

  const libDir = 'lib';
  const barrelFile = '$libDir/cryptdart.dart';

  // Find all .dart files with @includeInBarrelFile annotation
  final dartFiles = <String>[];
  final dir = Directory(libDir);

  await _findDartFiles(dir, dartFiles);

  // Extract files with @includeInBarrelFile annotation
  final barrelExports = <String>[];

  for (final dartFile in dartFiles) {
    final content = File(dartFile).readAsStringSync();

    // Skip the barrel file itself
    if (dartFile.endsWith('cryptdart.dart') || dartFile.endsWith('annotations.dart')) {
      continue;
    }

    // Check if file has @includeInBarrelFile annotation
    if (content.contains('@includeInBarrelFile')) {
      // Convert absolute path to relative import path
      final relativePath = path.relative(dartFile, from: libDir);
      final importPath = relativePath.replaceAll('\\', '/').replaceAll('.dart', '');
      barrelExports.add("export '$importPath.dart';");
    }
  }

  if (barrelExports.isEmpty) {
    print('❌ No files with @includeInBarrelFile found');
    exit(1);
  }

  // Sort exports for consistency
  barrelExports.sort();

  // Generate barrel file content
  final barrelContent = '''/// Main public API for CryptDart.
/// Auto-generated barrel file - DO NOT EDIT manually.
/// Run: dart run bin/generate_barrel.dart

${barrelExports.join('\n')}
''';

  // Write barrel file
  File(barrelFile).writeAsStringSync(barrelContent);

  print('✅ Barrel file generated: $barrelFile');
  print('📊 Exported ${barrelExports.length} files');
}

Future<void> _findDartFiles(Directory dir, List<String> files) async {
  try {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        files.add(entity.path);
      }
    }
  } catch (e) {
    print('Error reading directory: $e');
  }
}
