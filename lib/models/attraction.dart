class Attraction {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String address;

  Attraction({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'category': category,
    'description': description, 'imageUrl': imageUrl,
    'latitude': latitude, 'longitude': longitude, 'address': address,
  };

  factory Attraction.fromMap(Map<String, dynamic> map) => Attraction(
    id: map['id'], name: map['name'], category: map['category'],
    description: map['description'], imageUrl: map['imageUrl'],
    latitude: map['latitude'], longitude: map['longitude'],
    address: map['address'],
  );
}