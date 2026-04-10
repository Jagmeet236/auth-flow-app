import 'package:auth_flow_app/core/base/base_state.dart';
import 'package:auth_flow_app/core/constants/app_colors.dart';
import 'package:auth_flow_app/core/constants/app_strings.dart';
import 'package:auth_flow_app/core/extensions/color_extensions.dart';
import 'package:auth_flow_app/src/home/domain/repository/lesson_repository.dart';
import 'package:auth_flow_app/src/home/presentation/navigator/lesson_navigator.dart';
import 'package:auth_flow_app/src/home/presentation/ui/widgets/lesson_card.dart';
import 'package:auth_flow_app/src/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;
  final String? initialTitle;
  final String? initialTileColorHex;

  const LessonDetailScreen({
    super.key,
    required this.lessonId,
    this.initialTitle,
    this.initialTileColorHex,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState
    extends
        BaseState<
          LessonDetailScreen,
          HomeViewModel,
          LessonNavigator,
          LessonRepository
        >
    implements LessonNavigator {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchLessonDetailAndActivities(widget.lessonId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ── LessonNavigator ──────────────────────────────────────────────────────
  @override
  void navigateToAuthScreen() {}

  @override
  void navigateToHomeScreen() =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  void navigateToLessonDetail(String lessonId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LessonDetailScreen(lessonId: lessonId)),
    );
  }

  // ────────────────────────────────────────────────────────────────────────
  @override
  Widget buildScreen(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        final detail = vm.currentLessonDetail;

        // Use tile color from loaded detail, fall back to passed-in hint,
        // then fall back to primary app color.
        Color appBarColor;
        if (detail != null) {
          appBarColor = detail.tileColor;
        } else if (widget.initialTileColorHex != null) {
          appBarColor = HexColor.fromHex(widget.initialTileColorHex!);
        } else {
          appBarColor = AppColors.primary;
        }

        final luminance = appBarColor.computeLuminance();
        final onAppBar = luminance > 0.5 ? Colors.black : Colors.white;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            iconTheme: IconThemeData(color: onAppBar),
            title: Text(
              detail?.title ??
                  widget.initialTitle ??
                  AppStrings.lessonDetailTitle,
              style: TextStyle(color: onAppBar, fontWeight: FontWeight.w600),
            ),
          ),
          body: _buildBody(context, vm),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel vm) {
    // Loading and no data yet
    if (vm.isLoading && vm.currentLessonDetail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error and no data
    if (vm.errorMessage != null && vm.currentLessonDetail == null) {
      return _buildError(context, vm);
    }

    // Data available (even if still loading activities)
    if (vm.currentLessonDetail != null) {
      return _buildContent(context, vm);
    }

    // Fallback (shouldn't happen)
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(BuildContext context, HomeViewModel vm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.couldNotLoadLesson,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),

            const SizedBox(height: 44),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton.icon(
                onPressed: () =>
                    vm.fetchLessonDetailAndActivities(widget.lessonId),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppStrings.retry),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeViewModel vm) {
    final detail = vm.currentLessonDetail!;
    final activities = vm.currentActivities;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return RefreshIndicator(
      onRefresh: () => vm.fetchLessonDetailAndActivities(widget.lessonId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Thumbnail ──────────────────────────────────────────────
            if (detail.thumbnailUrl.isNotEmpty)
              Image.network(
                detail.thumbnailUrl,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),

            // ── Meta chips (type + status) ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  if (detail.lessonType.isNotEmpty)
                    _Chip(label: detail.lessonType, color: detail.tileColor),
                  if (detail.lessonType.isNotEmpty && detail.status.isNotEmpty)
                    const SizedBox(width: 8),
                  if (detail.status.isNotEmpty)
                    _Chip(
                      label: detail.status,
                      color: detail.status.toLowerCase() == 'published'
                          ? const Color(0xFF4CAF50)
                          : Colors.orange,
                    ),
                ],
              ),
            ),

            // ── Title ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                detail.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),

            // ── Short description ──────────────────────────────────────
            if (detail.shortDescription.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Text(
                  detail.shortDescription,
                  style: TextStyle(fontSize: 14, color: textSecondary),
                ),
              ),

            // ── Divider ────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, thickness: 1),
            ),

            // ── Description block ──────────────────────────────────────
            if (detail.descriptionTitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  detail.descriptionTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            if (detail.descriptionText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  detail.descriptionText,
                  style: const TextStyle(fontSize: 15, height: 1.55),
                ),
              ),

            // ── Activities section ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  const Text(
                    AppStrings.activitiesLabel,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (vm.isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),

            if (!vm.isLoading && activities.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Text(
                  AppStrings.noActivitiesAvailable,
                  style: TextStyle(color: textSecondary),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                padding: const EdgeInsets.only(bottom: 24),
                itemBuilder: (context, index) {
                  return LessonCard(lesson: activities[index], onTap: () {});
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ── Small reusable chip widget ───────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
