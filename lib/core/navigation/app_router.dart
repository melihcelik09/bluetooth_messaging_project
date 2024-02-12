import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/chat_view.dart';
import 'package:bluetooth_messaging_project/app/views/device_list/view/device_list_view.dart';
import 'package:bluetooth_messaging_project/app/views/home/view/home_view.dart';
import 'package:bluetooth_messaging_project/core/enum/chat_type.dart';
import 'package:bluetooth_messaging_project/core/enum/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "View,Route")
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: DeviceListRoute.page),
    AutoRoute(page: ChatRoute.page),
  ];
}
