import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:socialbuddybot/app/assets.dart';

class AppAssetImage extends StatelessWidget {
  const AppAssetImage(
    this.asset, {
    Key key,
    this.matchTextDirection = false,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.allowDrawingOutsideViewBox = false,
  }) : super(key: key);

  final AppAsset asset;
  final bool matchTextDirection;
  final double width;
  final double height;
  final BoxFit fit;
  final Alignment alignment;
  final Color color;
  final BlendMode colorBlendMode;
  final bool allowDrawingOutsideViewBox;

  @override
  Widget build(BuildContext context) {
    switch (asset.type) {
      case AppAssetType.vector:
        return SvgPicture.asset(
          asset.path,
          matchTextDirection: matchTextDirection,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color,
          colorBlendMode: colorBlendMode,
          allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        );
      case AppAssetType.bitmap:
        return Image.asset(
          asset.path,
          matchTextDirection: matchTextDirection,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color,
          colorBlendMode: colorBlendMode,
        );
    }
    throw StateError('Invalid AppAssetType ${asset.type}');
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AppAsset>('asset', asset))
      ..add(DiagnosticsProperty<bool>('matchTextDirection', matchTextDirection))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height))
      ..add(EnumProperty<BoxFit>('fit', fit))
      ..add(DiagnosticsProperty<Alignment>('alignment', alignment))
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<BlendMode>('colorBlendMode', colorBlendMode))
      ..add(DiagnosticsProperty<bool>(
          'allowDrawingOutsideViewBox', allowDrawingOutsideViewBox));
  }
}
