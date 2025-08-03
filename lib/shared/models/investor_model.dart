import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'investor_model.g.dart';

@JsonSerializable()
class Investor {
  final String id;
  final User user;
  final String investorType; // 'individual', 'company', 'institution'
  final String? companyName;
  final double availableFunds;
  final double totalInvested;
  final List<String> investmentPreferences; // 'organic', 'large-scale', 'small-scale', etc.
  final List<String> preferredRegions;
  final double minInvestmentAmount;
  final double maxInvestmentAmount;
  final int riskTolerance; // 1-5 scale
  final List<String> activeInvestments; // project IDs
  final List<String> completedInvestments;
  final double averageReturn;
  final int totalProjects;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Investor({
    required this.id,
    required this.user,
    required this.investorType,
    this.companyName,
    required this.availableFunds,
    this.totalInvested = 0.0,
    this.investmentPreferences = const [],
    this.preferredRegions = const [],
    required this.minInvestmentAmount,
    required this.maxInvestmentAmount,
    required this.riskTolerance,
    this.activeInvestments = const [],
    this.completedInvestments = const [],
    this.averageReturn = 0.0,
    this.totalProjects = 0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Investor.fromJson(Map<String, dynamic> json) => _$InvestorFromJson(json);
  Map<String, dynamic> toJson() => _$InvestorToJson(this);

  String get displayName => companyName ?? user.fullName;
  double get portfolioValue => totalInvested + availableFunds;
  int get totalActiveProjects => activeInvestments.length;
  bool get isInstitutional => investorType != 'individual';
  
  String get riskProfile {
    switch (riskTolerance) {
      case 1:
        return 'Très conservateur';
      case 2:
        return 'Conservateur';
      case 3:
        return 'Modéré';
      case 4:
        return 'Agressif';
      case 5:
        return 'Très agressif';
      default:
        return 'Non défini';
    }
  }

  bool canInvest(double amount) {
    return amount >= minInvestmentAmount && 
           amount <= maxInvestmentAmount && 
           amount <= availableFunds;
  }

  Investor copyWith({
    String? id,
    User? user,
    String? investorType,
    String? companyName,
    double? availableFunds,
    double? totalInvested,
    List<String>? investmentPreferences,
    List<String>? preferredRegions,
    double? minInvestmentAmount,
    double? maxInvestmentAmount,
    int? riskTolerance,
    List<String>? activeInvestments,
    List<String>? completedInvestments,
    double? averageReturn,
    int? totalProjects,
    double? rating,
    int? reviewsCount,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Investor(
      id: id ?? this.id,
      user: user ?? this.user,
      investorType: investorType ?? this.investorType,
      companyName: companyName ?? this.companyName,
      availableFunds: availableFunds ?? this.availableFunds,
      totalInvested: totalInvested ?? this.totalInvested,
      investmentPreferences: investmentPreferences ?? this.investmentPreferences,
      preferredRegions: preferredRegions ?? this.preferredRegions,
      minInvestmentAmount: minInvestmentAmount ?? this.minInvestmentAmount,
      maxInvestmentAmount: maxInvestmentAmount ?? this.maxInvestmentAmount,
      riskTolerance: riskTolerance ?? this.riskTolerance,
      activeInvestments: activeInvestments ?? this.activeInvestments,
      completedInvestments: completedInvestments ?? this.completedInvestments,
      averageReturn: averageReturn ?? this.averageReturn,
      totalProjects: totalProjects ?? this.totalProjects,
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
      other is Investor &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Investor{id: $id, displayName: $displayName, type: $investorType}';
  }
}