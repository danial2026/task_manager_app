import 'package:equatable/equatable.dart';

// SplashStatus Enum
enum SplashStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

// SplashState
class SplashState extends Equatable {
  final SplashStatus status;

  const SplashState({this.status = SplashStatus.initial});

  SplashState copyWith({SplashStatus? status}) {
    return SplashState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
