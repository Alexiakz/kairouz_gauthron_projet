import 'package:flutter/material.dart';
import 'package:formation_flutter/api/pocketbase_api.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/screens/scanner/barcode_scanner_screen.dart';
import 'package:formation_flutter/screens/shared/product_card.dart';
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
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(localizations.my_scans_screen_title),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: _onScanButtonPressed,
            icon: Icon(AppIcons.barcode),
            tooltip: 'Scanner',
          ),
          IconButton(
            onPressed: () async {
              await context.push('/favorites');
              setState(() => _loadHistory());
            },
            icon: const Icon(Icons.star),
            tooltip: 'Favoris',
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: IconButton(
              onPressed: _onLogout,
              icon: const Icon(Icons.arrow_forward),
              tooltip: 'D\u00e9connexion',
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
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final item = history[index];
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
                    setState(() => _loadHistory());
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
