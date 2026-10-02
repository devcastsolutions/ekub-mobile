import 'package:equatable/equatable.dart';

class EkubRound extends Equatable {
  final int id;
  final int groupId;
  final int roundNumber;
  final String dueDate;
  final int payoutMemberId;
  final String status;

  const EkubRound({
    required this.id,
    required this.groupId,
    required this.roundNumber,
    required this.dueDate,
    required this.payoutMemberId,
    required this.status,
  });

  @override
  List<Object?> get props => [id, groupId, roundNumber, dueDate, payoutMemberId, status];
}

class GroupMember extends Equatable {
  final int id;
  final int groupId;
  final int userId;
  final int? turnOrder;
  final bool hasBeenPaidOut;

  const GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    this.turnOrder,
    required this.hasBeenPaidOut,
  });

  @override
  List<Object?> get props => [id, groupId, userId, turnOrder, hasBeenPaidOut];
}
