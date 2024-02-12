// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChatView(
          key: args.key,
          device: args.device,
          service: args.service,
        ),
      );
    },
    DeviceListRoute.name: (routeData) {
      final args = routeData.argsAs<DeviceListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DeviceListView(
          key: args.key,
          type: args.type,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeView(),
      );
    },
  };
}

/// generated route for
/// [ChatView]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required Device device,
    required NearbyService service,
    List<PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            device: device,
            service: service,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const PageInfo<ChatRouteArgs> page = PageInfo<ChatRouteArgs>(name);
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.device,
    required this.service,
  });

  final Key? key;

  final Device device;

  final NearbyService service;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, device: $device, service: $service}';
  }
}

/// generated route for
/// [DeviceListView]
class DeviceListRoute extends PageRouteInfo<DeviceListRouteArgs> {
  DeviceListRoute({
    Key? key,
    required DeviceType type,
    List<PageRouteInfo>? children,
  }) : super(
          DeviceListRoute.name,
          args: DeviceListRouteArgs(
            key: key,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'DeviceListRoute';

  static const PageInfo<DeviceListRouteArgs> page =
      PageInfo<DeviceListRouteArgs>(name);
}

class DeviceListRouteArgs {
  const DeviceListRouteArgs({
    this.key,
    required this.type,
  });

  final Key? key;

  final DeviceType type;

  @override
  String toString() {
    return 'DeviceListRouteArgs{key: $key, type: $type}';
  }
}

/// generated route for
/// [HomeView]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
