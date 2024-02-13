import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_messaging_project/core/enum/chat_type.dart';
import 'package:bluetooth_messaging_project/core/enum/device_type.dart';
import 'package:bluetooth_messaging_project/core/navigation/app_router.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

@RoutePage()
class DeviceListView extends StatefulWidget {
  final DeviceType type;
  const DeviceListView({super.key, required this.type});

  @override
  State<DeviceListView> createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  List<Device> selectedDevices = [];
  late NearbyService nearbyService;
  late DeviceInfoPlugin deviceInfo;
  late StreamSubscription subscription;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nearbyService = NearbyService();
    deviceInfo = DeviceInfoPlugin();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final info = await deviceInfo.deviceInfo;
      await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: info.data["name"],
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (widget.type == DeviceType.browser) {
            await nearbyService.stopBrowsingForPeers();
            await nearbyService.startBrowsingForPeers();
          } else {
            await nearbyService.stopAdvertisingPeer();
            await nearbyService.stopBrowsingForPeers();
            await nearbyService.startAdvertisingPeer();
            await nearbyService.startBrowsingForPeers();
          }
        },
      );
    });
    subscription = nearbyService.stateChangedSubscription(
      callback: (nearby) {
        setState(() {
          devices.clear();
          devices.addAll(nearby);
          connectedDevices.clear();
          connectedDevices.addAll(
            nearby
                .where((element) => element.state == SessionState.connected)
                .toList(),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.name.toUpperCase()),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.type == DeviceType.advertiser
                  ? connectedDevices.length
                  : devices.length,
              itemBuilder: (BuildContext context, int index) {
                Device device = widget.type == DeviceType.advertiser
                    ? connectedDevices[index]
                    : devices[index];

                return ListTile(
                  trailing: widget.type == DeviceType.browser
                      ? IconButton(
                          icon: Icon(
                            selectedDevices
                                    .where((element) =>
                                        element.deviceId == device.deviceId)
                                    .isNotEmpty
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          onPressed: () {
                            setState(() {
                              if (selectedDevices.contains(device)) {
                                selectedDevices.remove(device);
                              } else {
                                selectedDevices.add(device);
                              }
                            });
                          },
                        )
                      : null,
                  title: Text(device.deviceName),
                  // onTap: () async {
                  //   if (widget.type == DeviceType.browser) {
                  //     await nearbyService.invitePeer(
                  //       deviceID: device.deviceId,
                  //       deviceName: device.deviceName,
                  //     );
                  //     if (!context.mounted) return;
                  //     context.router.push(
                  //       ChatRoute(
                  //         device: device,
                  //         service: nearbyService,
                  //       ),
                  //     );
                  //   } else {
                  //     context.router.push(
                  //       ChatRoute(
                  //         device: device,
                  //         service: nearbyService,
                  //       ),
                  //     );
                  //   }
                  // },
                );
              },
            ),
            ElevatedButton.icon(
              onPressed: () async {
                if (widget.type == DeviceType.browser) {
                  for (Device device in selectedDevices) {
                    await nearbyService.invitePeer(
                      deviceID: device.deviceId,
                      deviceName: device.deviceName,
                    );
                  }
                  if (!context.mounted) return;
                  context.router.push(
                    ChatRoute(
                      devices: selectedDevices,
                      service: nearbyService,
                      type: ChatType.group,
                    ),
                  );
                } else {
                  context.router.push(
                    ChatRoute(
                      devices: widget.type == DeviceType.advertiser
                          ? connectedDevices
                          : devices,
                      service: nearbyService,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.group_add),
              label: Text(
                widget.type == DeviceType.browser
                    ? 'Create a Chat'
                    : 'Join a Chat',
              ),
            )
          ],
        ),
      ),
    );
  }
}
