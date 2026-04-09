import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final results = snapshot.data ?? [];
        final bool isOffline = results.contains(ConnectivityResult.none);
        
        return Stack(
          children: [
            child,
            if (isOffline)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.red,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Text(
                      'Network unavailable',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
