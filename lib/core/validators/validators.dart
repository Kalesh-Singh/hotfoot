class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@bison.howard.edu',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}