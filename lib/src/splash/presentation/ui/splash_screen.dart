import 'package:auth_flow_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/repository/splash_repository.dart';
import '../navigator/splash_navigator.dart';
import '../viewmodel/splash_viewmodel.dart';
import '../../../auth/presentation/ui/auth_screen.dart';
import '../../../home/presentation/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState
    extends
        BaseState<
          SplashScreen,
          SplashViewModel,
          SplashNavigator,
          SplashRepository
        >
    implements SplashNavigator {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init();
    });
  }

  @override
  Widget buildScreen(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          AppStrings.splashTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void navigateToAuthScreen() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  void navigateToHomeScreen() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }
}
