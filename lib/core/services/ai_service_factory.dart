import 'package:flutter/foundation.dart';
import 'package:study_snap/core/mocks/AiMockService.dart';
import 'package:study_snap/core/services/ai_service.dart';
import 'package:study_snap/core/services/aiservice_interface.dart';

/// Factory to provide the appropriate AI service based on build mode
/// - Debug/Profile builds: Returns AiMockService (no API calls)
/// - Release builds: Returns AIService (real API calls)
class AiServiceFactory {
  static ApiServiceInterface create() {
    if (kReleaseMode) {
      // Production: Use real API service
      return AIService();
    } else {
      // Debug/Profile: Use mock service
      return AiMockService();
    }
  }
}
