import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_messaging_project/core/enum/device_type.dart';
import 'package:bluetooth_messaging_project/core/navigation/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.router.push(
                    DeviceListRoute(type: DeviceType.browser),
                  );
                },
                child: const Text('Start Browsing'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.router.push(
                    DeviceListRoute(type: DeviceType.advertiser),
                  );
                },
                child: const Text('Start Advertising'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
