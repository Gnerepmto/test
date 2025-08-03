import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'location_model.dart';

part 'producer_model.g.dart';

@JsonSerializable()
class Producer {
  final String id;
  final User user;
  final String farmName;
  final String description;
  final Location location;
  final double farmSizeHectares;
  final int cashewTreesCount;
  final double expectedYieldKg;
  final double pricePerKg;
  final List<String> certifications;
  final List<String> farmImages;
  final int experienceYears;
  final String harvestSeason;
  final Map<String, dynamic> soilAnalysis;
  final List<String> equipmentList;
  final double fundingGoal;
  final double currentFunding;
  final String projectDescription;
  final DateTime projectDeadline;
  final List<String> investorIds;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Producer({
    required this.id,
    required this.user,
    required this.farmName,
    required this.description,
    required this.location,
    required this.farmSizeHectares,
    required this.cashewTreesCount,
    required this.expectedYieldKg,
    required this.pricePerKg,
    this.certifications = const [],
    this.farmImages = const [],
    required this.experienceYears,
    required this.harvestSeason,
    this.soilAnalysis = const {},
    this.equipmentList = const [],
    required this.fundingGoal,
    this.currentFunding = 0.0,
    required this.projectDescription,
    required this.projectDeadline,
    this.investorIds = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Producer.fromJson(Map<String, dynamic> json) => _$ProducerFromJson(json);
  Map<String, dynamic> toJson() => _$ProducerToJson(this);

  double get fundingProgress => currentFunding / fundingGoal;
  double get remainingFunding => fundingGoal - currentFunding;
  bool get isFundingComplete => currentFunding >= fundingGoal;
  int get daysRemaining => projectDeadline.difference(DateTime.now()).inDays;
  
  String get profitabilityStatus {
    final profit = expectedYieldKg * pricePerKg - fundingGoal;
    if (profit > 0) return 'Rentable';
    if (profit == 0) return 'Équilibré';
    return 'Risqué';
  }

  Producer copyWith({
    String? id,
    User? user,
    String? farmName,
    String? description,
    Location? location,
    double? farmSizeHectares,
    int? cashewTreesCount,
    double? expectedYieldKg,
    double? pricePerKg,
    List<String>? certifications,
    List<String>? farmImages,
    int? experienceYears,
    String? harvestSeason,
    Map<String, dynamic>? soilAnalysis,
    List<String>? equipmentList,
    double? fundingGoal,
    double? currentFunding,
    String? projectDescription,
    DateTime? projectDeadline,
    List<String>? investorIds,
    double? rating,
    int? reviewsCount,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Producer(
      id: id ?? this.id,
      user: user ?? this.user,
      farmName: farmName ?? this.farmName,
      description: description ?? this.description,
      location: location ?? this.location,
      farmSizeHectares: farmSizeHectares ?? this.farmSizeHectares,
      cashewTreesCount: cashewTreesCount ?? this.cashewTreesCount,
      expectedYieldKg: expectedYieldKg ?? this.expectedYieldKg,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      certifications: certifications ?? this.certifications,
      farmImages: farmImages ?? this.farmImages,
      experienceYears: experienceYears ?? this.experienceYears,
      harvestSeason: harvestSeason ?? this.harvestSeason,
      soilAnalysis: soilAnalysis ?? this.soilAnalysis,
      equipmentList: equipmentList ?? this.equipmentList,
      fundingGoal: fundingGoal ?? this.fundingGoal,
      currentFunding: currentFunding ?? this.currentFunding,
      projectDescription: projectDescription ?? this.projectDescription,
      projectDeadline: projectDeadline ?? this.projectDeadline,
      investorIds: investorIds ?? this.investorIds,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Producer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Producer{id: $id, farmName: $farmName, location: ${location.city}}';
  }
}