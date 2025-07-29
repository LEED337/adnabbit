class ScreenLocation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String status; // 'online', 'offline', 'maintenance'
  final String resolution;
  final double screenSize;
  final List<String> supportedFormats;
  final double pricePerHour;
  final String ownerId;
  final Map<String, dynamic> schedule; // Available time slots
  final int viewsPerDay;
  final String category; // 'retail', 'transport', 'outdoor', etc.

  ScreenLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.resolution,
    required this.screenSize,
    required this.supportedFormats,
    required this.pricePerHour,
    required this.ownerId,
    required this.schedule,
    required this.viewsPerDay,
    required this.category,
  });

  factory ScreenLocation.fromJson(Map<String, dynamic> json) {
    return ScreenLocation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'offline',
      resolution: json['resolution'] ?? '1920x1080',
      screenSize: (json['screenSize'] ?? 0.0).toDouble(),
      supportedFormats: List<String>.from(json['supportedFormats'] ?? []),
      pricePerHour: (json['pricePerHour'] ?? 0.0).toDouble(),
      ownerId: json['ownerId'] ?? '',
      schedule: json['schedule'] ?? {},
      viewsPerDay: json['viewsPerDay'] ?? 0,
      category: json['category'] ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'resolution': resolution,
      'screenSize': screenSize,
      'supportedFormats': supportedFormats,
      'pricePerHour': pricePerHour,
      'ownerId': ownerId,
      'schedule': schedule,
      'viewsPerDay': viewsPerDay,
      'category': category,
    };
  }
}