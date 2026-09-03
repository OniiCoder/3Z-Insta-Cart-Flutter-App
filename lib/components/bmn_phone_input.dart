import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';
import 'package:threezinstacart/components/bmn_text_input.dart';

class BmnCountryDialCode {
  final String name;
  final String code;
  final String dialCode;
  final String flag;
  final bool isAvailable;

  const BmnCountryDialCode({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
    this.isAvailable = false,
  });
}

class BmnPhoneInput extends StatefulWidget {
  final String? label;
  final String value;
  final ValueChanged<String>? onChange;
  final String? error;
  final bool disabled;
  final String placeholder;

  const BmnPhoneInput({
    super.key,
    this.label,
    required this.value,
    this.onChange,
    this.error,
    this.disabled = false,
    this.placeholder = 'Phone number',
  });

  @override
  State<BmnPhoneInput> createState() => _BmnPhoneInputState();
}

class _BmnPhoneInputState extends State<BmnPhoneInput> {
  static const List<BmnCountryDialCode> _countries = [
    BmnCountryDialCode(name: 'Ghana', code: 'GH', dialCode: '+233', flag: '🇬🇭', isAvailable: true),
    BmnCountryDialCode(name: 'Nigeria', code: 'NG', dialCode: '+234', flag: '🇳🇬', isAvailable: false),
    BmnCountryDialCode(name: 'Kenya', code: 'KE', dialCode: '+254', flag: '🇰🇪', isAvailable: false),
    BmnCountryDialCode(name: 'South Africa', code: 'ZA', dialCode: '+27', flag: '🇿🇦', isAvailable: false),
    BmnCountryDialCode(name: 'United Kingdom', code: 'GB', dialCode: '+44', flag: '🇬🇧', isAvailable: false),
    BmnCountryDialCode(name: 'United States', code: 'US', dialCode: '+1', flag: '🇺🇸', isAvailable: false),
    BmnCountryDialCode(name: 'Canada', code: 'CA', dialCode: '+1', flag: '🇨🇦', isAvailable: false),
  ];

  late TextEditingController _controller;
  BmnCountryDialCode _selectedCountry = _countries[0];

  @override
  void initState() {
    super.initState();
    _parseValue();
  }

  @override
  void didUpdateWidget(covariant BmnPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _parseValue();
    }
  }

  void _parseValue() {
    final val = widget.value;
    BmnCountryDialCode? matched;

    // Find longest matching available dial code
    for (final c in _countries) {
      if (c.isAvailable && val.startsWith(c.dialCode)) {
        if (matched == null || c.dialCode.length > matched.dialCode.length) {
          matched = c;
        }
      }
    }

    if (matched != null) {
      _selectedCountry = matched;
      final localNumber = val.substring(matched.dialCode.length);
      _controller = TextEditingController(text: localNumber);
    } else {
      _controller = TextEditingController(text: val);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateFullNumber(String localNumber) {
    // Remove non-digits
    final cleaned = localNumber.replaceAll(RegExp(r'\D'), '');
    if (widget.onChange != null) {
      widget.onChange!('${_selectedCountry.dialCode}$cleaned');
    }
  }

  void _showCountryPicker() {
    if (widget.disabled) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: BmnColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Select Country Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BmnColors.gray800,
                  ),
                ),
              ),
              const Divider(height: 1, color: BmnColors.gray100),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _countries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: BmnColors.gray100),
                  itemBuilder: (context, index) {
                    final c = _countries[index];
                    final isSelected = c.code == _selectedCountry.code;
                    final isAvailable = c.isAvailable;

                    return InkWell(
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                _selectedCountry = c;
                              });
                              _updateFullNumber(_controller.text);
                              Navigator.of(context).pop();
                            }
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('StepStake is coming soon to ${c.name}! 🚀'),
                                  backgroundColor: BmnColors.gray900,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            Text(
                              c.flag,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.name,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: isAvailable ? FontWeight.w600 : FontWeight.w500,
                                      color: isAvailable ? BmnColors.gray900 : BmnColors.gray400,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    c.dialCode,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isAvailable ? BmnColors.gray500 : BmnColors.gray400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isAvailable && isSelected)
                              Icon(Icons.check_circle_rounded, color: BmnColors.brandGreen600, size: 20)
                            else if (!isAvailable)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: const Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefixWidget = GestureDetector(
      onTap: widget.disabled ? null : _showCountryPicker,
      child: MouseRegion(
        cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 4),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: BmnColors.gray300, width: 1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _selectedCountry.flag,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              Text(
                _selectedCountry.dialCode,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: BmnColors.gray700,
                  height: 1.2,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                IconsaxPlusLinear.arrow_down_2,
                size: 14,
                color: BmnColors.gray500,
              ),
            ],
          ),
        ),
      ),
    );

    return BmnTextInput(
      label: widget.label,
      controller: _controller,
      placeholder: widget.placeholder,
      error: widget.error,
      disabled: widget.disabled,
      keyboardType: TextInputType.phone,
      startContent: prefixWidget,
      onChanged: _updateFullNumber,
    );
  }
}
