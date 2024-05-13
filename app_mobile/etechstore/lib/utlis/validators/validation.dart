class TValidator {
  //email validate
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Chưa nhập Email.';
    }

    const emailRegex = r'^[a-z0-9]+@[a-z]+\.[a-z]{2,}$';
    final regex = RegExp(emailRegex);

    if (!regex.hasMatch(value)) {
      return 'Email sai định dạng.';
    }
    return null;
  }

  //Empty text validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName chưa nhập';
    }
    return null;
  }

  // Function to validate the password
  static String? _validatePassword(String password) {
    // Reset error message
    String errorMessage = '';
    // Password length greater than 6
    if (password.length < 6) {
      errorMessage += 'Password must be longer than 6 characters.\n';
    }
    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errorMessage += '• Uppercase letter is missing.\n';
    }
    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      errorMessage += '• Lowercase letter is missing.\n';
    }
    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      errorMessage += '• Digit is missing.\n';
    }
    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      errorMessage += '• Special character is missing.\n';
    }
    // If there are no error messages, the password is valid
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegExp = RegExp(r'^\{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }
    return null;
  }
}
