import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
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

    final items = <_NutrientData>[];

    if (nutrientLevels.fat != null) {
      items.add(_NutrientData(
        label: 'Mati\u00e8res grasses / lipides',
        level: nutrientLevels.fat!,
        value: product.nutritionFacts?.fat,
      ));
    }
    if (nutrientLevels.saturatedFat != null) {
      items.add(_NutrientData(
        label: 'Acides gras satur\u00e9s',
        level: nutrientLevels.saturatedFat!,
        value: product.nutritionFacts?.saturatedFat,
      ));
    }
    if (nutrientLevels.sugars != null) {
      items.add(_NutrientData(
        label: 'Sucres',
        level: nutrientLevels.sugars!,
        value: product.nutritionFacts?.sugar,
      ));
    }
    if (nutrientLevels.salt != null) {
      items.add(_NutrientData(
        label: 'Sel',
        level: nutrientLevels.salt!,
        value: product.nutritionFacts?.salt,
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10.0),
          Text(
            'Rep\u00e8res nutritionnels pour 100g',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: AppColors.blueDark,
            ),
          ),
          const SizedBox(height: 20.0),
          for (int i = 0; i < items.length; i++) ...[
            _NutrientRow(data: items[i]),
            if (i < items.length - 1) const Divider(height: 1.0),
          ],
        ],
      ),
    );
  }
}

class _NutrientData {
  final String label;
  final String level;
  final Nutriment? value;

  _NutrientData({
    required this.label,
    required this.level,
    this.value,
  });
}

class _NutrientRow extends StatelessWidget {
  const _NutrientRow({required this.data});

  final _NutrientData data;

  Color get _levelColor {
    return switch (data.level.toLowerCase()) {
      'low' => AppColors.nutrientLevelLow,
      'moderate' => AppColors.nutrientLevelModerate,
      'high' => AppColors.nutrientLevelHigh,
      _ => AppColors.grey2,
    };
  }

  String get _levelLabel {
    return switch (data.level.toLowerCase()) {
      'low' => 'Faible quantit\u00e9',
      'moderate' => 'Quantit\u00e9 mod\u00e9r\u00e9e',
      'high' => 'Quantit\u00e9 \u00e9lev\u00e9e',
      _ => '',
    };
  }

  String get _valueText {
    if (data.value?.per100g == null) return '';
    final v = data.value!.per100g;
    final unit = data.value!.unit;
    if (v is num) {
      return '${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1)}$unit';
    }
    return '$v$unit';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              data.label,
              style: const TextStyle(
                fontSize: 15.0,
                color: AppColors.blueDark,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _valueText,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: _levelColor,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                _levelLabel,
                style: TextStyle(
                  fontSize: 13.0,
                  color: _levelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
