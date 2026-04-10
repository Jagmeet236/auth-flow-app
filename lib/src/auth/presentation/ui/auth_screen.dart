import 'package:auth_flow_app/core/base/base_state.dart';
import 'package:auth_flow_app/src/auth/domain/repository/auth_repository.dart';
import 'package:auth_flow_app/src/auth/presentation/navigator/auth_navigator.dart';
import 'package:auth_flow_app/src/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:auth_flow_app/core/constants/app_colors.dart';
import 'package:auth_flow_app/core/constants/app_strings.dart';
import 'package:auth_flow_app/core/widgets/auth_tab_bar.dart';
import 'package:auth_flow_app/core/widgets/custom_text_field.dart';
import 'package:auth_flow_app/core/widgets/primary_button.dart';
import 'package:auth_flow_app/core/widgets/social_button.dart';
import '../viewmodel/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState
    extends BaseState<AuthScreen, AuthViewModel, AuthNavigator, AuthRepository>
    implements AuthNavigator {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isLoginMode = ValueNotifier<bool>(true);
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _isLoginMode.dispose();
    super.dispose();
  }

  @override
  Widget buildScreen(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isLoginMode,
                  builder: (context, isLogin, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AuthTabBar(
                          isLoginMode: isLogin,
                          onTabChanged: (value) {
                            _isLoginMode.value = value;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Consumer<AuthViewModel>(
                            builder: (context, viewModel, child) {
                              return Column(
                                children: [
                                  SocialButton(
                                    onPressed: () {
                                      viewModel.googleLogin();
                                    },
                                  ),

                                  const SizedBox(height: 24),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? AppColors.borderDark
                                              : AppColors.borderLight,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          AppStrings.or,
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? AppColors.borderDark
                                              : AppColors.borderLight,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  Row(
                                    children: [
                                      const Text(
                                        AppStrings.usernameLabel,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        CupertinoIcons.info,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    hintText: AppStrings.usernameHint,
                                    controller: _usernameController,
                                    errorText: _usernameError,
                                  ),

                                  const SizedBox(height: 16),

                                  Row(
                                    children: [
                                      const Text(
                                        AppStrings.passwordLabel,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        CupertinoIcons.info,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    hintText: AppStrings.passwordHint,
                                    controller: _passwordController,
                                    isPassword: true,
                                    maxLength: 6,
                                    errorText: _passwordError,
                                  ),

                                  const SizedBox(height: 32),

                                  PrimaryButton(
                                    text: isLogin
                                        ? AppStrings.signInButton
                                        : AppStrings.signUpButton,
                                    isLoading: viewModel.isLoading,
                                    onPressed: () {
                                      setState(() {
                                        _usernameError = null;
                                        _passwordError = null;

                                        final username = _usernameController
                                            .text
                                            .trim();
                                        final password =
                                            _passwordController.text;
                                        bool isValid = true;
                                        if (username.isEmpty) {
                                          _usernameError =
                                              'Field cannot be empty';
                                          isValid = false;
                                        } else if (username.length < 3) {
                                          _usernameError =
                                              'Username must be at least 3 characters';
                                          isValid = false;
                                        } else if (username.contains(' ')) {
                                          _usernameError =
                                              'Username should not contain spaces';
                                          isValid = false;
                                        }

                                        if (password.isEmpty) {
                                          _passwordError =
                                              'Field cannot be empty';
                                          isValid = false;
                                        } else if (password.length != 6) {
                                          _passwordError =
                                              'Must be exactly 6 characters';
                                          isValid = false;
                                        }

                                        if (isValid) {
                                          if (isLogin) {
                                            viewModel.login(username, password);
                                          } else {
                                            viewModel.signup(
                                              username,
                                              password,
                                            );
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
