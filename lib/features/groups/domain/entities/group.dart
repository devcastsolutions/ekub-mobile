import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final int id;
  final String name;
  final int organizerId;
  final double contributionAmount;
  final String frequency;
  final String startDate;
  final String status;

  const Group({
    required this.id,
    required this.name,
    required this.organizerId,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        organizerId,
        contributionAmount,
        frequency,
        startDate,
        status,
      ];
}
