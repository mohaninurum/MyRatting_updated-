/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/account.png
  AssetGenImage get account => const AssetGenImage('assets/images/account.png');

  /// File path: assets/images/add.png
  AssetGenImage get add => const AssetGenImage('assets/images/add.png');

  /// File path: assets/images/apps.png
  AssetGenImage get apps => const AssetGenImage('assets/images/apps.png');

  /// File path: assets/images/call.png
  AssetGenImage get call => const AssetGenImage('assets/images/call.png');

  /// File path: assets/images/cancel.svg
  String get cancel => 'assets/images/cancel.svg';

  /// File path: assets/images/canceled.svg
  String get canceled => 'assets/images/canceled.svg';

  /// File path: assets/images/card.png
  AssetGenImage get card => const AssetGenImage('assets/images/card.png');

  /// File path: assets/images/explore.png
  AssetGenImage get explore => const AssetGenImage('assets/images/explore.png');

  /// File path: assets/images/heart.png
  AssetGenImage get heart => const AssetGenImage('assets/images/heart.png');

  /// File path: assets/images/like.svg
  String get like => 'assets/images/like.svg';

  /// File path: assets/images/liked.svg
  String get liked => 'assets/images/liked.svg';

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/monstera-8477880_640.jpg
  AssetGenImage get monstera8477880640 =>
      const AssetGenImage('assets/images/monstera-8477880_640.jpg');

  /// File path: assets/images/music.png
  AssetGenImage get music => const AssetGenImage('assets/images/music.png');

  /// File path: assets/images/nope.png
  AssetGenImage get nope => const AssetGenImage('assets/images/nope.png');

  /// File path: assets/images/rank1.png
  AssetGenImage get rank1 => const AssetGenImage('assets/images/rank1.png');

  /// File path: assets/images/rank2.png
  AssetGenImage get rank2 => const AssetGenImage('assets/images/rank2.png');

  /// File path: assets/images/rank3.png
  AssetGenImage get rank3 => const AssetGenImage('assets/images/rank3.png');

  /// File path: assets/images/rapeseed-7102819_640.jpg
  AssetGenImage get rapeseed7102819640 =>
      const AssetGenImage('assets/images/rapeseed-7102819_640.jpg');

  /// File path: assets/images/refresh.png
  AssetGenImage get refresh => const AssetGenImage('assets/images/refresh.png');

  /// File path: assets/images/refreshment-9368874_640.jpg
  AssetGenImage get refreshment9368874640 =>
      const AssetGenImage('assets/images/refreshment-9368874_640.jpg');

  /// File path: assets/images/report.svg
  String get report => 'assets/images/report.svg';

  /// File path: assets/images/rewind.svg
  String get rewind => 'assets/images/rewind.svg';

  /// File path: assets/images/search.png
  AssetGenImage get search => const AssetGenImage('assets/images/search.png');

  /// File path: assets/images/send.png
  AssetGenImage get send => const AssetGenImage('assets/images/send.png');

  /// File path: assets/images/share.svg
  String get share => 'assets/images/share.svg';

  /// File path: assets/images/slice.png
  AssetGenImage get slice => const AssetGenImage('assets/images/slice.png');

  /// File path: assets/images/soda.png
  AssetGenImage get soda => const AssetGenImage('assets/images/soda.png');

  /// File path: assets/images/superLiked.svg
  String get superLiked => 'assets/images/superLiked.svg';

  /// File path: assets/images/superlike.svg
  String get superlike => 'assets/images/superlike.svg';

  /// File path: assets/images/x-cross.svg
  String get xCross => 'assets/images/x-cross.svg';

  /// List of all assets
  List<dynamic> get values => [
    account,
    add,
    apps,
    call,
    cancel,
    canceled,
    card,
    explore,
    heart,
    like,
    liked,
    logo,
    monstera8477880640,
    music,
    nope,
    rank1,
    rank2,
    rank3,
    rapeseed7102819640,
    refresh,
    refreshment9368874640,
    report,
    rewind,
    search,
    send,
    share,
    slice,
    soda,
    superLiked,
    superlike,
    xCross,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
