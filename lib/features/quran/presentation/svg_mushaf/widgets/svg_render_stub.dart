import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders an SVG from a [File] on native platforms.
Widget buildSvgWidget({
  required String svgContent,
  dynamic file,
  BoxFit fit = BoxFit.contain,
  Widget Function(BuildContext)? placeholderBuilder,
  Widget Function(BuildContext, Object, StackTrace)? errorBuilder,
}) {
  return SvgPicture.string(
    svgContent,
    fit: fit,
    placeholderBuilder: placeholderBuilder,
    errorBuilder: errorBuilder,
  );
}
