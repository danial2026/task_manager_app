import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/features/auth/presentation/controllers/google_auth_controller.dart';
import 'auth_state.dart';
import '../../domain/user.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = User(
        id: '1',
        email: email,
        createdAt: DateTime.now(),
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = User(
        id: '1',
        email: email,
        createdAt: DateTime.now(),
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void signOut() {
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final userCredential = await GoogleAuthController().signIn();
      if (userCredential != null) {
        final user = User(
          id: userCredential.user?.uid ?? '',
          email: userCredential.user?.email ?? '',
          createdAt: userCredential.user?.metadata.creationTime ?? DateTime.now(),
          name: userCredential.user?.displayName ?? '',
        );
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          ),
        );
      } else {
        emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Failed to sign in with Google'));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }
}
