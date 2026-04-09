import 'package:auth_flow_app/core/di/service_locator.dart';
import 'package:auth_flow_app/core/theme/app_theme.dart';
import 'package:auth_flow_app/src/auth/presentation/ui/auth_screen.dart';

import 'package:auth_flow_app/src/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => locator<AuthViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Auth Flow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthScreen(),
      ),
    );
  }
}
