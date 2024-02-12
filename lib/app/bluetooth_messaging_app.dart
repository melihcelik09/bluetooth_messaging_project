import 'package:bluetooth_messaging_project/core/navigation/app_router.dart';
import 'package:flutter/material.dart';

class BluetoothMessagingApp extends StatelessWidget {
  final _appRouter = AppRouter();
  BluetoothMessagingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
