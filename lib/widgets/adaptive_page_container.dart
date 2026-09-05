import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Responsive page wrapper that constrains maximum content width on tablets
/// and foldables while preserving fluid full-width layout on standard phones.
class AdaptivePageContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool fillRemaining;

  const AdaptivePageContainer({
    super.key,
    required this.child,
    this.maxWidth = AppTheme.maxContentWidthTablet,
    this.padding,
    this.fillRemaining = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(
                padding: padding!,
                child: child,
              )
            : child,
      ),
    );
  }
}
