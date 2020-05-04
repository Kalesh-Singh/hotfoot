class HotfootUtil {

  static String _capitalize(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  static String parseBisonEmail(String email) {
    String firstNameDotLastname = email.substring(0, email.indexOf('@'));
    final nameArray = firstNameDotLastname.split(".");
    return _capitalize(nameArray[0]) + " " + _capitalize(nameArray[1]);
  }

}