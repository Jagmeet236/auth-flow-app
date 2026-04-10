import 'package:auth_flow_app/core/extensions/color_extensions.dart';
import 'package:flutter/material.dart';

class LessonDetail {
  final String lessonId;
  final String locale;
  final List<String> locales;
  final String title;
  final String descriptionTitle;
  final String descriptionText;
  final String descriptionType;
  final String descriptionUrl;
  final String shortDescription;
  final String thumbnailUrl;
  final String tileColorHex;
  final String status;
  final String lessonType;

  LessonDetail({
    required this.lessonId,
    required this.locale,
    required this.locales,
    required this.title,
    required this.descriptionTitle,
    required this.descriptionText,
    required this.descriptionType,
    required this.descriptionUrl,
    required this.shortDescription,
    required this.thumbnailUrl,
    required this.tileColorHex,
    required this.status,
    required this.lessonType,
  });

  Color get tileColor => HexColor.fromHex(tileColorHex);

  factory LessonDetail.fromJson(Map<String, dynamic> json) {
    return LessonDetail(
      lessonId: json['lesson_id'] as String? ?? '',
      locale: json['locale'] as String? ?? '',
      locales: (json['locales'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      title: json['title'] as String? ?? '',
      descriptionTitle: json['description_title'] as String? ?? '',
      descriptionText: json['description_text'] as String? ?? '',
      descriptionType: json['description_type'] as String? ?? '',
      descriptionUrl: json['description_url'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      tileColorHex: json['tile_color'] as String? ?? '#ffffff',
      status: json['status'] as String? ?? '',
      lessonType: json['lesson_type'] as String? ?? '',
    );
  }
}
