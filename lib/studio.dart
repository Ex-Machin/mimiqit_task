class Studio {
  final String name;
  final String address;
  final String description;
  final String style;
  final double longitude;
  final double latitude;

  Studio({
    required this.name,
    required this.address,
    required this.description,
    required this.style,
    required this.longitude,
    required this.latitude,
  });

  factory Studio.fromMap(Map<String, dynamic> data) {
    return Studio(
      name: data['name'],
      address: data['address'],
      description: data['description'],
      style: data['style'],
      longitude: data['longitude'],
      latitude: data['latitude'],
    );
  }
}