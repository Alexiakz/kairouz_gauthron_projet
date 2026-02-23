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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
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
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.36),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFA60000),
                        size: 24.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Produit rappel\u00e9',
                              style: TextStyle(
                                color: const Color(0xFFA60000),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              recall.motifRappel,
                              style: TextStyle(
                                color: const Color(0xFFA60000),
                                fontSize: 12.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFFA60000),
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
