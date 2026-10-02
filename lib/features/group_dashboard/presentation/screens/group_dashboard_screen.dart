import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event_state.dart';
import '../widgets/round_status_card.dart';

class GroupDashboardScreen extends StatefulWidget {
  final int groupId;
  const GroupDashboardScreen({super.key, required this.groupId});

  @override
  State<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardData(widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardBloc>().add(LoadDashboardData(widget.groupId)),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const LoadingIndicator(message: 'Loading dashboard data...');
          } else if (state is DashboardError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<DashboardBloc>().add(LoadDashboardData(widget.groupId)),
            );
          } else if (state is DashboardLoaded) {
            if (state.rounds.isEmpty) {
              return const Center(child: Text('No rounds created for this group yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.rounds.length,
              itemBuilder: (context, index) {
                final round = state.rounds[index];
                return RoundStatusCard(round: round);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
