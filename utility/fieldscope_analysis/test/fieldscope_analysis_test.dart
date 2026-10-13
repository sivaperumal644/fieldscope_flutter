import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('fieldscope_analysis', () {
    late File analysisOptionsFile;

    setUp(() {
      final packageRoot = Directory.current.path;
      analysisOptionsFile = File(
        path.join(packageRoot, 'lib', 'analysis_options.yaml'),
      );
    });

    test('exports an analysis_options.yaml from lib/', () {
      expect(
        analysisOptionsFile.existsSync(),
        isTrue,
        reason: 'Expected lib/analysis_options.yaml to exist so other packages can include it via this package.',
      );
    });

    test('analysis_options.yaml is valid, parseable YAML', () {
      final contents = analysisOptionsFile.readAsStringSync();
      expect(() => loadYaml(contents), returnsNormally);
    });

    test('analysis_options.yaml defines linter rules', () {
      final contents = analysisOptionsFile.readAsStringSync();
      final YamlMap yamlMap = loadYaml(contents) as YamlMap;
      expect(
        yamlMap.containsKey('linter') || yamlMap.containsKey('include'),
        isTrue,
        reason: 'Expected the file to either define linter rules directly or include a base lint set',
      );
    });
  });
}
