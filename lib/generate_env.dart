import 'dart:io';

import 'package:args/args.dart';

import 'package:socialbuddybot/utils/context_logger.dart';

// 🌎 Project imports:

void main(List<String> rawArgs) {
  const _log = ContextLogger('generate_env');
  _log.start();

  const argKeyTarget = 'target';
  const defaultTraget = 'lib/env.dart';
  final argsParser = ArgParser()
    ..addOption(
      argKeyTarget,
      abbr: 't',
      help: 'The target file to generate.',
      defaultsTo: defaultTraget,
    );
  final args = argsParser.parse(rawArgs);
  final target = args[argKeyTarget] ?? defaultTraget;
  final envFile = File(target);

  _log.function('args', {argKeyTarget: target});

  if (envFile.existsSync()) {
    _log('Target already exists. Deleting.');
    envFile.deleteSync();
  }

  _log('Fetching env...');

  final envFields = <String, String>{
    // 'internalEnvValue': 'GLOBAL_ENV_VALUE',
  };

  final envContentFields = envFields.entries.map((entry) {
    return '  static const ${entry.key} = '
        '\'${Platform.environment[entry.value]}\';';
  });

  final envContent = [
    '// GENERATED CODE - DO NOT MODIFY BY HAND',
    '',
    'class Env {',
    ...envContentFields,
    '}',
    '',
  ].join('\n');

  _log('Writing env...');

  envFile.writeAsStringSync(envContent);

  _log.done();
}
