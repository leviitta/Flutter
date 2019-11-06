import 'package:flutter_test/flutter_test.dart';
import 'package:mi_primera_app/app/sign_in/validators.dart';

void main() {
  test('empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''), false);
  });

  test('null string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(null), false);
  });
}
