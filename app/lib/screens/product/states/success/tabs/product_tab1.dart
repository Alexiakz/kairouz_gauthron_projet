import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:provider/provider.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // ── Ingrédients ──
        _SectionTitleBar(title: 'Ingr\u00e9dients'),
        _IngredientsList(ingredients: product.ingredients),

        // ── Substances allergènes ──
        _SectionTitleBar(title: 'Substances allerg\u00e8nes'),
        _SimpleContent(
          child: product.allergens != null && product.allergens!.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.allergens!
                      .map((a) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              a,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: AppColors.grey3,
                              ),
                            ),
                          ))
                      .toList(),
                )
              : const Text(
                  'Aucune',
                  style: TextStyle(fontSize: 14.0, color: AppColors.grey2),
                ),
        ),

        // ── Additifs ──
        _SectionTitleBar(title: 'Additifs'),
        _SimpleContent(
          child: product.additives != null && product.additives!.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.additives!.entries
                      .map(
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
                      .toList(),
                )
              : const Text(
                  'Aucun',
                  style: TextStyle(fontSize: 14.0, color: AppColors.grey2),
                ),
        ),

        const SizedBox(height: 20.0),
      ],
    );
  }
}

class _SectionTitleBar extends StatelessWidget {
  const _SectionTitleBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: AppColors.grey1,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: context.theme.title3,
      ),
    );
  }
}

class _IngredientsList extends StatelessWidget {
  const _IngredientsList({required this.ingredients});

  final List<String>? ingredients;

  @override
  Widget build(BuildContext context) {
    if (ingredients == null || ingredients!.isEmpty) {
      return const _SimpleContent(
        child: Text(
          'Aucun',
          style: TextStyle(fontSize: 14.0, color: AppColors.grey2),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          for (int i = 0; i < ingredients!.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      ingredients![i],
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.grey3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < ingredients!.length - 1)
              const Divider(height: 1.0),
          ],
        ],
      ),
    );
  }
}

class _SimpleContent extends StatelessWidget {
  const _SimpleContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: child,
    );
  }
}
