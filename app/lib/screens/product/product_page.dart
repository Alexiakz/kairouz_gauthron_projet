import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/recall_fetcher.dart';
import 'package:formation_flutter/screens/product/states/empty/product_page_empty.dart';
import 'package:formation_flutter/screens/product/states/success/product_page_body.dart';
import 'package:formation_flutter/screens/recall/recall_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.barcode})
    : assert(barcode.length > 0);

  final String barcode;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductFetcher>(
          create: (_) => ProductFetcher(barcode: barcode),
        ),
        ChangeNotifierProvider<RecallFetcher>(
          create: (_) => RecallFetcher(barcode: barcode),
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

                // Product found -> show product page with recall banner
                if (productState is ProductFetcherSuccess) {
                  return ProductPageBody();
                }

                // Product NOT found but recall exists -> show recall directly
                if (recallState is RecallFetcherSuccess &&
                    recallState.hasRecalls) {
                  return RecallDetailScreen(recall: recallState.recalls.first);
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
                icon: AppIcons.share,
                tooltip: materialLocalizations.shareButtonLabel,
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
