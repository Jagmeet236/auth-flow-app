import 'package:flutter/material.dart';

extension HexColor on Color {
  /// Parses a string formatted as "#RRGGBB", "RRGGBB", "#AARRGGBB", or "AARRGGBB" and returns a [Color].
  /// Defaults to grey if parsing fails.
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    final stripped = hexString.replaceFirst('#', '');
    
    if (stripped.length == 6) {
      buffer.write('FF'); // Add max alpha
    }
    buffer.write(stripped);

    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey; // Fallback
    }
  }
}
