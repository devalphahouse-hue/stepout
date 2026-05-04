import 'package:supabase_flutter/supabase_flutter.dart';

// Mantém a assinatura makeCloudCall(callName, input) por retrocompatibilidade
// com os call-sites em api_calls.dart (que passam 'ffprivateapicallalunov2').
// O parâmetro `_functionName` é ignorado: sempre invocamos a Edge Function
// `asaas-proxy` no Supabase, que substituiu a Firebase Cloud Function antiga.
Future<Map<String, dynamic>> makeCloudCall(
  String _functionName,
  Map<String, dynamic> input,
) async {
  try {
    final response = await Supabase.instance.client.functions.invoke(
      'asaas-proxy',
      body: input,
    );
    final data = response.data;
    return data is Map ? Map<String, dynamic>.from(data) : {};
  } catch (_) {
    // Cloud call error silenciado em produção
  }
  return {};
}
