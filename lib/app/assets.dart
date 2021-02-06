class AppImages {
  const AppImages._();

  static const _basePath = 'assets/images';
  // ignore: unused_field
  static const _pngPath = '$_basePath/png';
  // ignore: unused_field
  static const _svgPath = '$_basePath/svg';

  static const event = AppAsset.vector('$_svgPath/event.svg');
  static const food = AppAsset.vector('$_svgPath/food.svg');
  static const medicine = AppAsset.vector('$_svgPath/medicine.svg');
  static const music = AppAsset.vector('$_svgPath/music.svg');
  static const nurse = AppAsset.vector('$_svgPath/nurse.svg');
  static const visitors = AppAsset.vector('$_svgPath/visitors.svg');

  // static const logo = asset1;
}

class AppAsset {
  const AppAsset.bitmap(
    this.path, {
    this.matchTextDirection = false,
  }) : type = AppAssetType.bitmap;

  const AppAsset.vector(
    this.path, {
    this.matchTextDirection = false,
  }) : type = AppAssetType.vector;

  final String path;
  final AppAssetType type;
  final bool matchTextDirection;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAsset &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          type == other.type &&
          matchTextDirection == other.matchTextDirection;

  @override
  int get hashCode =>
      path.hashCode ^ type.hashCode ^ matchTextDirection.hashCode;

  @override
  String toString() => 'AppAsset{$type:$path}';
}

enum AppAssetType {
  bitmap,
  vector,
}
