import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../group_dashboard/domain/entities/dashboard_entities.dart';
import '../../domain/usecases/get_payout_calendar_usecase.dart';

abstract class PayoutCalendarEvent extends Equatable {
  const PayoutCalendarEvent();
  @override
  List<Object?> get props => [];
}

class LoadPayoutCalendar extends PayoutCalendarEvent {
  final int groupId;
  const LoadPayoutCalendar(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

abstract class PayoutCalendarState extends Equatable {
  const PayoutCalendarState();
  @override
  List<Object?> get props => [];
}

class PayoutCalendarInitial extends PayoutCalendarState {}
class PayoutCalendarLoading extends PayoutCalendarState {}
class PayoutCalendarLoaded extends PayoutCalendarState {
  final List<EkubRound> rounds;
  const PayoutCalendarLoaded(this.rounds);
  @override
  List<Object?> get props => [rounds];
}
class PayoutCalendarError extends PayoutCalendarState {
  final String message;
  const PayoutCalendarError(this.message);
  @override
  List<Object?> get props => [message];
}

class PayoutCalendarBloc extends Bloc<PayoutCalendarEvent, PayoutCalendarState> {
  final GetPayoutCalendarUseCase getPayoutCalendarUseCase;

  PayoutCalendarBloc({required this.getPayoutCalendarUseCase}) : super(PayoutCalendarInitial()) {
    on<LoadPayoutCalendar>((event, emit) async {
      emit(PayoutCalendarLoading());
      final result = await getPayoutCalendarUseCase(event.groupId);
      result.fold(
        (failure) => emit(PayoutCalendarError(failure.message)),
        (rounds) => emit(PayoutCalendarLoaded(rounds)),
      );
    });
  }
}
