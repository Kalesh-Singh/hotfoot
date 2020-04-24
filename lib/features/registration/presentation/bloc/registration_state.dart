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
  final String message;

  bool get isFormValid => isEmailValid && isPasswordValid;

  RegistrationState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isEmailVerified,
    @required this.message,
  });

  factory RegistrationState.empty() {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isEmailVerified: false,
      message: '',
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
      message: 'Loading',
    );
  }

  factory RegistrationState.failure(String failureMessage) {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isEmailVerified: false,
      message: failureMessage,
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
      message: 'Registration Success',
    );
  }

  factory RegistrationState.successUnverified() {
    return RegistrationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isEmailVerified: false,
      message: 'Email is unverified',
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
    String message,
  }) {
    return RegistrationState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      message: message ?? this.message,
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
      message: $message,
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
        message,
      ];
}
