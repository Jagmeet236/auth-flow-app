import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AuthTabBar extends StatelessWidget {
  final bool isLoginMode;
  final ValueChanged<bool> onTabChanged;

  const AuthTabBar({
    super.key,
    required this.isLoginMode,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              title: AppStrings.signIn,
              isSelected: isLoginMode,
              onTap: () => onTabChanged(true),
            ),
          ),
          Container(width: 1, height: 30, color: borderColor),
          Expanded(
            child: _TabItem(
              title: AppStrings.createAccount,
              isSelected: !isLoginMode,
              onTap: () => onTabChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Highlighter with greyish color
    final highlightColor = isDark
        ? Colors.white10
        : Colors.black.withValues(alpha: 0.09);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? highlightColor : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }
}
