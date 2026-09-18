// Aviso OPCIONAL de nova versão nas lojas (iOS/Android).
// Lê a tabela `app_versions` no Supabase, compara com a versão instalada e,
// se houver versão mais nova, mostra um diálogo dispensável com botão pra abrir
// a App Store / Play Store. NUNCA bloqueia o uso. Qualquer erro é silencioso.
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Identificador deste app na tabela `app_versions` (app, platform).
const String _kAppId = 'aluno';

// Garante que o aviso apareça no máximo uma vez por sessão do app (não repete
// toda vez que a pessoa volta pro Dashboard).
bool _checkedThisSession = false;

Future<void> checkForUpdate(BuildContext context) async {
  // Web não tem loja — ignora.
  if (!(Platform.isAndroid || Platform.isIOS)) return;
  if (_checkedThisSession) return;
  _checkedThisSession = true;
  final platform = Platform.isIOS ? 'ios' : 'android';

  try {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version; // ex.: "1.0.2"
    final currentBuild = int.tryParse(info.buildNumber) ?? 0;

    final row = await Supabase.instance.client
        .from('app_versions')
        .select()
        .eq('app', _kAppId)
        .eq('platform', platform)
        .maybeSingle();

    if (row == null) return;

    final latestVersion = (row['latest_version'] ?? '').toString();
    final latestBuild =
        int.tryParse('${row['latest_build'] ?? ''}') ?? 0;
    final storeUrl = (row['store_url'] ?? '').toString();
    final message = (row['message'] ?? '').toString();

    if (storeUrl.isEmpty || latestVersion.isEmpty) return;
    if (!_isOutdated(
        currentVersion, currentBuild, latestVersion, latestBuild)) {
      return;
    }

    if (!context.mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Atualização disponível'),
        content: Text(
          message.isNotEmpty
              ? message
              : 'Uma nova versão do Stepout está disponível. Atualize para ter as últimas melhorias.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Agora não'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final uri = Uri.tryParse(storeUrl);
              if (uri != null && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  } catch (_) {
    // Silencioso: o check de versão nunca deve atrapalhar o uso do app.
  }
}

/// true se (currentVersion, currentBuild) for menor que (latestVersion, latestBuild).
bool _isOutdated(String currentVersion, int currentBuild, String latestVersion,
    int latestBuild) {
  final cmp = _compareVersions(currentVersion, latestVersion);
  if (cmp != 0) return cmp < 0;
  return currentBuild < latestBuild;
}

/// Compara versões semânticas ("1.0.2"). Retorna <0, 0 ou >0.
int _compareVersions(String a, String b) {
  final pa = _parse(a);
  final pb = _parse(b);
  final len = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < len; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x < y ? -1 : 1;
  }
  return 0;
}

List<int> _parse(String v) => v
    .split('+')
    .first
    .split('.')
    .map((p) => int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
    .toList();
