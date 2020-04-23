import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class RegistrationState extends Equatable {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isEmailVerified;

  bool get isFormValid => isEmailValid && isPasswordValid;

  RegistrationState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isEmailVerified,
  });

  factory RegistrationState.empty() {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isEmailVerified: false,
    );
  }

  factory RegistrationState.loading() {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isEmailVerified: false,
    );
  }

  factory RegistrationState.failure() {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isEmailVerified: false,
    );
  }

  factory RegistrationState.success() {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isEmailVerified: true,
    );
  }

  factory RegistrationState.successUnverified() {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isEmailVerified: true,
    );
  }

  RegistrationState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isEmailVerified: false,
    );
  }

  RegistrationState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isEmailVerified,
  }) {
    return RegistrationState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  String toString() {
    return '''RegistrationState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isEmailVerified: $isEmailVerified,
    }''';
  }

  @override
  List<Object> get props => [
        isEmailValid,
        isPasswordValid,
        isSubmitting,
        isSuccess,
        isFailure,
        isEmailVerified,
      ];
}
