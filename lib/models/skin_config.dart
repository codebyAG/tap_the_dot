import 'package:tap_the_dot/constants/asset_constants.dart';

/// One purchasable dot skin. Centralized here (id/name/sprite/price)
/// rather than scattered across Shop widgets/screens, per project rule.
class SkinConfig {
  const SkinConfig({
    required this.id,
    required this.name,
    required this.asset,
    required this.price,
  });

  final String id;
  final String name;
  final String asset;
  final int price;
}

class SkinCatalog {
  SkinCatalog._();

  static const String defaultSkinId = 'classic';

  static const List<SkinConfig> all = [
    SkinConfig(
      id: 'classic',
      name: 'Classic',
      asset: AssetConstants.dotClassic,
      price: 0,
    ),
    SkinConfig(
      id: 'candy',
      name: 'Candy',
      asset: AssetConstants.dotCandy,
      price: 150,
    ),
    SkinConfig(
      id: 'fire',
      name: 'Fire',
      asset: AssetConstants.dotFire,
      price: 200,
    ),
    SkinConfig(
      id: 'ice',
      name: 'Ice',
      asset: AssetConstants.dotIce,
      price: 200,
    ),
    SkinConfig(
      id: 'neon',
      name: 'Neon',
      asset: AssetConstants.dotNeon,
      price: 250,
    ),
    SkinConfig(
      id: 'rainbow',
      name: 'Rainbow',
      asset: AssetConstants.dotRainbow,
      price: 300,
    ),
  ];

  static SkinConfig byId(String id) =>
      all.firstWhere((s) => s.id == id, orElse: () => all.first);
}
