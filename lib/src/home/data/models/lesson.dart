import 'package:auth_flow_app/core/extensions/color_extensions.dart';
import 'package:flutter/material.dart';

class Lesson {
  final String lessonId;
  final String title;
  final String thumbnailUrl;
  final String shortDescription;
  final String tileColorHex;
  final String targetUserType;
  final List<String> locales;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.lessonId,
    required this.title,
    required this.thumbnailUrl,
    required this.shortDescription,
    required this.tileColorHex,
    required this.targetUserType,
    required this.locales,
    required this.createdAt,
    required this.updatedAt,
  });

  Color get tileColor => HexColor.fromHex(tileColorHex);

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lesson_id'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown Title',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      tileColorHex: json['tile_color'] as String? ?? '#E0E0E0',
      targetUserType: json['target_user_type'] as String? ?? '',
      locales: (json['locales'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }
}

class LessonResponse {
  final List<Lesson> lessons;

  LessonResponse({required this.lessons});

  factory LessonResponse.fromJson(Map<String, dynamic> json) {
    return LessonResponse(
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
