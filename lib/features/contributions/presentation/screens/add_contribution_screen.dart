import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/contribution_bloc.dart';
import '../bloc/contribution_event_state.dart';

class AddContributionScreen extends StatelessWidget {
  final int roundId;
  const AddContributionScreen({super.key, required this.roundId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Contributions - Round #$roundId')),
      body: BlocListener<ContributionBloc, ContributionState>(
        listener: (context, state) {
          if (state is ContributionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          } else if (state is RoundClosedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Round successfully closed!'), backgroundColor: AppColors.success),
            );
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Text('Contribution Checklist & Member Payout Control'),
                ),
              ),
              BlocBuilder<ContributionBloc, ContributionState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: 'Close Round & Dispatch Payout',
                    isLoading: state is ContributionLoading,
                    onPressed: () {
                      context.read<ContributionBloc>().add(CloseRoundRequested(roundId));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
