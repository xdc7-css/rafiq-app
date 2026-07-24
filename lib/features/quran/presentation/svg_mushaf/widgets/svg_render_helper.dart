export 'svg_render_stub.dart'
    if (dart.library.io) 'svg_render_native.dart'
    if (dart.library.js_interop) 'svg_render_web.dart';
