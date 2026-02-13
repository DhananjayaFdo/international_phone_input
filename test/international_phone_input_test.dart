import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:international_phone_input/international_phone_input.dart';

void main() {
  group('InternationalPhoneInput Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      Country? selectedCountry;
      String? phoneNumber;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneInput(
              controller: controller,
              onChanged: (country, phone) {
                selectedCountry = country;
                phoneNumber = phone;
              },
            ),
          ),
        ),
      );

      // Verify widget is rendered
      expect(find.byType(InternationalPhoneInput), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('displays label when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneInput(
              controller: controller,
              onChanged: (country, phone) {},
              label: 'Phone Number',
            ),
          ),
        ),
      );

      expect(find.text('Phone Number'), findsOneWidget);
    });

    testWidgets('shows required asterisk when isRequired is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneInput(
              controller: controller,
              onChanged: (country, phone) {},
              label: 'Phone',
              isRequired: true,
            ),
          ),
        ),
      );

      expect(find.text(' *'), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes',
        (WidgetTester tester) async {
      Country? selectedCountry;
      String? phoneNumber;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneInput(
              controller: controller,
              onChanged: (country, phone) {
                selectedCountry = country;
                phoneNumber = phone;
              },
            ),
          ),
        ),
      );

      // Enter phone number
      await tester.enterText(find.byType(TextFormField), '1234567890');
      await tester.pump();

      expect(phoneNumber, '1234567890');
      expect(selectedCountry, isNotNull);
    });

    testWidgets('validates phone number length',
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: InternationalPhoneInput(
                controller: controller,
                onChanged: (country, phone) {},
                isRequired: true,
                autovalidateMode: AutovalidateMode.always,
              ),
            ),
          ),
        ),
      );

      // Try to validate with empty field
      formKey.currentState!.validate();
      await tester.pump();

      // Should show error
      expect(find.text('Phone number is required'), findsOneWidget);
    });

    testWidgets('accepts valid phone number', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: InternationalPhoneInput(
                controller: controller,
                initialCountry: countries.firstWhere((c) => c.code == 'US'),
                onChanged: (country, phone) {},
                autovalidateMode: AutovalidateMode.always,
              ),
            ),
          ),
        ),
      );

      // Enter valid US number (10 digits)
      await tester.enterText(find.byType(TextFormField), '1234567890');
      await tester.pump();

      final isValid = formKey.currentState!.validate();
      expect(isValid, true);
    });

    testWidgets('opens country picker on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InternationalPhoneInput(
              controller: controller,
              onChanged: (country, phone) {},
            ),
          ),
        ),
      );

      // Find and tap the country selector
      final countrySelector = find.byType(InkWell).first;
      await tester.tap(countrySelector);
      await tester.pumpAndSettle();

      // Bottom sheet should be visible
      expect(find.text('Select Country'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search field
    });

    testWidgets('custom validator works', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: InternationalPhoneInput(
                controller: controller,
                onChanged: (country, phone) {},
                customValidator: (phone, country) {
                  if (phone == '123') {
                    return 'Cannot be 123';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.always,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '123');
      await tester.pump();

      expect(find.text('Cannot be 123'), findsOneWidget);
    });
  });

  group('Country Model Tests', () {
    test('fullDialCode returns correct format', () {
      const country = Country(
        name: 'United States',
        nameTranslations: {},
        flag: '🇺🇸',
        code: 'US',
        dialCode: '1',
        minLength: 10,
        maxLength: 10,
      );

      expect(country.fullDialCode, '+1');
    });

    test('getTranslatedName returns translation when available', () {
      const country = Country(
        name: 'United States',
        nameTranslations: {'es': 'Estados Unidos'},
        flag: '🇺🇸',
        code: 'US',
        dialCode: '1',
        minLength: 10,
        maxLength: 10,
      );

      expect(country.getTranslatedName('es'), 'Estados Unidos');
    });

    test('getTranslatedName returns English name when translation unavailable',
        () {
      const country = Country(
        name: 'United States',
        nameTranslations: {},
        flag: '🇺🇸',
        code: 'US',
        dialCode: '1',
        minLength: 10,
        maxLength: 10,
      );

      expect(country.getTranslatedName('fr'), 'United States');
    });

    test('equality works based on country code', () {
      const country1 = Country(
        name: 'United States',
        nameTranslations: {},
        flag: '🇺🇸',
        code: 'US',
        dialCode: '1',
        minLength: 10,
        maxLength: 10,
      );

      const country2 = Country(
        name: 'United States',
        nameTranslations: {},
        flag: '🇺🇸',
        code: 'US',
        dialCode: '1',
        minLength: 10,
        maxLength: 10,
      );

      expect(country1 == country2, true);
    });
  });

  group('Countries Data Tests', () {
    test('countries list is not empty', () {
      expect(countries.isNotEmpty, true);
      expect(countries.length, greaterThan(200));
    });

    test('all countries have required fields', () {
      for (final country in countries) {
        expect(country.name.isNotEmpty, true);
        expect(country.code.isNotEmpty, true);
        expect(country.dialCode.isNotEmpty, true);
        expect(country.flag.isNotEmpty, true);
        expect(country.minLength, greaterThan(0));
        expect(country.maxLength, greaterThanOrEqualTo(country.minLength));
      }
    });

    test('can find country by code', () {
      final us = countries.firstWhere((c) => c.code == 'US');
      expect(us.name, 'United States');
      expect(us.dialCode, '1');
    });

    test('can find country by dial code', () {
      final uk = countries.firstWhere((c) => c.dialCode == '44');
      expect(uk.code, 'GB');
    });
  });
}
