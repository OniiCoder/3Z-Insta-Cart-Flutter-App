import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnSelectOption {
  final String label;
  final String value;
  final String? description;

  const BmnSelectOption({
    required this.label,
    required this.value,
    this.description,
  });
}

class BmnSelect extends StatelessWidget {
  final String? label;
  final String? value;
  final ValueChanged<String>? onValueChange;
  final String? placeholder;
  final String? error;
  final String? hintText;
  final List<BmnSelectOption> options;
  final bool required;
  final bool disabled;

  const BmnSelect({
    super.key,
    this.label,
    this.value,
    this.onValueChange,
    this.placeholder = 'Select option',
    this.error,
    this.hintText,
    required this.options,
    this.required = false,
    this.disabled = false,
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
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
              if (label != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: BmnColors.gray800,
                    ),
                  ),
                ),
                const Divider(height: 1, color: BmnColors.gray100),
              ],
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final opt = options[index];
                    final isSelected = opt.value == value;

                    return ListTile(
                      onTap: () {
                        if (onValueChange != null) {
                          onValueChange!(opt.value);
                        }
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        opt.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? BmnColors.brandGreen700 : BmnColors.gray800,
                        ),
                      ),
                      subtitle: opt.description != null
                          ? Text(
                              opt.description!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: BmnColors.gray500,
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? Icon(Icons.check, color: BmnColors.brandGreen600)
                          : null,
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
    final bool hasError = error != null;
    final selectedOption = options.cast<BmnSelectOption?>().firstWhere(
          (opt) => opt?.value == value,
          orElse: () => null,
        );

    Color borderColor = BmnColors.gray400;
    if (hasError) {
      borderColor = BmnColors.red500;
    }

    return Opacity(
      opacity: disabled ? 0.6 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BmnColors.gray800,
                  ),
                ),
                if (required) ...[
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: BmnColors.red500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
          GestureDetector(
            onTap: disabled ? null : () => _showOptions(context),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
                color: disabled ? BmnColors.gray50 : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedOption?.label ?? placeholder ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedOption != null
                            ? BmnColors.gray800
                            : BmnColors.gray500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    IconsaxPlusLinear.arrow_down_2,
                    size: 16,
                    color: BmnColors.gray500,
                  ),
                ],
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                error!,
                style: const TextStyle(
                  color: BmnColors.red600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else if (hintText != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                hintText!,
                style: const TextStyle(
                  color: BmnColors.gray600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class BmnSearchableSelect extends StatefulWidget {
  final String? label;
  final String? value;
  final ValueChanged<String>? onValueChange;
  final String? placeholder;
  final String? error;
  final String? hintText;
  final List<BmnSelectOption> options;
  final bool required;
  final bool disabled;

  const BmnSearchableSelect({
    super.key,
    this.label,
    this.value,
    this.onValueChange,
    this.placeholder = 'Search & select option',
    this.error,
    this.hintText,
    required this.options,
    this.required = false,
    this.disabled = false,
  });

  @override
  State<BmnSearchableSelect> createState() => _BmnSearchableSelectState();
}

class _BmnSearchableSelectState extends State<BmnSearchableSelect> {
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return _BmnSearchableSelectSheet(
          label: widget.label,
          value: widget.value,
          options: widget.options,
          onSelect: (val) {
            if (widget.onValueChange != null) {
              widget.onValueChange!(val);
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.error != null;
    final selectedOption = widget.options.cast<BmnSelectOption?>().firstWhere(
          (opt) => opt?.value == widget.value,
          orElse: () => null,
        );

    Color borderColor = BmnColors.gray400;
    if (hasError) {
      borderColor = BmnColors.red500;
    }

    return Opacity(
      opacity: widget.disabled ? 0.6 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BmnColors.gray800,
                  ),
                ),
                if (widget.required) ...[
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: BmnColors.red500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
          GestureDetector(
            onTap: widget.disabled ? null : () => _showOptions(context),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
                color: widget.disabled ? BmnColors.gray50 : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedOption?.label ?? widget.placeholder ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedOption != null
                            ? BmnColors.gray800
                            : BmnColors.gray500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    IconsaxPlusLinear.arrow_down_2,
                    size: 16,
                    color: BmnColors.gray500,
                  ),
                ],
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                widget.error!,
                style: const TextStyle(
                  color: BmnColors.red600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else if (widget.hintText != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                widget.hintText!,
                style: const TextStyle(
                  color: BmnColors.gray600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BmnSearchableSelectSheet extends StatefulWidget {
  final String? label;
  final String? value;
  final List<BmnSelectOption> options;
  final ValueChanged<String> onSelect;

  const _BmnSearchableSelectSheet({
    required this.label,
    required this.value,
    required this.options,
    required this.onSelect,
  });

  @override
  State<_BmnSearchableSelectSheet> createState() => _BmnSearchableSelectSheetState();
}

class _BmnSearchableSelectSheetState extends State<_BmnSearchableSelectSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredOptions = widget.options.where((opt) {
      final labelMatch = opt.label.toLowerCase().contains(_searchQuery.toLowerCase());
      final descMatch = opt.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      return labelMatch || descMatch;
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: SafeArea(
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
              if (widget.label != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    widget.label!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: BmnColors.gray800,
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1, size: 18),
                    hintStyle: const TextStyle(color: BmnColors.gray500, fontSize: 14),
                    filled: true,
                    fillColor: BmnColors.gray50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const Divider(height: 1, color: BmnColors.gray100),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final opt = filteredOptions[index];
                    final isSelected = opt.value == widget.value;

                    return ListTile(
                      onTap: () => widget.onSelect(opt.value),
                      title: Text(
                        opt.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? BmnColors.brandGreen700 : BmnColors.gray800,
                        ),
                      ),
                      subtitle: opt.description != null
                          ? Text(
                              opt.description!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: BmnColors.gray500,
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? Icon(Icons.check, color: BmnColors.brandGreen600)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
