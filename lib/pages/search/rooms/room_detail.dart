import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/room.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetail extends StatelessWidget {
  const RoomDetail({super.key, required this.room});
  final Room room;

  Future<List> getEquipment() async {
    return await API().rooms().getEquipment(room.roomid, room.siteid).then(
          (result) => result['content']['equipment'],
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEquipment(),
      builder: (context, equipmentSnapshot) {
        final List equipment =
            equipmentSnapshot.hasData ? (equipmentSnapshot.data as List) : [];

        if (equipmentSnapshot.hasError) {
          Sentry.captureException(equipmentSnapshot.error,
              stackTrace: equipmentSnapshot.stackTrace);
        }

        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(child: Header(text: room.name, bold: true)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    room.classification,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Capacity: ${room.capacity}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(5)),
              Text(room.address),
              if (room.latitude != null && room.longitude != null) ...[
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(
                          room.latitude as double, room.longitude as double),
                      zoom: 17,
                    ),
                    nonRotatedChildren: [
                      AttributionWidget.defaultWidget(
                        source: 'OpenStreetMap contributors',
                        onSourceTapped: () {
                          launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright'));
                        },
                      ),
                    ],
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.uclapi.uclassistant',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(room.latitude as double,
                                room.longitude as double),
                            width: 180,
                            height: 180,
                            builder: (context) => const Icon(
                              Icons.pin_drop,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              GradientButton(
                onPressed: () => openMaps(
                  latitude: room.latitude,
                  longitude: room.longitude,
                  name: room.name,
                ),
                height: 50,
                child: const Text('Directions'),
              ),
              if (equipment.isNotEmpty) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Header(text: 'In this room'),
                    ...equipment.map(
                      (e) => Text('${e['units']}x ${e['description']}'),
                    ),
                  ],
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
