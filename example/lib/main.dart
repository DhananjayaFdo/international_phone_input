import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'International Phone Input Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PhoneInputExample(),
    );
  }
}

class PhoneInputExample extends StatefulWidget {
  const PhoneInputExample({super.key});

  @override
  State<PhoneInputExample> createState() => _PhoneInputExampleState();
}

class _PhoneInputExampleState extends State<PhoneInputExample> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  Country? _selectedCountry;
  String _phoneNumber = '';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final fullNumber = _selectedCountry != null
          ? '+${_selectedCountry!.dialCode}$_phoneNumber'
          : _phoneNumber;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Country: ${_selectedCountry?.name ?? 'Not selected'}'),
              Text('Country Code: ${_selectedCountry?.code ?? 'N/A'}'),
              Text('Dial Code: +${_selectedCountry?.dialCode ?? 'N/A'}'),
              Text('Phone Number: $_phoneNumber'),
              const SizedBox(height: 12),
              Text(
                'Full Number: $fullNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('International Phone Input'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Phone Number Demo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try out the international phone input widget with country selection and validation.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Basic Example
              Text(
                'Basic Example',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              InternationalPhoneInput(
                controller: _phoneController,
                onChanged: (country, phoneNumber) {
                  setState(() {
                    _selectedCountry = country;
                    _phoneNumber = phoneNumber;
                  });
                },
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                isRequired: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

              const SizedBox(height: 32),

              // Custom Styled Example
              Text(
                'Custom Styled',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              InternationalPhoneInput(
                controller: TextEditingController(),
                onChanged: (country, phoneNumber) {},
                label: 'Styled Phone Input',
                hintText: 'Custom colors and borders',
                backgroundColor: Colors.blue.shade50,
                borderColor: Colors.blue.shade200,
                focusedBorderColor: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                countrySelectorBackgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                countryCodeStyle: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              // With Specific Country
              Text(
                'Pre-selected Country',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              InternationalPhoneInput(
                controller: TextEditingController(),
                initialCountry: countries.firstWhere((c) => c.code == 'LK'),
                onChanged: (country, phoneNumber) {},
                label: 'Sri Lanka Phone',
                hintText: 'Pre-selected to Sri Lanka',
              ),

              const SizedBox(height: 32),

              // Minimal Style
              Text(
                'Minimal Style',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              InternationalPhoneInput(
                controller: TextEditingController(),
                onChanged: (country, phoneNumber) {},
                hintText: 'Phone number',
                showDropdownIcon: false,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Form',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Current Selection Display
              if (_selectedCountry != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Selection:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          '${_selectedCountry!.flag} ${_selectedCountry!.name}'),
                      Text('Code: ${_selectedCountry!.code}'),
                      Text('Dial Code: +${_selectedCountry!.dialCode}'),
                      if (_phoneNumber.isNotEmpty)
                        Text(
                          'Full: +${_selectedCountry!.dialCode}$_phoneNumber',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
