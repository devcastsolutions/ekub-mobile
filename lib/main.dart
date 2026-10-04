import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/groups/presentation/bloc/group_list_bloc.dart';
import 'features/groups/presentation/screens/my_groups_screen.dart';
import 'features/group_dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/group_dashboard/presentation/screens/group_dashboard_screen.dart';
import 'features/contributions/presentation/bloc/contribution_bloc.dart';
import 'features/contributions/presentation/screens/add_contribution_screen.dart';
import 'features/payout_calendar/presentation/bloc/payout_calendar_bloc.dart';
import 'features/payout_calendar/presentation/screens/payout_calendar_screen.dart';
import 'features/member_history/presentation/bloc/member_history_bloc.dart';
import 'features/member_history/presentation/screens/member_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }
  await di.init();
  runApp(const EkubApp());
}

class EkubApp extends StatelessWidget {
  const EkubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<GroupListBloc>(create: (_) => di.sl<GroupListBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => di.sl<DashboardBloc>()),
        BlocProvider<ContributionBloc>(create: (_) => di.sl<ContributionBloc>()),
        BlocProvider<PayoutCalendarBloc>(create: (_) => di.sl<PayoutCalendarBloc>()),
        BlocProvider<MemberHistoryBloc>(create: (_) => di.sl<MemberHistoryBloc>()),
      ],
      child: MaterialApp(
        title: 'Ekub Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/auth',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/auth':
              return MaterialPageRoute(builder: (_) => const AuthScreen());
            case '/groups':
              return MaterialPageRoute(builder: (_) => const MyGroupsScreen());
            case '/group-dashboard':
              final groupId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => GroupDashboardScreen(groupId: groupId),
              );
            case '/add-contribution':
              final roundId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => AddContributionScreen(roundId: roundId),
              );
            case '/payout-calendar':
              final groupId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => PayoutCalendarScreen(groupId: groupId),
              );
            case '/member-history':
              final groupId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MemberHistoryScreen(groupId: groupId),
              );
            default:
              return MaterialPageRoute(builder: (_) => const AuthScreen());
          }
        },
      ),
    );
  }
}
