import 'package:ucl_assistant/helpers.dart';

// Extract the contiguous time slots that this space is available for
List<LibcalBookingSlot> getContiguousTimeRanges(List availability) {
  List<LibcalBookingSlot> contiguousSlots = [];
  String lastFromTime = '';
  String lastToTime = '';

  /**
   * Go through each FROM/TO slot pairing.
   * For the first slot, record the FROM/TO times.
   * From then on, if n+1's FROM == n's TO, then it's a contiguous block, so keep track of the new TO.
   * As soon as we find a FROM != the previous TO, the contiguous block ends, so add to list and reset vars.
   * Also do final check at end of loop in case contiguous block extends to end of day (end of availability list)
   */
  for (final slot in availability) {
    final from = slot['from'] as String;
    final to = slot['to'] as String;
    if (lastFromTime.isEmpty) {
      lastFromTime = from;
      lastToTime = to;
    } else if (lastToTime.isNotEmpty && from.contains(lastToTime)) {
      lastToTime = to;
    } else {
      contiguousSlots.add(LibcalBookingSlot(
          from: extractTimeString(lastFromTime),
          to: extractTimeString(lastToTime)));
      lastFromTime = '';
      lastToTime = '';
    }
  }

  if (lastFromTime.isNotEmpty && lastToTime.isNotEmpty) {
    contiguousSlots.add(LibcalBookingSlot(
        from: extractTimeString(lastFromTime),
        to: extractTimeString(lastToTime)));
  }

  return contiguousSlots;
}

class LibcalBookingSlot {
  const LibcalBookingSlot({
    required this.from,
    required this.to,
  });

  // Constructor accepts 2 formats: "04:30" or "2021-01-14T09:00:00+00:00"
  final String from;
  final String to;

  // Map the second format to the first one
  String get _fromTime => from.contains('T')
      ? from.split('T').last.split(':').take(2).join(':')
      : from;

  String get _toTime =>
      to.contains('T') ? to.split('T').last.split(':').take(2).join(':') : to;

  double get fromDivision => convertTimeStringToNumericDivision(_fromTime);
  double get toDivision => convertTimeStringToNumericDivision(_toTime);

  bool contains(String time) {
    double timeDivision = convertTimeStringToNumericDivision(time);
    return timeDivision >= fromDivision && timeDivision <= toDivision;
  }

  @override
  String toString() {
    return '$_fromTime - $_toTime';
  }
}

class LibcalLocation {
  const LibcalLocation({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}

class LibcalSpace {
  LibcalSpace(
      {required this.spaceId,
      required this.name,
      required this.description,
      required this.isAccessible,
      required this.isPowered,
      required this.image,
      required this.availability});

  final int spaceId;
  final String name;
  final String description;
  final bool isAccessible;
  final bool isPowered;
  final String image;
  final List availability;
  List<LibcalBookingSlot>? _contiguousSlots;

  List<LibcalBookingSlot> get contiguousSlots =>
      _contiguousSlots ??= getContiguousTimeRanges(availability);
}

class LibcalSeat extends LibcalSpace {
  LibcalSeat({
    required spaceId,
    required name,
    required description,
    required isAccessible,
    required isPowered,
    required image,
    required availability,
    required this.seatId,
  }) : super(
            spaceId: spaceId,
            name: name,
            description: description,
            isAccessible: isAccessible,
            isPowered: isPowered,
            image: image,
            availability: availability);

  final int seatId;
}

class LibcalGroupSpace extends LibcalSpace {
  LibcalGroupSpace({
    required spaceId,
    required name,
    required description,
    required isAccessible,
    required isPowered,
    required image,
    required availability,
    required this.capacity,
  }) : super(
            spaceId: spaceId,
            name: name,
            description: description,
            isAccessible: isAccessible,
            isPowered: isPowered,
            image: image,
            availability: availability);

  final int capacity;
}

class LibcalBooking {
  const LibcalBooking({
    required this.bookingId,
    required this.seatName,
    required this.locationName,
    required this.slot,
    required this.status,
    required this.checkInCode,
    this.cancelledDate,
  });

  final String bookingId;
  final String seatName;
  final String locationName;
  final LibcalBookingSlot slot;
  final String status;
  final String? cancelledDate;
  final String checkInCode;
}
