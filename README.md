# international_phone_input

A customizable Flutter widget for international phone number input with country selection, automatic validation, and support for 240+ countries.

[![pub package](https://img.shields.io/pub/v/international_phone_input.svg)](https://pub.dev/packages/international_phone_input)

## Features

✨ **240+ Countries** - Comprehensive country database with dial codes  
📱 **Smart Validation** - Automatic validation based on country-specific rules  
🔍 **Searchable Picker** - Easy country search functionality  
🎨 **Highly Customizable** - Extensive styling options  
📋 **Form Integration** - Full Flutter form support  
🌍 **Multi-language** - Country names in 20+ languages  
♿ **Accessible** - Works with screen readers  
⚡ **Lightweight** - No external dependencies except Flutter

## Preview

![Demo](https://via.placeholder.com/400x800?text=Demo+Screenshot)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  international_phone_input: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:international_phone_input/international_phone_input.dart';

class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _phoneController = TextEditingController();
  Country? _selectedCountry;
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneInput(
      controller: _phoneController,
      onChanged: (country, phoneNumber) {
        setState(() {
          _selectedCountry = country;
          _phoneNumber = phoneNumber;
        });
        print('Full number: +${country.dialCode}$phoneNumber');
      },
      label: 'Phone Number',
      hintText: 'Enter your phone number',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
```

### With Form Validation

```dart
final _formKey = GlobalKey<FormState>();
final _phoneController = TextEditingController();

Form(
  key: _formKey,
  child: Column(
    children: [
      InternationalPhoneInput(
        controller: _phoneController,
        onChanged: (country, phoneNumber) {
          // Handle change
        },
        label: 'Phone Number',
        isRequired: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

### Custom Styling

```dart
InternationalPhoneInput(
  controller: _phoneController,
  onChanged: (country, phoneNumber) {},
  label: 'Phone Number',

  // Colors
  backgroundColor: Colors.grey.shade50,
  borderColor: Colors.grey.shade300,
  focusedBorderColor: Colors.blue,
  errorBorderColor: Colors.red,
  countrySelectorBackgroundColor: Colors.white,

  // Border
  borderRadius: BorderRadius.circular(16),

  // Text styles
  textStyle: TextStyle(fontSize: 16, color: Colors.black),
  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  hintStyle: TextStyle(color: Colors.grey),
  countryCodeStyle: TextStyle(fontWeight: FontWeight.w600),

  // Options
  showFlag: true,
  showDropdownIcon: true,
  height: 60,
  contentPadding: EdgeInsets.all(16),
)
```

### With Custom Validation

```dart
InternationalPhoneInput(
  controller: _phoneController,
  onChanged: (country, phoneNumber) {},
  customValidator: (phoneNumber, country) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Please enter a phone number';
    }

    if (country.code == 'US' && !phoneNumber.startsWith('1')) {
      return 'US numbers must start with 1';
    }

    return null; // Valid
  },
)
```

### Specific Country Selection

```dart
// Get a specific country
final sriLanka = countries.firstWhere((c) => c.code == 'LK');

InternationalPhoneInput(
  controller: _phoneController,
  initialCountry: sriLanka,
  onChanged: (country, phoneNumber) {},
)
```

### Complete Example with BLoC/State Management

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

BlocBuilder<SignUpBloc, SignUpState>(
  builder: (context, state) {
    return InternationalPhoneInput(
      controller: phoneController,
      initialCountry: state.selectedCountry,
      onChanged: (country, phoneNumber) {
        context.read<SignUpBloc>().add(
          PhoneNumberChanged(
            country: country,
            phoneNumber: phoneNumber,
          ),
        );
      },
      label: 'Phone Number',
      isRequired: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  },
)
```

## API Reference

### InternationalPhoneInput

#### Required Parameters

| Parameter    | Type                        | Description                                   |
| ------------ | --------------------------- | --------------------------------------------- |
| `controller` | `TextEditingController`     | Controller for the phone number input         |
| `onChanged`  | `Function(Country, String)` | Callback when phone number or country changes |

#### Optional Parameters

| Parameter                        | Type                  | Default                    | Description                |
| -------------------------------- | --------------------- | -------------------------- | -------------------------- |
| `initialCountry`                 | `Country?`            | First in list              | Initial country selection  |
| `label`                          | `String?`             | null                       | Label text above the field |
| `hintText`                       | `String`              | 'Enter phone number'       | Placeholder text           |
| `isRequired`                     | `bool`                | false                      | Shows asterisk if true     |
| `enabled`                        | `bool`                | true                       | Whether field is enabled   |
| `autovalidateMode`               | `AutovalidateMode?`   | null                       | Form validation mode       |
| `customValidator`                | `Function?`           | null                       | Custom validation function |
| `borderRadius`                   | `BorderRadius?`       | 12px                       | Border radius              |
| `backgroundColor`                | `Color?`              | White                      | Background color           |
| `borderColor`                    | `Color?`              | Grey                       | Border color               |
| `focusedBorderColor`             | `Color?`              | Primary                    | Focused border color       |
| `errorBorderColor`               | `Color?`              | Error                      | Error border color         |
| `textStyle`                      | `TextStyle?`          | null                       | Phone number text style    |
| `hintStyle`                      | `TextStyle?`          | null                       | Hint text style            |
| `labelStyle`                     | `TextStyle?`          | null                       | Label text style           |
| `errorStyle`                     | `TextStyle?`          | null                       | Error message style        |
| `countryCodeStyle`               | `TextStyle?`          | null                       | Country code (+XX) style   |
| `countrySelectorBackgroundColor` | `Color?`              | null                       | Country button background  |
| `showFlag`                       | `bool`                | true                       | Show country flag          |
| `showDropdownIcon`               | `bool`                | true                       | Show dropdown arrow        |
| `height`                         | `double?`             | null                       | Input field height         |
| `contentPadding`                 | `EdgeInsetsGeometry?` | null                       | Internal padding           |
| `padding`                        | `EdgeInsetsGeometry?` | null                       | External padding           |
| `invalidPhoneNumberMessage`      | `String`              | 'Invalid phone number'     | Error message              |
| `requiredFieldMessage`           | `String`              | 'Phone number is required' | Required error message     |

### Country Model

```dart
class Country {
  final String name;              // e.g., "United States"
  final Map<String, String> nameTranslations;  // Translations
  final String flag;              // e.g., "🇺🇸"
  final String code;              // ISO code, e.g., "US"
  final String dialCode;          // e.g., "1"
  final int minLength;            // Minimum digits
  final int maxLength;            // Maximum digits

  String get fullDialCode;        // Returns "+1"
  String getTranslatedName(String languageCode);
}
```

### Helper Methods

```dart
// Access all countries
import 'package:international_phone_input/international_phone_input.dart';

// Find a country by code
final usa = countries.firstWhere((c) => c.code == 'US');

// Find by dial code
final uk = countries.firstWhere((c) => c.dialCode == '44');

// Search countries
final filtered = countries.where((c) =>
  c.name.toLowerCase().contains('united')
).toList();
```

## Supported Countries

This package includes 240+ countries with:

- Accurate dial codes
- Min/max phone number lengths
- Flag emojis
- Translations in 20+ languages

Some examples:

- 🇺🇸 United States (+1)
- 🇬🇧 United Kingdom (+44)
- 🇮🇳 India (+91)
- 🇦🇪 UAE (+971)
- 🇱🇰 Sri Lanka (+94)
- 🇦🇺 Australia (+61)
- And 230+ more!

## Examples

Check out the [example](example) directory for:

- Basic usage
- Form integration
- Custom styling
- State management integration
- Custom validation

## Tips & Best Practices

### Getting the Complete Phone Number

```dart
InternationalPhoneInput(
  controller: _phoneController,
  onChanged: (country, phoneNumber) {
    // Complete international format
    final fullNumber = '+${country.dialCode}$phoneNumber';

    // Store separately for backend
    final data = {
      'country_code': country.code,
      'dial_code': country.dialCode,
      'phone_number': phoneNumber,
      'full_number': fullNumber,
    };
  },
)
```

### Persisting User Selection

```dart
// Save user's last selected country
SharedPreferences prefs = await SharedPreferences.getInstance();

// On selection
onChanged: (country, phoneNumber) {
  prefs.setString('last_country_code', country.code);
}

// On load
String? savedCode = prefs.getString('last_country_code');
Country? initialCountry = savedCode != null
    ? countries.firstWhere((c) => c.code == savedCode)
    : null;
```

### Custom Error Messages

```dart
InternationalPhoneInput(
  controller: _phoneController,
  onChanged: (country, phoneNumber) {},
  customValidator: (phoneNumber, country) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'We need your phone number to contact you';
    }

    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.length < country.minLength) {
      return '${country.name} requires at least ${country.minLength} digits';
    }

    return null;
  },
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Issues & Feedback

Please file issues, bugs, or feature requests on our [issue tracker](https://github.com/DhananjayaFdo/international_phone_input/issues).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please give it a ⭐ on [GitHub](https://github.com/DhananjayaFdo/international_phone_input)!

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## Credits

Country data compiled from official sources and ITU standards.

---

Made with ❤️ by the Flutter community
