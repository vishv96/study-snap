import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:study_snap/core/services/aiservice_interface.dart';
import 'package:study_snap/core/models/api_response.dart';
import 'package:study_snap/core/models/solution_step.dart';

import '../constants/app_config.dart';

class AIService extends ApiServiceInterface {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.kimiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Authorization': 'Bearer ${AppConfig.kimiApiKey}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  @override
  Future<SolutionResult> solveFromImage(File imageFile) async {
    try {
      print('Image path: ${imageFile.path}');
      print('File exists: ${await imageFile.exists()}');

      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist at path: ${imageFile.path}');
      }

      final bytes = await imageFile.readAsBytes();
      print('Read ${bytes.length} bytes from image');
      final base64Image = base64Encode(bytes);

      final response = await _dio.post(
        'chat/completions',
        data: {
          'model': AppConfig.kimiModel,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
                },
                {'type': 'text', 'text': Prompts.requestPromt},
              ],
            },
          ],
          'max_tokens': 2048,
          'temperature': 0.3,
        },
      );

      print('Response: ${response.data}');
      final jsonString = cleanJson(extractJson(response.data));
      final apiResponse = ApiResponse.fromJson(jsonDecode(jsonString));
      if (apiResponse.isError) {
        throw Exception(
          'API Error: ${apiResponse.errorCode} - ${apiResponse.errorMessage}',
        );
      } else if (apiResponse.solutionResult == null) {
        throw Exception('API response does not contain a solution result');
      } else {
        return apiResponse.solutionResult!;
      }
    } catch (e) {
      print('ERROR: $e');
      throw e;
    }
  }

  String cleanJson(String raw) {
    return raw.replaceAll('```json', '').replaceAll('```', '').trim();
  }

  String extractJson(dynamic response) {
    final choices = response['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No choices in response: ${response}');
    }
    final content = choices[0]?['message']?['content'] as String?;
    if (content == null) {
      throw Exception('No content in response message: ${choices[0]}');
    }
    final jsonString = cleanJson(
      response['choices'][0]['message']['content'],
    );
    return jsonString;
  }
}
