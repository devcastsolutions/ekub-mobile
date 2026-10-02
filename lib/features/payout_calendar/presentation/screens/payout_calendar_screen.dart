import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../bloc/payout_calendar_bloc.dart';

class PayoutCalendarScreen extends StatefulWidget {
  final int groupId;
  const PayoutCalendarScreen({super.key, required this.groupId});

  @override
  State<PayoutCalendarScreen> createState() => _PayoutCalendarScreenState();
}

class _PayoutCalendarScreenState extends State<PayoutCalendarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PayoutCalendarBloc>().add(LoadPayoutCalendar(widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payout Schedule & Turn Order')),
      body: BlocBuilder<PayoutCalendarBloc, PayoutCalendarState>(
        builder: (context, state) {
          if (state is PayoutCalendarLoading) {
            return const LoadingIndicator(message: 'Loading payout calendar...');
          } else if (state is PayoutCalendarError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<PayoutCalendarBloc>().add(LoadPayoutCalendar(widget.groupId)),
            );
          } else if (state is PayoutCalendarLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.rounds.length,
              itemBuilder: (context, index) {
                final r = state.rounds[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${r.roundNumber}')),
                    title: Text('Turn #${r.roundNumber} - Member ID ${r.payoutMemberId}'),
                    subtitle: Text('Payout Date: ${r.dueDate}'),
                    trailing: Text(r.status.toUpperCase()),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
