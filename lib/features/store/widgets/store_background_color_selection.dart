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

  MarketColorScheme({
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
