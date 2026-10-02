import '../../domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.organizerId,
    required super.contributionAmount,
    required super.frequency,
    required super.startDate,
    required super.status,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as int,
      name: json['name'] as String,
      organizerId: json['organizer_id'] as int,
      contributionAmount: (json['contribution_amount'] as num).toDouble(),
      frequency: json['frequency'] as String,
      startDate: json['start_date'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organizer_id': organizerId,
      'contribution_amount': contributionAmount,
      'frequency': frequency,
      'start_date': startDate,
      'status': status,
    };
  }
}
