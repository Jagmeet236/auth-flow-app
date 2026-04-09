import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/app_strings.dart';
import '../constants/app_colors.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Placeholder for Google icon.
            Spacer(),
            const Icon(Icons.g_mobiledata, size: 32, color: AppColors.primary),

            const Text(
              AppStrings.continueWithGoogle,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                CupertinoIcons.forward,
                size: 16,
                color: Colors.blue,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
