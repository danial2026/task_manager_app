import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/profile.dart';

enum ProfileStatus { initial, loading, success, error, signedOut }

class ProfileState {
  final Profile? profile;
  final ProfileStatus status;
  final String? errorMessage;

  const ProfileState({
    this.profile,
    this.status = ProfileStatus.initial,
    this.errorMessage,
  });

  ProfileState copyWith({
    Profile? profile,
    ProfileStatus? status,
    String? errorMessage,
  }) =>
      ProfileState(
        profile: profile ?? this.profile,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final profile = Profile(
        id: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        lastLoginAt: user.metadata.lastSignInTime,
      );

      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      if (name != null) {
        await user.updateDisplayName(name);
      }

      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      await loadProfile();
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      // TODO: Implement sign out for FirebaseFirestore
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      emit(const ProfileState(
        status: ProfileStatus.signedOut,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
