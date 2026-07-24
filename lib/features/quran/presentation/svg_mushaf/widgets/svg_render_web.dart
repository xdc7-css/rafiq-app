import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Web renderer — always uses [SvgPicture.string] since `dart:io` [File]
/// is not available in the browser.
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
