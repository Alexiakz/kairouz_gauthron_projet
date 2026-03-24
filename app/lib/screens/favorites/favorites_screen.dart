import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/shared/product_card.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<RecordModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = PocketBaseAPI().getFavorites();
  }

  void _refresh() {
    setState(() {
      _favoritesFuture = PocketBaseAPI().getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Mes favoris'),
        centerTitle: false,
      ),
      body: FutureBuilder<List<RecordModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Erreur lors du chargement'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('R\u00e9essayer'),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Aucun favori pour le moment',
                style: TextStyle(fontSize: 16.0, color: AppColors.grey2),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final item = favorites[index];
                return ProductCard(
                  picture: item.getStringValue('picture'),
                  productName: item.getStringValue('product_name'),
                  brands: item.getStringValue('brands'),
                  barcode: item.getStringValue('barcode'),
                  nutriScore: item.getStringValue('nutri_score'),
                  onTap: () async {
                    await context.push(
                      '/product',
                      extra: item.getStringValue('barcode'),
                    );
                    _refresh();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
