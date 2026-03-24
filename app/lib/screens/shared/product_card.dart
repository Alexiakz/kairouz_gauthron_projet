import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.picture,
    required this.productName,
    required this.brands,
    required this.barcode,
    this.nutriScore = '',
    required this.onTap,
  });

  final String picture;
  final String productName;
  final String brands;
  final String barcode;
  final String nutriScore;
  final VoidCallback onTap;

  static const double _cardHeight = 100.0;
  static const double _imageSize = 115.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: _imageSize,
          child: Stack(
            children: [
              // Carte fond blanc
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _cardHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),

              // Contenu texte + nutri-score
              Positioned(
                left: _imageSize + 12.0,
                right: 12.0,
                bottom: 0,
                height: _cardHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            productName.isNotEmpty ? productName : barcode,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                              color: AppColors.blueDark,
                            ),
                          ),
                          if (brands.isNotEmpty) ...[
                            const SizedBox(height: 4.0),
                            Text(
                              brands,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.0,
                                color: AppColors.grey2,
                              ),
                            ),
                          ],
                          if (nutriScore.isNotEmpty) ...[
                            const SizedBox(height: 4.0),
                            _NutriScoreLabel(score: nutriScore),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Image décalée vers le haut avec ombre
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2.0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      width: _imageSize,
                      height: _imageSize,
                      child: picture.isNotEmpty
                          ? Image.network(
                              picture,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.grey2.withValues(alpha: 0.2),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 32.0,
                                  color: AppColors.grey2,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.grey2.withValues(alpha: 0.2),
                              child: const Icon(
                                Icons.lunch_dining,
                                size: 32.0,
                                color: AppColors.grey2,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NutriScoreLabel extends StatelessWidget {
  const _NutriScoreLabel({required this.score});

  final String score;

  Color get _color {
    return switch (score.toUpperCase()) {
      'A' => AppColors.nutriscoreA,
      'B' => AppColors.nutriscoreB,
      'C' => AppColors.nutriscoreC,
      'D' => AppColors.nutriscoreD,
      'E' => AppColors.nutriscoreE,
      _ => AppColors.grey2,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6.0),
        Text(
          'Nutriscore : ${score.toUpperCase()}',
          style: TextStyle(
            fontSize: 13.0,
            color: AppColors.grey3,
          ),
        ),
      ],
    );
  }
}
