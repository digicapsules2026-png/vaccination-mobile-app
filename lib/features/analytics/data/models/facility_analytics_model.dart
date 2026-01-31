class FacilityAnalyticsModel {
  final int facilityId;
  final String facilityName;
  final int totalUsers;
  final int doctorsCount;
  final int staffCount;
  final int vaccinationsCompleted;
  final int vaccinationsPending;
  final int vaccinationsLast30Days;
  final int vaccinationsToday;
  final int upcomingDueVaccinations;
  final int missedVaccinations;

  FacilityAnalyticsModel({
    required this.facilityId,
    required this.facilityName,
    required this.totalUsers,
    required this.doctorsCount,
    required this.staffCount,
    required this.vaccinationsCompleted,
    required this.vaccinationsPending,
    required this.vaccinationsLast30Days,
    required this.vaccinationsToday,
    required this.upcomingDueVaccinations,
    required this.missedVaccinations,
  });

  factory FacilityAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return FacilityAnalyticsModel(
      facilityId: json['facility_id'] as int,
      facilityName: json['facility_name'] as String,
      totalUsers: json['total_users'] as int? ?? 0,
      doctorsCount: json['doctors_count'] as int? ?? 0,
      staffCount: json['staff_count'] as int? ?? 0,
      vaccinationsCompleted: json['vaccinations_completed'] as int? ?? 0,
      vaccinationsPending: json['vaccinations_pending'] as int? ?? 0,
      vaccinationsLast30Days: json['vaccinations_last_30_days'] as int? ?? 0,
      vaccinationsToday: json['vaccinations_today'] as int? ?? 0,
      upcomingDueVaccinations: json['upcoming_due_vaccinations'] as int? ?? 0,
      missedVaccinations: json['missed_vaccinations'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facility_id': facilityId,
      'facility_name': facilityName,
      'total_users': totalUsers,
      'doctors_count': doctorsCount,
      'staff_count': staffCount,
      'vaccinations_completed': vaccinationsCompleted,
      'vaccinations_pending': vaccinationsPending,
      'vaccinations_last_30_days': vaccinationsLast30Days,
      'vaccinations_today': vaccinationsToday,
      'upcoming_due_vaccinations': upcomingDueVaccinations,
      'missed_vaccinations': missedVaccinations,
    };
  }
}

class DailyTrendItem {
  final String date;
  final int count;

  DailyTrendItem({
    required this.date,
    required this.count,
  });

  factory DailyTrendItem.fromJson(Map<String, dynamic> json) {
    return DailyTrendItem(
      date: json['date'] as String,
      count: json['count'] as int,
    );
  }
}

class VaccineDistributionItem {
  final String vaccineName;
  final int count;
  final double percentage;

  VaccineDistributionItem({
    required this.vaccineName,
    required this.count,
    required this.percentage,
  });

  factory VaccineDistributionItem.fromJson(Map<String, dynamic> json) {
    return VaccineDistributionItem(
      vaccineName: json['vaccine_name'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}


