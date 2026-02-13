import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/country.dart';
import '../data/countries_data.dart';
import 'country_picker_bottom_sheet.dart';

/// A customizable international phone number input field with country selector.
///
/// Features:
/// - Country picker with search functionality
/// - Automatic phone number validation based on country
/// - Support for 240+ countries
/// - Customizable styling
/// - Form validation support
///
/// Example:
/// ```dart
/// InternationalPhoneInput(
///   controller: phoneController,
///   onChanged: (country, phoneNumber) {
///     print('${country.dialCode} $phoneNumber');
///   },
/// )
/// ```
class InternationalPhoneInput extends StatefulWidget {
  /// Controller for the phone number text field.
  final TextEditingController controller;

  /// Callback when the phone number or country changes.
  /// Parameters: (selectedCountry, phoneNumber)
  final Function(Country country, String phoneNumber) onChanged;

  /// Initial country selection. Defaults to the first country in the list.
  final Country? initialCountry;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text shown in the input field.
  final String hintText;

  /// Whether this field is required (shows asterisk).
  final bool isRequired;

  /// Padding around the entire widget.
  final EdgeInsetsGeometry? padding;

  /// Form validation mode.
  final AutovalidateMode? autovalidateMode;

  /// Whether the field is enabled.
  final bool enabled;

  /// Custom error message when phone number is invalid.
  final String? Function(String? phoneNumber, Country country)? customValidator;

  /// Border radius for the input field.
  final BorderRadius? borderRadius;

  /// Background color of the input field.
  final Color? backgroundColor;

  /// Border color of the input field.
  final Color? borderColor;

  /// Border color when the field has focus.
  final Color? focusedBorderColor;

  /// Border color when there's an error.
  final Color? errorBorderColor;

  /// Text style for the phone number.
  final TextStyle? textStyle;

  /// Text style for the hint text.
  final TextStyle? hintStyle;

  /// Text style for the label.
  final TextStyle? labelStyle;

  /// Text style for error messages.
  final TextStyle? errorStyle;

  /// Background color of the country selector button.
  final Color? countrySelectorBackgroundColor;

  /// Text style for the country code (+XX).
  final TextStyle? countryCodeStyle;

  /// Whether to show the country flag.
  final bool showFlag;

  /// Whether to show the dropdown arrow icon.
  final bool showDropdownIcon;

  /// Custom decoration for the input field.
  /// If provided, most other styling properties are ignored.
  final InputDecoration? customDecoration;

  /// Height of the input field.
  final double? height;

  /// Padding inside the input field.
  final EdgeInsetsGeometry? contentPadding;

  /// Default error message for invalid phone numbers.
  final String invalidPhoneNumberMessage;

  /// Error message when phone number is required but empty.
  final String requiredFieldMessage;

  const InternationalPhoneInput({
    super.key,
    required this.controller,
    required this.onChanged,
    this.initialCountry,
    this.label,
    this.hintText = 'Enter phone number',
    this.isRequired = false,
    this.padding,
    this.autovalidateMode,
    this.enabled = true,
    this.customValidator,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.countrySelectorBackgroundColor,
    this.countryCodeStyle,
    this.showFlag = true,
    this.showDropdownIcon = true,
    this.customDecoration,
    this.height,
    this.contentPadding,
    this.invalidPhoneNumberMessage = 'Invalid phone number',
    this.requiredFieldMessage = 'Phone number is required',
  });

  @override
  State<InternationalPhoneInput> createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  final FocusNode _focusNode = FocusNode();
  late Country _selectedCountry;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeCountry();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(InternationalPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCountry != null &&
        widget.initialCountry != oldWidget.initialCountry) {
      setState(() {
        _selectedCountry = widget.initialCountry!;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeCountry() {
    if (widget.initialCountry != null) {
      _selectedCountry = widget.initialCountry!;
    } else {
      // Default to first country in the list
      _selectedCountry = countries.first;
    }
    // Notify parent of initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(_selectedCountry, widget.controller.text);
    });
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  String? _validatePhoneNumber(String? value) {
    // Use custom validator if provided
    if (widget.customValidator != null) {
      return widget.customValidator!(value, _selectedCountry);
    }

    if (value == null || value.isEmpty) {
      return widget.isRequired ? widget.requiredFieldMessage : null;
    }

    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < _selectedCountry.minLength) {
      return '${widget.invalidPhoneNumberMessage} (min ${_selectedCountry.minLength} digits)';
    }

    if (digitsOnly.length > _selectedCountry.maxLength) {
      return '${widget.invalidPhoneNumberMessage} (max ${_selectedCountry.maxLength} digits)';
    }

    return null;
  }

  Future<void> _showCountryPicker() async {
    if (!widget.enabled) return;

    final selected = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountryPickerBottomSheet(
        selectedCountry: _selectedCountry,
        onCountrySelected: (country) {
          Navigator.pop(context, country);
        },
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedCountry = selected;
      });
      widget.onChanged(selected, widget.controller.text);
    }
  }

  Widget _buildCountrySelector() {
    final theme = Theme.of(context);
    final defaultBackgroundColor = _isFocused
        ? (theme.primaryColor.withOpacity(0.05))
        : Colors.grey.shade100;

    return InkWell(
      onTap: widget.enabled ? _showCountryPicker : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.enabled
              ? (widget.countrySelectorBackgroundColor ?? defaultBackgroundColor)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showFlag) ...[
              Text(
                _selectedCountry.flag,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              '+${_selectedCountry.dialCode}',
              style: widget.countryCodeStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: widget.enabled ? Colors.black87 : Colors.grey,
                  ),
            ),
            if (widget.showDropdownIcon) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: widget.enabled ? Colors.black54 : Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    final defaultBorderColor = widget.borderColor ?? Colors.grey.shade300;
    final defaultFocusedBorderColor =
        widget.focusedBorderColor ?? theme.primaryColor;
    final defaultErrorBorderColor =
        widget.errorBorderColor ?? theme.colorScheme.error;

    return Padding(
      padding: widget.padding ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label!,
                    style: widget.labelStyle ??
                        const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                  if (widget.isRequired)
                    Text(
                      ' *',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

          // Phone input field
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            keyboardType: TextInputType.phone,
            autovalidateMode: widget.autovalidateMode,
            inputFormatters: [
              LengthLimitingTextInputFormatter(_selectedCountry.maxLength),
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: _validatePhoneNumber,
            onChanged: (value) {
              widget.onChanged(_selectedCountry, value);
            },
            style: widget.textStyle,
            decoration: widget.customDecoration ??
                InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle ??
                      TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                  filled: true,
                  fillColor: widget.enabled
                      ? (widget.backgroundColor ?? Colors.white)
                      : Colors.grey.shade100,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCountrySelector(),
                        Container(
                          height: 30,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                    borderSide: BorderSide(color: defaultBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                    borderSide: BorderSide(color: defaultBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                    borderSide: BorderSide(
                      color: defaultFocusedBorderColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                    borderSide: BorderSide(color: defaultErrorBorderColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: defaultBorderRadius,
                    borderSide: BorderSide(
                      color: defaultErrorBorderColor,
                      width: 2,
                    ),
                  ),
                  errorStyle: widget.errorStyle ??
                      TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                      ),
                ),
          ),
        ],
      ),
    );
  }
}
