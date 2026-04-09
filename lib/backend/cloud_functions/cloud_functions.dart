import 'package:cloud_functions/cloud_functions.dart';

Future<Map<String, dynamic>> makeCloudCall(
  String callName,
  Map<String, dynamic> input,
) async {
  try {
    final response = await FirebaseFunctions.instance
        .httpsCallable(callName, options: HttpsCallableOptions())
        .call(input);
    return response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : {};
  } on FirebaseFunctionsException catch (_) {
    // Cloud function error silenciado em produção
  } catch (_) {
    // Cloud call error silenciado em produção
  }
  return {};
}
