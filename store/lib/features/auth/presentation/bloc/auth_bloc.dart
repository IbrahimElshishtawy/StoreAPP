import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/util/two_factor_auth_service.dart';
import 'package:store/features/auth/domain/usecases/auth_usecases.dart';
import 'package:store/features/auth/presentation/bloc/auth_event.dart';
import 'package:store/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final TwoFactorAuthService twoFactorAuthService;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.twoFactorAuthService,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      final result = await getCurrentUserUseCase();
      result.fold(
        (failure) => emit(Unauthenticated()),
        (user) => emit(Authenticated(user)),
      );
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(event.email, event.password);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await registerUseCase(
        event.email,
        event.password,
        event.firstName,
        event.lastName,
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<LogoutRequested>((event, emit) async {
      await logoutUseCase();
      emit(Unauthenticated());
    });

    on<TwoFactorAuthRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await twoFactorAuthService.verifyPhoneNumber(
          event.phoneNumber,
          (credential) {
            // Auto verification
          },
          (exception) {
            add(LogoutRequested()); // Or handle error
          },
          (verificationId, resendToken) {
            emit(TwoFactorAuthRequired(verificationId));
          },
          (verificationId) {
            // Timeout
          },
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyTwoFactorCodeRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await twoFactorAuthService.signInWithCode(event.verificationId, event.smsCode);
        final result = await getCurrentUserUseCase();
        result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(Authenticated(user)),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
