/// Represents a country with phone number validation rules.
class Country {
  /// The English name of the country.
  final String name;

  /// Translations of the country name in different languages.
  final Map<String, String> nameTranslations;

  /// The country's flag emoji.
  final String flag;

  /// ISO 3166-1 alpha-2 country code.
  final String code;

  /// International dialing code (without the + prefix).
  final String dialCode;

  /// Minimum number of digits allowed for phone numbers.
  final int minLength;

  /// Maximum number of digits allowed for phone numbers.
  final int maxLength;

  const Country({
    required this.name,
    required this.nameTranslations,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.minLength,
    required this.maxLength,
  });

  /// Returns the country name in the specified language, or English if not available.
  String getTranslatedName(String languageCode) {
    return nameTranslations[languageCode] ?? name;
  }

  /// Returns the full international format: +XX
  String get fullDialCode => '+$dialCode';

  @override
  String toString() => '$flag $name (+$dialCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
