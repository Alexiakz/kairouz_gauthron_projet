import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/recall_fetcher.dart';
import 'package:formation_flutter/screens/product/states/empty/product_page_empty.dart';
import 'package:formation_flutter/screens/product/states/success/product_page_body.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.barcode})
    : assert(barcode.length > 0);

  final String barcode;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isFavorite = false;
  bool _historySaved = false;
  Product? _displayedProduct;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    try {
      final result = await PocketBaseAPI().isFavorite(widget.barcode);
      if (mounted) setState(() => _isFavorite = result);
    } catch (_) {}
  }

  Future<void> _toggleFavorite(Product? product) async {
    try {
      if (_isFavorite) {
        await PocketBaseAPI().removeFavorite(widget.barcode);
      } else {
        await PocketBaseAPI().addFavorite(
          barcode: widget.barcode,
          productName: product?.name,
          picture: product?.picture,
          brands: product?.brands?.join(', '),
          nutriScore: product?.nutriScore?.name,
        );
      }
      if (mounted) setState(() => _isFavorite = !_isFavorite);
    } catch (_) {}
  }

  Future<void> _saveHistory(Product product) async {
    if (_historySaved) return;
    _historySaved = true;
    try {
      await PocketBaseAPI().saveToHistory(
        barcode: widget.barcode,
        productName: product.name,
        picture: product.picture,
        brands: product.brands?.join(', '),
        nutriScore: product.nutriScore?.name,
      );
    } catch (_) {}
  }

  Future<void> _saveHistoryFromRecall(Recall recall) async {
    if (_historySaved) return;
    _historySaved = true;
    try {
      await PocketBaseAPI().saveToHistory(
        barcode: widget.barcode,
        productName: recall.libelle,
        picture: recall.liensVersLesImages,
        brands: recall.marqueProduit,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductFetcher>(
          create: (_) => ProductFetcher(barcode: widget.barcode),
        ),
        ChangeNotifierProvider<RecallFetcher>(
          create: (_) => RecallFetcher(barcode: widget.barcode),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Consumer2<ProductFetcher, RecallFetcher>(
              builder: (BuildContext context, ProductFetcher productNotifier,
                  RecallFetcher recallNotifier, _) {
                final productState = productNotifier.state;
                final recallState = recallNotifier.state;

                // Loading
                if (productState is ProductFetcherLoading) {
                  return const ProductPageEmpty();
                }

                // Product found -> save to history and show product page
                if (productState is ProductFetcherSuccess) {
                  _displayedProduct = productState.product;
                  _saveHistory(productState.product);
                  return ProductPageBody(product: productState.product);
                }

                // Product NOT found but recall exists -> show product page with minimal data
                if (recallState is RecallFetcherSuccess &&
                    recallState.hasRecalls) {
                  final recall = recallState.recalls.first;
                  _saveHistoryFromRecall(recall);
                  final fallbackProduct = Product(
                    barcode: widget.barcode,
                    name: recall.libelle.isNotEmpty ? recall.libelle : null,
                    brands: recall.marqueProduit.isNotEmpty
                        ? [recall.marqueProduit]
                        : null,
                    picture: recall.liensVersLesImages.isNotEmpty
                        ? recall.liensVersLesImages
                        : null,
                  );
                  _displayedProduct = fallbackProduct;
                  return ProductPageBody(product: fallbackProduct);
                }

                // Recall still loading -> wait
                if (recallState is RecallFetcherLoading) {
                  return const ProductPageEmpty();
                }

                // Nothing found -> show error
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Produit non trouv\u00e9',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            PositionedDirectional(
              top: 0.0,
              start: 0.0,
              child: _HeaderIcon(
                icon: AppIcons.close,
                tooltip: materialLocalizations.closeButtonTooltip,
                onPressed: Navigator.of(context).pop,
              ),
            ),
            PositionedDirectional(
              top: 0.0,
              end: 0.0,
              child: _HeaderIcon(
                icon: _isFavorite ? Icons.star : Icons.star_border,
                tooltip: _isFavorite
                    ? 'Retirer des favoris'
                    : 'Ajouter aux favoris',
                onPressed: () => _toggleFavorite(_displayedProduct),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.tooltip, this.onPressed})
    : assert(tooltip.length > 0);

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: tooltip,
            child: InkWell(
              onTap: onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsetsDirectional.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.0),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
