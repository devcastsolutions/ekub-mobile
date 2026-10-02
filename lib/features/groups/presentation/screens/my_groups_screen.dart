import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../bloc/group_list_bloc.dart';
import '../bloc/group_list_event.dart';
import '../bloc/group_list_state.dart';
import '../widgets/group_card.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupListBloc>().add(FetchMyGroups());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ekub Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<GroupListBloc>().add(FetchMyGroups()),
          ),
        ],
      ),
      body: BlocBuilder<GroupListBloc, GroupListState>(
        builder: (context, state) {
          if (state is GroupListLoading) {
            return const LoadingIndicator(message: 'Loading your groups...');
          } else if (state is GroupListError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<GroupListBloc>().add(FetchMyGroups()),
            );
          } else if (state is GroupListLoaded) {
            if (state.groups.isEmpty) {
              return const Center(
                child: Text('You belong to no groups yet.'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];
                return GroupCard(
                  group: group,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/group-dashboard',
                      arguments: group.id,
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Open create group dialog or route
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Group'),
      ),
    );
  }
}
