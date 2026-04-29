typedef ValidationResult = String?;

class Validators {
  static ValidationResult medicationName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Medication name is required';
    }
    if (value.length > 100) {
      return 'Medication name is too long';
    }
    return null;
  }

  static ValidationResult dosage(double? value) {
    if (value == null) {
      return 'Dosage is required';
    }
    if (value <= 0) {
      return 'Dosage must be greater than 0';
    }
    if (value > 9999) {
      return 'Dosage is too high';
    }
    return null;
  }

  static ValidationResult quantity(int? value) {
    if (value == null) {
      return 'Quantity is required';
    }
    if (value < 0) {
      return 'Quantity cannot be negative';
    }
    if (value > 99999) {
      return 'Quantity is too high';
    }
    return null;
  }
}
