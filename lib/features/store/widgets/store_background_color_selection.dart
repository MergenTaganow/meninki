import 'package:flutter/material.dart';

// Color scheme model
class MarketColorScheme {
  final Color bgMain;
  final Color bgSecondary;
  final Color button;
  final Color buttonText;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardBackground;

  const MarketColorScheme({
    required this.bgMain,
    required this.bgSecondary,
    required this.button,
    required this.buttonText,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardBackground,
  });

  // Factory method to generate scheme from a single background color
  factory MarketColorScheme.fromBackground(Color bgColor) {
    // Calculate brightness
    double brightness = (bgColor.red * 299 + bgColor.green * 587 + bgColor.blue * 114) / 1000;
    bool isLight = brightness > 128;

    if (isLight) {
      // Light theme
      return MarketColorScheme(
        bgMain: bgColor,
        bgSecondary: _darken(bgColor, 0.03),
        button: Color(0xFF7A4267),
        buttonText: Colors.white,
        textPrimary: Colors.black,
        textSecondary: Color(0xFF5C5C5C),
        cardBackground: _darken(bgColor, 0.02),
      );
    } else {
      // Dark theme
      return MarketColorScheme(
        bgMain: bgColor,
        bgSecondary: _lighten(bgColor, 0.05),
        button: Color(0xFFB71764),
        buttonText: Colors.white,
        textPrimary: Colors.white,
        textSecondary: Color(0xFFAFA8B4),
        cardBackground: _lighten(bgColor, 0.03),
      );
    }
  }

  static Color _darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  static Color _lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  // ========== PREDEFINED COLOR SCHEMES ==========

  // Default White - Clean and classic
  static const defaultWhite = MarketColorScheme(
    bgMain: Color(0xFFFFFFFF),
    bgSecondary: Color(0xFFF5F5F5),
    button: Color(0xFF7A4267),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF5C5C5C),
    cardBackground: Color(0xFFFAFAFA),
  );

  // Sunset Beach - Warm and inviting
  static const sunsetBeach = MarketColorScheme(
    bgMain: Color(0xFFACB3CF),
    bgSecondary: Color(0xFF717EA0),
    button: Color(0xFFC07097),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF253141),
    textSecondary: Color(0xFF92628A),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Blush Pink - Soft and elegant
  static const blushPink = MarketColorScheme(
    bgMain: Color(0xFFF5DCDC),
    bgSecondary: Color(0xFFD196A3),
    button: Color(0xFFA13C64),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF500F15),
    textSecondary: Color(0xFF7D4C61),
    cardBackground: Color(0xFFFCD7DD),
  );

  // Rose Garden - Fresh and feminine
  static const roseGarden = MarketColorScheme(
    bgMain: Color(0xFFE2A9C0),
    bgSecondary: Color(0xFFE1C9D5),
    button: Color(0xFFA24C61),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF411528),
    textSecondary: Color(0xFF710C21),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Autumn Warmth - Earthy and cozy
  static const autumnWarmth = MarketColorScheme(
    bgMain: Color(0xFFEDC7AA),
    bgSecondary: Color(0xFFEA8773),
    button: Color(0xFF9F4E41),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF302825),
    textSecondary: Color(0xFF69483D),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Natural Earth - Grounded and professional
  static const naturalEarth = MarketColorScheme(
    bgMain: Color(0xFFD7B395),
    bgSecondary: Color(0xFF725A45),
    button: Color(0xFFA06734),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF423324),
    textSecondary: Color(0xFFA37E62),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Modern Dark - Sophisticated and sleek
  static const modernDark = MarketColorScheme(
    bgMain: Color(0xFF323030),
    bgSecondary: Color(0xFF6A584E),
    button: Color(0xFFD78F59),
    buttonText: Color(0xFF1C1C1C),
    textPrimary: Color(0xFFC4AA97),
    textSecondary: Color(0xFF070605),
    cardBackground: Color(0xFF1C1C1C),
  );

  // Vintage Floral - Classic and refined
  static const vintageFloral = MarketColorScheme(
    bgMain: Color(0xFFEFE8CE),
    bgSecondary: Color(0xFFD7CE93),
    button: Color(0xFFB8B588),
    buttonText: Color(0xFF163832),
    textPrimary: Color(0xFFA3A380),
    textSecondary: Color(0xFFD8A48F),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Pastel Dream - Light and airy
  static const pastelDream = MarketColorScheme(
    bgMain: Color(0xFFDAEBE3),
    bgSecondary: Color(0xFF99CDD8),
    button: Color(0xFF657166),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFFDE8D3),
    textSecondary: Color(0xFFF3C3B2),
    cardBackground: Color(0xFFCFD8C4),
  );

  // Coffee & Cream - Warm neutrals
  static const coffeeCream = MarketColorScheme(
    bgMain: Color(0xFFFFE0B2),
    bgSecondary: Color(0xFFD3A376),
    button: Color(0xFF8C6E63),
    buttonText: Color(0xFFFFF2DF),
    textPrimary: Color(0xFF3E2522),
    textSecondary: Color(0xFFFFF2DF),
    cardBackground: Color(0xFFFFE0B2),
  );

  // Ocean Depths - Cool and calming
  static const oceanDepths = MarketColorScheme(
    bgMain: Color(0xFFB7E6E5),
    bgSecondary: Color(0xFF599D9C),
    button: Color(0xFF317978),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF113B3A),
    textSecondary: Color(0xFF184948),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Misty Mountain - Serene and mysterious
  static const mistyMountain = MarketColorScheme(
    bgMain: Color(0xFF7DA0CA),
    bgSecondary: Color(0xFF5483B3),
    button: Color(0xFF29343E),
    buttonText: Color(0xFFC1E8FF),
    textPrimary: Color(0xFF021024),
    textSecondary: Color(0xFF052659),
    cardBackground: Color(0xFF809095),
  );

  // Turquoise & Amber - Bold and vibrant
  static const turquoiseAmber = MarketColorScheme(
    bgMain: Color(0xFF00CED1),
    bgSecondary: Color(0xFF20B2AA),
    button: Color(0xFFFF8C00),
    buttonText: Color(0xFF000000),
    textPrimary: Color(0xFF2F4F4F),
    textSecondary: Color(0xFF008B8B),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Autumn Leaves - Rich and seasonal
  static const autumnLeaves = MarketColorScheme(
    bgMain: Color(0xFFD1974E),
    bgSecondary: Color(0xFFB05833),
    button: Color(0xFF713830),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF201724),
    textSecondary: Color(0xFF3F4C67),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Coral Teal - Fresh and modern
  static const coralTeal = MarketColorScheme(
    bgMain: Color(0xFFFFE4CE),
    bgSecondary: Color(0xFFFFB69E),
    button: Color(0xFF00796B),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF23314A),
    textSecondary: Color(0xFF8FA1B1),
    cardBackground: Color(0xFFDB8084),
  );

  // Berry Blush - Sweet and inviting
  static const berryBlush = MarketColorScheme(
    bgMain: Color(0xFFFBC8CC),
    bgSecondary: Color(0xFFE092A7),
    button: Color(0xFF8C3352),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF6C3134),
    textSecondary: Color(0xFFA24C61),
    cardBackground: Color(0xFFF3ACB5),
  );

  // Dusty Rose - Romantic and sophisticated
  static const dustyRose = MarketColorScheme(
    bgMain: Color(0xFFED9A9C),
    bgSecondary: Color(0xFFB14060),
    button: Color(0xFF500F15),
    buttonText: Color(0xFFFCD7DD),
    textPrimary: Color(0xFF7A4A4C),
    textSecondary: Color(0xFFB8B588),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Peachy Keen - Warm and friendly
  static const peachyKeen = MarketColorScheme(
    bgMain: Color(0xFFF3ACB5),
    bgSecondary: Color(0xFFED9A9C),
    button: Color(0xFFA24C61),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF411528),
    textSecondary: Color(0xFF710C21),
    cardBackground: Color(0xFFE2A9C0),
  );

  // Orchid Garden - Delicate and luxurious
  static const orchidGarden = MarketColorScheme(
    bgMain: Color(0xFFE3AAC0),
    bgSecondary: Color(0xFFE1C9D5),
    button: Color(0xFF710C21),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF411528),
    textSecondary: Color(0xFFB8B588),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Pink Lemonade - Playful and vibrant
  static const pinkLemonade = MarketColorScheme(
    bgMain: Color(0xFFD196A3),
    bgSecondary: Color(0xFFD7CE93),
    button: Color(0xFFA13C64),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF7D4C61),
    textSecondary: Color(0xFF500F15),
    cardBackground: Color(0xFFF5DCDC),
  );

  // Terracotta Sunset - Earthy and warm
  static const terracottaSunset = MarketColorScheme(
    bgMain: Color(0xFFEA8773),
    bgSecondary: Color(0xFF9F4E41),
    button: Color(0xFF69483D),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF302825),
    textSecondary: Color(0xFFEDC7AA),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Copper Glow - Rich and elegant
  static const copperGlow = MarketColorScheme(
    bgMain: Color(0xFFD8B495),
    bgSecondary: Color(0xFFA37E62),
    button: Color(0xFFA06734),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF423324),
    textSecondary: Color(0xFF725A45),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Mocha Chic - Sophisticated neutrals
  static const mochaChic = MarketColorScheme(
    bgMain: Color(0xFF725A45),
    bgSecondary: Color(0xFFA37E62),
    button: Color(0xFF484D39),
    buttonText: Color(0xFFD7B395),
    textPrimary: Color(0xFFD7B395),
    textSecondary: Color(0xFFA06734),
    cardBackground: Color(0xFF423324),
  );

  // Urban Slate - Modern and minimalist
  static const urbanSlate = MarketColorScheme(
    bgMain: Color(0xFF6A584E),
    bgSecondary: Color(0xFF323030),
    button: Color(0xFFD78F59),
    buttonText: Color(0xFF070605),
    textPrimary: Color(0xFFC4AA97),
    textSecondary: Color(0xFF1C1C1C),
    cardBackground: Color(0xFF1C1C1C),
  );

  // Midnight Luxury - Premium dark theme
  static const midnightLuxury = MarketColorScheme(
    bgMain: Color(0xFF1C1C1C),
    bgSecondary: Color(0xFF070605),
    button: Color(0xFFD78F59),
    buttonText: Color(0xFF323030),
    textPrimary: Color(0xFFC4AA97),
    textSecondary: Color(0xFF6A584E),
    cardBackground: Color(0xFF323030),
  );

  // Sage & Sand - Natural and calming
  static const sageSand = MarketColorScheme(
    bgMain: Color(0xFFF0E9CE),
    bgSecondary: Color(0xFFD7CE93),
    button: Color(0xFFA3A380),
    buttonText: Color(0xFF163832),
    textPrimary: Color(0xFF163832),
    textSecondary: Color(0xFFB8B588),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Garden Mint - Fresh and organic
  static const gardenMint = MarketColorScheme(
    bgMain: Color(0xFFCFD8C4),
    bgSecondary: Color(0xFF99CDD8),
    button: Color(0xFF657166),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFFDE8D3),
    textSecondary: Color(0xFFDAEBE3),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Soft Cloud - Airy and light
  static const softCloud = MarketColorScheme(
    bgMain: Color(0xFFDBECE3),
    bgSecondary: Color(0xFFFDE8D3),
    button: Color(0xFFF3C3B2),
    buttonText: Color(0xFF657166),
    textPrimary: Color(0xFF657166),
    textSecondary: Color(0xFF99CDD8),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Vanilla Sky - Soft and dreamy
  static const vanillaSky = MarketColorScheme(
    bgMain: Color(0xFFFFF2DF),
    bgSecondary: Color(0xFFFFE0B2),
    button: Color(0xFF8C6E63),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF3E2522),
    textSecondary: Color(0xFFD3A376),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Caramel Dream - Sweet and cozy
  static const caramelDream = MarketColorScheme(
    bgMain: Color(0xFFD3A376),
    bgSecondary: Color(0xFF8C6E63),
    button: Color(0xFF3E2522),
    buttonText: Color(0xFFFFF2DF),
    textPrimary: Color(0xFF3E2522),
    textSecondary: Color(0xFFFFE0B2),
    cardBackground: Color(0xFFFFE0B2),
  );

  // Aqua Marine - Cool and refreshing
  static const aquaMarine = MarketColorScheme(
    bgMain: Color(0xFFB8E7E5),
    bgSecondary: Color(0xFF599D9C),
    button: Color(0xFF113B3A),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF113B3A),
    textSecondary: Color(0xFF317978),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Teal Deep - Professional and trustworthy
  static const tealDeep = MarketColorScheme(
    bgMain: Color(0xFF317978),
    bgSecondary: Color(0xFF599D9C),
    button: Color(0xFFB7E6E5),
    buttonText: Color(0xFF113B3A),
    textPrimary: Color(0xFFB7E6E5),
    textSecondary: Color(0xFF184948),
    cardBackground: Color(0xFF113B3A),
  );

  // Emerald Forest - Rich and natural
  static const emeraldForest = MarketColorScheme(
    bgMain: Color(0xFF8EB69B),
    bgSecondary: Color(0xFF235347),
    button: Color(0xFF0B2B26),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF051F20),
    textSecondary: Color(0xFF163832),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Ocean Breeze - Coastal and serene
  static const oceanBreeze = MarketColorScheme(
    bgMain: Color(0xFF7EA1CA),
    bgSecondary: Color(0xFF5483B3),
    button: Color(0xFF052659),
    buttonText: Color(0xFFC1E8FF),
    textPrimary: Color(0xFF021024),
    textSecondary: Color(0xFF29343E),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Steel Blue - Corporate and strong
  static const steelBlue = MarketColorScheme(
    bgMain: Color(0xFF809095),
    bgSecondary: Color(0xFF5483B3),
    button: Color(0xFF29343E),
    buttonText: Color(0xFFC1E8FF),
    textPrimary: Color(0xFF021024),
    textSecondary: Color(0xFF7DA0CA),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Navy Depths - Classic and authoritative
  static const navyDepths = MarketColorScheme(
    bgMain: Color(0xFF052659),
    bgSecondary: Color(0xFF29343E),
    button: Color(0xFF7DA0CA),
    buttonText: Color(0xFF021024),
    textPrimary: Color(0xFFC1E8FF),
    textSecondary: Color(0xFF5483B3),
    cardBackground: Color(0xFF021024),
  );

  // Tropical Vibes - Bold and energetic
  static const tropicalVibes = MarketColorScheme(
    bgMain: Color(0xFF20B2AA),
    bgSecondary: Color(0xFF00CED1),
    button: Color(0xFFFF8C00),
    buttonText: Color(0xFF000000),
    textPrimary: Color(0xFF2F4F4F),
    textSecondary: Color(0xFF008B8B),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Sunset Glow - Vibrant and warm
  static const sunsetGlow = MarketColorScheme(
    bgMain: Color(0xFFFF8C00),
    bgSecondary: Color(0xFFD1974E),
    button: Color(0xFF008B8B),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF2F4F4F),
    textSecondary: Color(0xFF00CED1),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Harvest Gold - Autumn richness
  static const harvestGold = MarketColorScheme(
    bgMain: Color(0xFFD2984E),
    bgSecondary: Color(0xFFB05833),
    button: Color(0xFF713830),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF201724),
    textSecondary: Color(0xFF3F4C67),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Rustic Charm - Earthy and grounded
  static const rusticCharm = MarketColorScheme(
    bgMain: Color(0xFFB05833),
    bgSecondary: Color(0xFF713830),
    button: Color(0xFFD1974E),
    buttonText: Color(0xFF201724),
    textPrimary: Color(0xFF201724),
    textSecondary: Color(0xFF3F4C67),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Denim & Rust - Casual and comfortable
  static const denimRust = MarketColorScheme(
    bgMain: Color(0xFF3F4C67),
    bgSecondary: Color(0xFF201724),
    button: Color(0xFFB05833),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFD1974E),
    textSecondary: Color(0xFF713830),
    cardBackground: Color(0xFF201724),
  );

  // Coral Reef - Tropical and lively
  static const coralReef = MarketColorScheme(
    bgMain: Color(0xFFFFB69E),
    bgSecondary: Color(0xFFDB8084),
    button: Color(0xFF00796B),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF23314A),
    textSecondary: Color(0xFF8FA1B1),
    cardBackground: Color(0xFFFFE4CE),
  );

  // Arctic Coral - Cool meets warm
  static const arcticCoral = MarketColorScheme(
    bgMain: Color(0xFF8FA1B1),
    bgSecondary: Color(0xFF23314A),
    button: Color(0xFFDB8084),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF23314A),
    textSecondary: Color(0xFFFFB69E),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Powder Blue & Rose - Gentle and feminine
  static const powderBlueRose = MarketColorScheme(
    bgMain: Color(0xFFDB8084),
    bgSecondary: Color(0xFF23314A),
    button: Color(0xFF8FA1B1),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF23314A),
    textSecondary: Color(0xFFFFE4CE),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Forest Mist - Mystical and calm
  static const forestMist = MarketColorScheme(
    bgMain: Color(0xFF113B3A),
    bgSecondary: Color(0xFF184948),
    button: Color(0xFFB7E6E5),
    buttonText: Color(0xFF113B3A),
    textPrimary: Color(0xFFB7E6E5),
    textSecondary: Color(0xFF599D9C),
    cardBackground: Color(0xFF184948),
  );

  // Jade Palace - Luxurious green
  static const jadePalace = MarketColorScheme(
    bgMain: Color(0xFF235E5D),
    bgSecondary: Color(0xFF317978),
    button: Color(0xFFACB3CF),
    buttonText: Color(0xFF113B3A),
    textPrimary: Color(0xFFB7E6E5),
    textSecondary: Color(0xFF599D9C),
    cardBackground: Color(0xFF113B3A),
  );

  // Lavender Fields - Soft purple tones
  static const lavenderFields = MarketColorScheme(
    bgMain: Color(0xFFADB4CF),
    bgSecondary: Color(0xFF92628A),
    button: Color(0xFFC07097),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF253141),
    textSecondary: Color(0xFF717EA0),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Plum Twilight - Deep and mysterious
  static const plumTwilight = MarketColorScheme(
    bgMain: Color(0xFF92628A),
    bgSecondary: Color(0xFF253141),
    button: Color(0xFFC07097),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFACB3CF),
    textSecondary: Color(0xFF717EA0),
    cardBackground: Color(0xFF253141),
  );

  // Cherry Blossom - Delicate pink
  static const cherryBlossom = MarketColorScheme(
    bgMain: Color(0xFFEEE8CF),
    bgSecondary: Color(0xFFD8A48F),
    button: Color(0xFFB8B588),
    buttonText: Color(0xFF163832),
    textPrimary: Color(0xFFA3A380),
    textSecondary: Color(0xFFD7CE93),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Desert Sand - Warm neutrals
  static const desertSand = MarketColorScheme(
    bgMain: Color(0xFFD8A48F),
    bgSecondary: Color(0xFFB8B588),
    button: Color(0xFF163832),
    buttonText: Color(0xFFEFE8CE),
    textPrimary: Color(0xFF163832),
    textSecondary: Color(0xFFA3A380),
    cardBackground: Color(0xFFEFE8CE),
  );

  // Mint Chocolate - Fresh with depth
  static const mintChocolate = MarketColorScheme(
    bgMain: Color(0xFFB6E6E6),
    bgSecondary: Color(0xFF3E2522),
    button: Color(0xFF8C6E63),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF3E2522),
    textSecondary: Color(0xFF599D9C),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Peachy Teal - Complementary contrast
  static const peachyTeal = MarketColorScheme(
    bgMain: Color(0xFFFFE5CE),
    bgSecondary: Color(0xFF317978),
    button: Color(0xFFDB8084),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF113B3A),
    textSecondary: Color(0xFFFFB69E),
    cardBackground: Color(0xFFFFFFFF),
  );

  // Royal Plum - Regal and refined
  static const royalPlum = MarketColorScheme(
    bgMain: Color(0xFF623A4B),
    bgSecondary: Color(0xFF8C3352),
    button: Color(0xFFE092A7),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFFBC8CC),
    textSecondary: Color(0xFFA24C61),
    cardBackground: Color(0xFF6C3134),
  );

  // Cinnamon Spice - Warm and inviting
  static const cinnamonSpice = MarketColorScheme(
    bgMain: Color(0xFFAF5933),
    bgSecondary: Color(0xFFD1974E),
    button: Color(0xFF201724),
    buttonText: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF201724),
    textSecondary: Color(0xFF713830),
    cardBackground: Color(0xFFFFFFFF),
  );

  // ========== ALL SCHEMES LIST ==========

  static const List<MarketColorScheme> allSchemes = [
    defaultWhite,
    sunsetBeach,
    blushPink,
    roseGarden,
    autumnWarmth,
    naturalEarth,
    modernDark,
    vintageFloral,
    pastelDream,
    coffeeCream,
    oceanDepths,
    mistyMountain,
    turquoiseAmber,
    autumnLeaves,
    coralTeal,
    berryBlush,
    dustyRose,
    peachyKeen,
    orchidGarden,
    pinkLemonade,
    terracottaSunset,
    copperGlow,
    mochaChic,
    urbanSlate,
    midnightLuxury,
    sageSand,
    gardenMint,
    softCloud,
    vanillaSky,
    caramelDream,
    aquaMarine,
    tealDeep,
    emeraldForest,
    oceanBreeze,
    steelBlue,
    navyDepths,
    tropicalVibes,
    sunsetGlow,
    harvestGold,
    rusticCharm,
    denimRust,
    coralReef,
    arcticCoral,
    powderBlueRose,
    forestMist,
    jadePalace,
    lavenderFields,
    plumTwilight,
    cherryBlossom,
    desertSand,
    mintChocolate,
    peachyTeal,
    royalPlum,
    cinnamonSpice,
  ];

  // ========== BACKGROUND COLORS LIST ==========

  static final List<Color> backgroundColors = allSchemes.map((scheme) => scheme.bgMain).toList();
}

// Main preview widget
class MarketThemePreview extends StatelessWidget {
  final Color backgroundColor;
  late final MarketColorScheme colorScheme;

  MarketThemePreview({Key? key, required this.backgroundColor}) : super(key: key) {
    colorScheme = MarketColorScheme.fromBackground(backgroundColor);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.bgMain,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with profile
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.bgSecondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 45,
                      width: 45,
                      color: colorScheme.button.withOpacity(0.3),
                      child: Icon(Icons.store, color: colorScheme.button, size: 24),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Black Star Wear",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: colorScheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Шмотки",
                          style: TextStyle(fontSize: 13, color: colorScheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: colorScheme.button,
                    ),
                    child: Icon(Icons.message, color: colorScheme.buttonText, size: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Info section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Телефон", "+993 62 71 13 10"),
                  _buildInfoRow("Описание", "🥰😊 In amatly öý harytlary bizde! 😁🥰🥰😊"),
                  _buildInfoRow("Юзернейм", "@mosshy_home_tm"),
                  SizedBox(height: 10),

                  // Stats cards
                  Row(
                    children: [
                      Expanded(child: _buildStatCard("Подписчики", "1313")),
                      SizedBox(width: 10),
                      Expanded(child: _buildStatCard("Место в рейтинге", "1313")),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Category circles
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.cardBackground,
                                ),
                                child: Icon(
                                  Icons.category,
                                  color: colorScheme.textSecondary,
                                  size: 28,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Название\nкатегории",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, color: colorScheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Search bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: colorScheme.textSecondary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Поиск",
                          style: TextStyle(color: colorScheme.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: colorScheme.bgSecondary,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: colorScheme.button,
                    ),
                    child: Text(
                      "Обзоры • 1313",
                      style: TextStyle(
                        color: colorScheme.buttonText,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: colorScheme.cardBackground,
                    ),
                    child: Text(
                      "Товары • 13",
                      style: TextStyle(
                        color: colorScheme.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: colorScheme.textSecondary)),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: colorScheme.textSecondary),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: colorScheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
