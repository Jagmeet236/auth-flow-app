import 'package:auth_flow_app/core/base/base_state.dart';
import 'package:auth_flow_app/core/constants/app_strings.dart';
import 'package:auth_flow_app/core/di/service_locator.dart';
import 'package:auth_flow_app/core/extensions/media_query_extensions.dart';
import 'package:auth_flow_app/core/widgets/custom_text_field.dart';
import 'package:auth_flow_app/src/auth/domain/repository/auth_repository.dart';
import 'package:auth_flow_app/src/auth/presentation/ui/auth_screen.dart';
import 'package:auth_flow_app/src/home/domain/repository/lesson_repository.dart';
import 'package:auth_flow_app/src/home/presentation/navigator/lesson_navigator.dart';
import 'package:auth_flow_app/src/home/presentation/ui/lesson_detail_screen.dart';
import 'package:auth_flow_app/src/home/presentation/ui/widgets/lesson_card.dart';
import 'package:auth_flow_app/src/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState
    extends
        BaseState<HomeScreen, HomeViewModel, LessonNavigator, LessonRepository>
    implements LessonNavigator {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchLessons();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void navigateToHomeScreen() {
    // Already here
  }

  @override
  void navigateToAuthScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  void navigateToLessonDetail(String lessonId) {
    final lesson = viewModel.displayedLessons
        .where((l) => l.lessonId == lessonId)
        .firstOrNull;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
          lessonId: lessonId,
          initialTitle: lesson?.title,
          initialTileColorHex: lesson?.tileColorHex,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await locator<AuthRepository>().logout();
    if (!mounted) return;
    navigateToAuthScreen();
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomTextField(
            controller: _searchController,
            hintText: AppStrings.searchLessonsHint,
            prefixIcon: const Icon(Icons.search),
            onChanged: viewModel.searchLessons,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: AppStrings.logoutTooltip,
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.displayedLessons.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null &&
              viewModel.displayedLessons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.fetchLessons,
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            );
          }

          if (viewModel.displayedLessons.isEmpty) {
            return RefreshIndicator(
              onRefresh: viewModel.fetchLessons,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: context.screenHeight * 0.8,
                  alignment: Alignment.center,
                  child: const Text(AppStrings.noLessonsFound),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.fetchLessons,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
              itemCount: viewModel.displayedLessons.length,
              itemBuilder: (context, index) {
                final lesson = viewModel.displayedLessons[index];
                return LessonCard(
                  lesson: lesson,
                  onTap: () => navigateToLessonDetail(lesson.lessonId),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
