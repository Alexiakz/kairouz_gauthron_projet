import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:provider/provider.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  static const double _kHorizontalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ── Ingrédients ──
          const SizedBox(height: 10.0),
          _SectionHeader(title: 'Ingr\u00e9dients'),
          const SizedBox(height: 8.0),
          if (product.ingredients != null &&
              product.ingredients!.isNotEmpty)
            ...product.ingredients!.map(
              (ingredient) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  ingredient,
                  style:
                      const TextStyle(fontSize: 14.0, color: AppColors.grey3),
                ),
              ),
            )
          else
            const Text('Aucun',
                style: TextStyle(fontSize: 14.0, color: AppColors.grey2)),

          // ── Substances allergènes ──
          const SizedBox(height: 20.0),
          _SectionHeader(title: 'Substances allerg\u00e8nes'),
          const SizedBox(height: 8.0),
          if (product.allergens != null && product.allergens!.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: product.allergens!
                  .map((a) => _AllergenChip(label: a))
                  .toList(),
            )
          else
            const Text('Aucune',
                style: TextStyle(fontSize: 14.0, color: AppColors.grey2)),

          // ── Additifs ──
          const SizedBox(height: 20.0),
          _SectionHeader(title: 'Additifs'),
          const SizedBox(height: 8.0),
          if (product.additives != null && product.additives!.isNotEmpty)
            ...product.additives!.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: AppColors.grey3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const Text('Aucun',
                style: TextStyle(fontSize: 14.0, color: AppColors.grey2)),

          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.theme.title3);
  }
}

class _AllergenChip extends StatelessWidget {
  const _AllergenChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.nutrientLevelHigh.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
            color: AppColors.nutrientLevelHigh.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.0,
          color: AppColors.nutrientLevelHigh,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
