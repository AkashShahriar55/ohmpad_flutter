import 'dart:async';

import 'package:ohm_pad/utils/strings.dart';



mixin InputValidator {
  // static final RegExp nameRegExp = RegExp('[a-zA-Z]');
  static final RegExp nmeRegExp = RegExp(r'[!@#<>?":_`~;.[\]\\|=+)(*&^%\s-]');
  static final RegExp digitRegex = new RegExp(Strings.DIGIT_PATTERN);
  static final RegExp specialRegex = new RegExp(Strings.SPECIAL_PATTERN);

  static String? validateEmail(String value) {
    String pattern = Strings.EMAIL_PATTERN;
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty) {
      return Strings.PLEASE_ENTER_EMAIL;
    } else if (!regex.hasMatch(value)) {
      return Strings.INVALID_EMAIL;
    } else if (!value.contains(".")) {
      return Strings.INVALID_EMAIL;
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return Strings.PLEASE_ENTER_PASSWORD;
    } else if (value.length < 6) {
      return Strings.INVALID_PASSWORD;
    }
    return null;
  }

  static String? validateNewPassword(String value) {
    if (value.isEmpty) {
      return Strings.PLEASE_ENTER_NEW_PASSWORD;
    } if (value.length < 6) {
      return Strings.INVALID_NEW_PASSWORD;
    }
    return null;
  }

  static String? validateOldPassword(String value) {
    if (value.isEmpty) {
      return Strings.PLEASE_ENTER_OLD_PASSWORD;
    } else if (value.length < 5) {
      return Strings.INVALID_OLD_PASSWORD;
    }
    return null;
  }

  static String? validateFirstName(String value) {
    if (value.trim().isEmpty) {
      return Strings.PLEASE_ENTER_FIRST_NAME;
    } else if (value.length < 2) {
      return Strings.INVALID_FIRST_NAME_LENGTH;
    } else if (digitRegex.hasMatch(value) || specialRegex.hasMatch(value)) {
      return Strings.INVALID_FIRST_NAME;
    }
    return null;
  }

  static String? validateLastName(String value) {
    if (value.trim().isEmpty) {
      return Strings.PLEASE_ENTER_LAST_NAME;
    } else if (value.length < 2) {
      return Strings.INVALID_LAST_NAME_LENGTH;
    } else if (digitRegex.hasMatch(value) || specialRegex.hasMatch(value)) {
      return Strings.INVALID_LAST_NAME;
    }
    return null;
  }

  static String? validateMobileNumber(String value) {
    if (value.trim().isEmpty) {
      return Strings.PLEASE_ENTER_MOBILE_NO;
    }else if (value.length < 10) {
      return Strings.INVALID_MOBILE_NUMBER;
    }
    return null;
  }

  static validateConfirmPassword(String value, String password) {
    print('value $value, pass $password');
    if (value.trim().isEmpty) {
      return Strings.PLEASE_ENTER_CONFIRM_PASSWORD;
    } else if (value.length < 6) {
      return Strings.INVALID_CONFIRM_PASSWORD;
    } else if (value != password) {
      return Strings.PASSWORD_NOT_MATCH;
    } else {
      return null;
    }
  }

  static validateCategoryName(String value) {
    if (value.trim().isEmpty) {
      return Strings.PLEASE_ENTER_CATEGORY_NAME;
    } else if (digitRegex.hasMatch(value) || specialRegex.hasMatch(value)) {
      return Strings.INVALID_CATEGORY_NAME;
    }
    return null;
  }

  static validateModuleName(value) {

    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ENTER_MODULE_NAME;
    }
    return null;
  }

  static validateModulePrice(value) {
    value = value.toString().replaceAll(Strings.CURRENCY, "");
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ENTER_MODULE_PRICE;
    }
    double _parsedValue = double.tryParse(value)!;
    if (_parsedValue == null) {
      return Strings.PLEASE_ENTER_VALID_PRICE;
    }
    return null;
  }

  static validateModuleDes(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ENTER_DISCRIPTION;
    }
    return null;
  }

  static validateDimention(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ENTER_DIMENTION;
    }
    return null;
  }

  static validateModularHouses(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ENTER_MODULAR_HOUSES;
    }
    return null;
  }

  static validateTermsOfSale(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_TERMS_OF_SALE;
    }
    return null;
  }

  static validateModularUnits(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_MODULAR_UNITS;
    }
    return null;
  }

  static validateUnitsPerTrailer(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_UNITS_PER_TRAILER;
    }
    return null;
  }

  static validateDestination(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_DESTINATION;
    }
    return null;
  }

  static validateTotalUnit(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_TOTAL_UNIT;
    }
    return null;
  }

  static validatePaymentMethods(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_PAYMENT_METHODS;
    }
    return null;
  }

  static validateConditions(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_CONDITIONS;
    }
    return null;
  }

  static validateUserName(value) {
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_USER_NAME;
    }
    return null;
  }

  static validateDiscount(value) {
    value = value.toString().replaceAll("%", "");
    if (value.toString().trim().isEmpty) {
      return Strings.PLEASE_ADD_DISCOUNT;
    }
    double _parsedValue = double.tryParse(value)!;
    if (_parsedValue == null) {
      return Strings.PLEASE_ADD_VALID_DISCOUNT;
    }
    return null;
  }
}
