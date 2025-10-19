import 'dart:convert';

import 'package:http/http.dart' as http;

/// Thin client around publicly available LibreTranslate-compatible endpoints.
class RemoteTranslator {
  RemoteTranslator({http.Client? httpClient})
    : _client = httpClient ?? http.Client();

  final http.Client _client;

  static const _endpoints = <String>[
    'https://translate.argosopentech.com/translate',
    'https://libretranslate.de/translate',
  ];

  Future<String?> translate({
    required String text,
    required String target,
    String source = 'en',
  }) async {
    if (text.trim().isEmpty) {
      return text;
    }

    final payload = jsonEncode({
      'q': text,
      'source': source,
      'target': target,
      'format': 'text',
    });

    for (final endpoint in _endpoints) {
      try {
        final response = await _client.post(
          Uri.parse(endpoint),
          headers: const {'Content-Type': 'application/json'},
          body: payload,
        );

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['translatedText'] is String) {
            return decoded['translatedText'] as String;
          }
        }
      } catch (_) {
        // Try next endpoint.
      }
    }

    return null;
  }
}
