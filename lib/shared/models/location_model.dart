import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class Location {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String region;
  final String country;
  final String? postalCode;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.region,
    this.country = 'Bénin',
    this.postalCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  String get fullAddress => '$address, $city, $region, $country';

  Location copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? region,
    String? country,
    String? postalCode,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'Location{city: $city, region: $region}';
  }
}