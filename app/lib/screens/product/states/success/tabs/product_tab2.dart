import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:provider/provider.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  static const double _kHorizontalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    final nutrientLevels = product.nutrientLevels;

    if (nutrientLevels == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Aucune donn\u00e9e nutritionnelle disponible',
            style: TextStyle(fontSize: 14.0, color: AppColors.grey2),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kHorizontalPadding,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Rep\u00e8res nutritionnels', style: context.theme.title3),
          const SizedBox(height: 16.0),
          if (nutrientLevels.fat != null)
            _NutrientLevelCard(
              label: 'Mati\u00e8res grasses',
              level: nutrientLevels.fat!,
              value: product.nutritionFacts?.fat,
            ),
          if (nutrientLevels.saturatedFat != null)
            _NutrientLevelCard(
              label: 'Acides gras satur\u00e9s',
              level: nutrientLevels.saturatedFat!,
              value: product.nutritionFacts?.saturatedFat,
            ),
          if (nutrientLevels.sugars != null)
            _NutrientLevelCard(
              label: 'Sucres',
              level: nutrientLevels.sugars!,
              value: product.nutritionFacts?.sugar,
            ),
          if (nutrientLevels.salt != null)
            _NutrientLevelCard(
              label: 'Sel',
              level: nutrientLevels.salt!,
              value: product.nutritionFacts?.salt,
            ),
        ],
      ),
    );
  }
}

class _NutrientLevelCard extends StatelessWidget {
  const _NutrientLevelCard({
    required this.label,
    required this.level,
    this.value,
  });

  final String label;
  final String level;
  final Nutriment? value;

  Color get _color {
    return switch (level.toLowerCase()) {
      'low' => AppColors.nutrientLevelLow,
      'moderate' => AppColors.nutrientLevelModerate,
      'high' => AppColors.nutrientLevelHigh,
      _ => AppColors.grey2,
    };
  }

  String get _levelLabel {
    return switch (level.toLowerCase()) {
      'low' => 'Faible quantit\u00e9',
      'moderate' => 'Quantit\u00e9 mod\u00e9r\u00e9e',
      'high' => 'Quantit\u00e9 \u00e9lev\u00e9e',
      _ => 'Non d\u00e9fini',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 14.0,
            height: 14.0,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  _buildValueText(),
                  style: TextStyle(
                    color: _color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildValueText() {
    final buffer = StringBuffer(_levelLabel);
    if (value?.per100g != null) {
      buffer.write(' (${value!.per100g} ${value!.unit} pour 100g)');
    }
    return buffer.toString();
  }
}
