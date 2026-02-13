/// A Flutter package for international phone number input with country selection.
///
/// Features:
/// - 240+ countries with dial codes
/// - Automatic phone number validation
/// - Country picker with search
/// - Customizable styling
/// - Form integration support
///
/// Example:
/// ```dart
/// InternationalPhoneInput(
///   controller: phoneController,
///   onChanged: (country, phoneNumber) {
///     print('Country: ${country.name}');
///     print('Phone: +${country.dialCode}$phoneNumber');
///   },
/// )
/// ```
library international_phone_input;

export 'src/widgets/international_phone_input.dart';
export 'src/models/country.dart';
export 'src/data/countries_data.dart';
