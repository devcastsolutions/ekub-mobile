import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';

// Auth
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Groups
import 'features/groups/data/datasources/group_remote_data_source.dart';
import 'features/groups/data/repositories/group_repository_impl.dart';
import 'features/groups/domain/repositories/group_repository.dart';
import 'features/groups/domain/usecases/group_usecases.dart';
import 'features/groups/presentation/bloc/group_list_bloc.dart';

// Dashboard
import 'features/group_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'features/group_dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/group_dashboard/domain/repositories/dashboard_repository.dart';
import 'features/group_dashboard/presentation/bloc/dashboard_bloc.dart';

// Contributions
import 'features/contributions/data/datasources/contribution_remote_data_source.dart';
import 'features/contributions/data/repositories/contribution_repository_impl.dart';
import 'features/contributions/domain/repositories/contribution_repository.dart';
import 'features/contributions/presentation/bloc/contribution_bloc.dart';

// Payout Calendar
import 'features/payout_calendar/domain/usecases/get_payout_calendar_usecase.dart';
import 'features/payout_calendar/presentation/bloc/payout_calendar_bloc.dart';

// Member History
import 'features/member_history/data/datasources/member_status_remote_data_source.dart';
import 'features/member_history/data/repositories/member_status_repository_impl.dart';
import 'features/member_history/domain/repositories/member_status_repository.dart';
import 'features/member_history/presentation/bloc/member_history_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Features - Auth
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), registerUseCase: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));

  // Features - Groups
  sl.registerFactory(() => GroupListBloc(
        getMyGroupsUseCase: sl(),
        createGroupUseCase: sl(),
        startGroupUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetMyGroupsUseCase(sl()));
  sl.registerLazySingleton(() => CreateGroupUseCase(sl()));
  sl.registerLazySingleton(() => StartGroupUseCase(sl()));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(sl()));
  sl.registerLazySingleton<GroupRemoteDataSource>(() => GroupRemoteDataSourceImpl(sl()));

  // Features - Dashboard
  sl.registerFactory(() => DashboardBloc(getDashboardDataUseCase: sl()));
  sl.registerLazySingleton(() => GetDashboardDataUseCase(sl()));
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(sl()));
  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(sl()));

  // Features - Contributions
  sl.registerFactory(() => ContributionBloc(
        logContributionUseCase: sl(),
        closeRoundUseCase: sl(),
      ));
  sl.registerLazySingleton(() => LogContributionUseCase(sl()));
  sl.registerLazySingleton(() => CloseRoundUseCase(sl()));
  sl.registerLazySingleton<ContributionRepository>(() => ContributionRepositoryImpl(sl()));
  sl.registerLazySingleton<ContributionRemoteDataSource>(() => ContributionRemoteDataSourceImpl(sl()));

  // Features - Payout Calendar
  sl.registerFactory(() => PayoutCalendarBloc(getPayoutCalendarUseCase: sl()));
  sl.registerLazySingleton(() => GetPayoutCalendarUseCase(sl()));

  // Features - Member History
  sl.registerFactory(() => MemberHistoryBloc(getMyStatusUseCase: sl()));
  sl.registerLazySingleton(() => GetMyStatusUseCase(sl()));
  sl.registerLazySingleton<MemberStatusRepository>(() => MemberStatusRepositoryImpl(sl()));
  sl.registerLazySingleton<MemberStatusRemoteDataSource>(() => MemberStatusRemoteDataSourceImpl(sl()));
}
