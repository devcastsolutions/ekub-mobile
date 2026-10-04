import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleSignInUseCase,
  }) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => emit(AuthSuccess(token)),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      name: event.name,
      email: event.email,
      phone: event.phone,
      password: event.password,
      role: event.role,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(RegisterSuccess(user)),
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await googleSignInUseCase();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) => emit(AuthSuccess(token)),
    );
  }
}
