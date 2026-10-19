/*
Реализовать цепочку валидаторов форм (required, minLength, pattern) для TextField, EmailField, NumberField.
*/

typedef FieldValidator = String? Function(String? value);

class FormValidator {
  final List<FieldValidator> _validators = [];

  FormValidator add(FieldValidator validator) {
    _validators.add(validator);
    return this;
  }

  FormValidator required([String message = 'Заполните поле']) {
    return add((value) => (value == null || value.trim().isEmpty) ? message : null);
  }

  FormValidator minLength(int min, [String? message]) {
    return add((value) {
      if (value != null && value.isNotEmpty && value.length < min) {
        return message ?? 'Минимум $min символов';
      }
      return null;
    });
  }

  FormValidator pattern(RegExp regExp, String message) {
    return add((value) {
      if (value != null && value.isNotEmpty && !regExp.hasMatch(value)) {
        return message;
      }
      return null;
    });
  }

  String? validate(String? value) {
    for (final validator in _validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  String? call(String? value) => validate(value);
}