import 'package:flutter/material.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:formation_flutter/screens/product/recall_fetcher.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecallBanner extends StatelessWidget {
  const RecallBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecallFetcher>(
      builder: (BuildContext context, RecallFetcher notifier, _) {
        return switch (notifier.state) {
          RecallFetcherLoading() => const SizedBox.shrink(),
          RecallFetcherError() => const SizedBox.shrink(),
          RecallFetcherSuccess(hasRecalls: false) => const SizedBox.shrink(),
          RecallFetcherSuccess(recalls: var recalls) => _RecallAlertBanner(
            recalls: recalls,
          ),
        };
      },
    );
  }
}

class _RecallAlertBanner extends StatelessWidget {
  const _RecallAlertBanner({required this.recalls});

  final List<Recall> recalls;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: recalls
            .map(
              (recall) => GestureDetector(
                onTap: () => context.push('/recall', extra: recall),
                child: Container(
                  width: double.infinity,
                  margin: recalls.length > 1
                      ? const EdgeInsets.only(bottom: 8.0)
                      : EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC5C5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ce produit fait l\'objet d\'un rappel produit',
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF333333),
                        size: 22.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
