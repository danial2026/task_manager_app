import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/features/splash/presentation/bloc/splash_state.dart';
import 'package:task_manager_app/shared/utils/jwt_utils.dart';

// Cubit
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: SplashStatus.loading));

    try {
      // Ensure Firebase is initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(state.copyWith(status: SplashStatus.unauthenticated));
        return;
      }

      final idToken = await user.getIdToken();
      final isTokenExpired = await JWTUtils.isTokenExpired(idToken);
      if (idToken != null && !isTokenExpired) {
        emit(state.copyWith(status: SplashStatus.authenticated));
      } else {
        emit(state.copyWith(status: SplashStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(status: SplashStatus.unauthenticated));
    }
  }
}
