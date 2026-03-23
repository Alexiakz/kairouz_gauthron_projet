import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/res/app_colors.dart';
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
              separatorBuilder: (_, __) => const Divider(height: 1.0),
              itemBuilder: (context, index) {
                final item = favorites[index];
                return _ProductListTile(
                  barcode: item.getStringValue('barcode'),
                  productName: item.getStringValue('product_name'),
                  brands: item.getStringValue('brands'),
                  picture: item.getStringValue('picture'),
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

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({
    required this.barcode,
    required this.productName,
    required this.brands,
    required this.picture,
    this.onTap,
  });

  final String barcode;
  final String productName;
  final String brands;
  final String picture;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: picture.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                picture,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50.0,
                  height: 50.0,
                  color: AppColors.grey1,
                  child: const Icon(Icons.image_not_supported, size: 24.0),
                ),
              ),
            )
          : Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: AppColors.grey1,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.lunch_dining, color: AppColors.grey2),
            ),
      title: Text(
        productName.isNotEmpty ? productName : barcode,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: brands.isNotEmpty
          ? Text(
              brands,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.grey2),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey2),
    );
  }
}
