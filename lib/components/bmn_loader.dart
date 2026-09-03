import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const BmnLoader({
    super.key,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? BmnColors.brandGreen600),
          backgroundColor: BmnColors.brandGreen50,
        ),
      ),
    );
  }
}
