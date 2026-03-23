import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/scanner/barcode_scanner_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<RecordModel>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = PocketBaseAPI().getHistory();
  }

  Future<void> _onScanButtonPressed() async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (barcode != null && mounted) {
      await context.push('/product', extra: barcode);
      setState(() => _loadHistory());
    }
  }

  void _onLogout() {
    PocketBaseAPI().logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.my_scans_screen_title),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await context.push('/favorites');
              setState(() => _loadHistory());
            },
            icon: const Icon(Icons.star_outline),
            tooltip: 'Favoris',
          ),
          IconButton(
            onPressed: _onLogout,
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'D\u00e9connexion',
          ),
          IconButton(
            onPressed: _onScanButtonPressed,
            icon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(AppIcons.barcode),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<RecordModel>>(
        future: _historyFuture,
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
                    onPressed: () => setState(() => _loadHistory()),
                    child: const Text('R\u00e9essayer'),
                  ),
                ],
              ),
            );
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return HomePageEmpty(onScan: _onScanButtonPressed);
          }

          return RefreshIndicator(
            onRefresh: () async => setState(() => _loadHistory()),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: history.length,
              separatorBuilder: (_, __) => const Divider(height: 1.0),
              itemBuilder: (context, index) {
                final item = history[index];
                final picture = item.getStringValue('picture');
                final productName = item.getStringValue('product_name');
                final brands = item.getStringValue('brands');
                final barcode = item.getStringValue('barcode');

                return ListTile(
                  onTap: () async {
                    await context.push('/product', extra: barcode);
                    setState(() => _loadHistory());
                  },
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
                              child: const Icon(Icons.image_not_supported,
                                  size: 24.0),
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
                          child: const Icon(Icons.lunch_dining,
                              color: AppColors.grey2),
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
                  trailing:
                      const Icon(Icons.chevron_right, color: AppColors.grey2),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
