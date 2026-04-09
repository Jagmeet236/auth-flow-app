import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/service_locator.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../../../auth/presentation/ui/auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Capture navigator reference safely
              final navigator = Navigator.of(context);

              await locator<AuthRepository>().logout();

              if (!mounted) return; // ensure the widget is still mounted

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider<AuthViewModel>(
                    create: (_) => locator<AuthViewModel>(),
                    child: const AuthScreen(),
                  ),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Welcome to the Home Screen!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
