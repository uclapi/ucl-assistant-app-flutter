class Room {
  const Room({
    required this.name,
    required this.classification,
    required this.address,
    required this.capacity,
    required this.siteid,
    required this.roomid,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String classification;
  final String address;
  final int capacity;
  final String siteid;
  final String roomid;
  final double? latitude;
  final double? longitude;
}
