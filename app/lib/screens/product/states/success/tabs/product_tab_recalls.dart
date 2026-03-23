import 'package:flutter/material.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/product/recall_fetcher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductTabRecalls extends StatelessWidget {
  const ProductTabRecalls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecallFetcher>(
      builder: (BuildContext context, RecallFetcher notifier, _) {
        return switch (notifier.state) {
          RecallFetcherLoading() => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          RecallFetcherError() => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'Erreur lors du chargement des rappels',
                style: TextStyle(color: AppColors.grey2),
              ),
            ),
          ),
          RecallFetcherSuccess(hasRecalls: false) => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'Aucun rappel pour ce produit',
                style: TextStyle(fontSize: 14.0, color: AppColors.grey2),
              ),
            ),
          ),
          RecallFetcherSuccess(recalls: var recalls) => _RecallsList(
            recalls: recalls,
          ),
        };
      },
    );
  }
}

class _RecallsList extends StatelessWidget {
  const _RecallsList({required this.recalls});

  final List<Recall> recalls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final recall in recalls) ...[
          _RecallCard(recall: recall),
          if (recall != recalls.last) const SizedBox(height: 12.0),
        ],
        const SizedBox(height: 20.0),
      ],
    );
  }
}

class _RecallCard extends StatelessWidget {
  const _RecallCard({required this.recall});

  final Recall recall;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFFFF0000).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with share button
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFA60000),
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'Produit rappel\u00e9',
                  style: TextStyle(
                    color: const Color(0xFFA60000),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Color(0xFFA60000)),
                tooltip: 'Partager',
                onPressed: () => _share(),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Libellé
          if (recall.libelle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                recall.libelle,
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w600),
              ),
            ),

          // Image
          if (recall.liensVersLesImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  recall.liensVersLesImages,
                  height: 150.0,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),

          // Motif
          if (recall.motifRappel.isNotEmpty) ...[
            Text('Motif du rappel',
                style: context.theme.title3.copyWith(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text(recall.motifRappel,
                style: const TextStyle(fontSize: 13.0)),
            const SizedBox(height: 12.0),
          ],

          // Risques
          if (recall.risquesEncourus.isNotEmpty) ...[
            Text('Risques encourus',
                style: context.theme.title3.copyWith(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text(recall.risquesEncourus,
                style: const TextStyle(fontSize: 13.0)),
            const SizedBox(height: 12.0),
          ],

          // Description complémentaire du risque
          if (recall.descriptionComplementaireRisque.isNotEmpty) ...[
            Text('Description compl\u00e9mentaire du risque',
                style: context.theme.title3.copyWith(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text(recall.descriptionComplementaireRisque,
                style: const TextStyle(fontSize: 13.0)),
            const SizedBox(height: 12.0),
          ],

          // Marque
          if (recall.marqueProduit.isNotEmpty)
            _InfoLine(label: 'Marque', value: recall.marqueProduit),

          // Categorie
          if (recall.categorieProduit.isNotEmpty)
            _InfoLine(
                label: 'Cat\u00e9gorie', value: recall.categorieProduit),

          // GTIN
          if (recall.gtin.isNotEmpty)
            _InfoLine(label: 'Code-barres', value: recall.gtin),

          // Distributeurs
          if (recall.distributeurs.isNotEmpty)
            _InfoLine(label: 'Distributeurs', value: recall.distributeurs),

          // Zone geographique
          if (recall.zoneGeographique.isNotEmpty)
            _InfoLine(label: 'Zone g\u00e9ographique', value: recall.zoneGeographique),

          // Dates de commercialisation
          if (recall.dateDebutCommercialisation.isNotEmpty)
            _InfoLine(
              label: 'D\u00e9but commerc.',
              value: recall.dateDebutCommercialisation,
            ),
          if (recall.dateFinCommercialisation.isNotEmpty)
            _InfoLine(
              label: 'Fin commerc.',
              value: recall.dateFinCommercialisation,
            ),

          // Dates du rappel
          if (recall.datePublication != null)
            _InfoLine(
              label: 'Publi\u00e9 le',
              value: DateFormat('dd/MM/yyyy').format(recall.datePublication!),
            ),
          if (recall.dateFinRappel != null)
            _InfoLine(
              label: 'Fin de proc\u00e9dure',
              value: DateFormat('dd/MM/yyyy').format(recall.dateFinRappel!),
            ),

          // Preconisations
          if (recall.preconisationsSanitaires.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Text('Pr\u00e9conisations sanitaires',
                style: context.theme.title3.copyWith(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text(recall.preconisationsSanitaires,
                style: const TextStyle(fontSize: 13.0)),
          ],

          // Conduites a tenir
          if (recall.conduitesATenir.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Text('Conduites \u00e0 tenir',
                style: context.theme.title3.copyWith(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text(recall.conduitesATenir.replaceAll('|', '\n'),
                style: const TextStyle(fontSize: 13.0)),
          ],

          // Informations complémentaires
          if (recall.informationsComplementaires.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Text('Informations compl\u00e9mentaires',
                style: context.theme.title3.copyWith(fontSize: 14.0)),
            const SizedBox(height: 4.0),
            Text(recall.informationsComplementaires,
                style: const TextStyle(fontSize: 13.0)),
          ],

          // Lien PDF
          if (recall.lienVersAffichettePdf.isNotEmpty) ...[
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openPdf(),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Fiche officielle (PDF)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFA60000),
                  side: const BorderSide(color: Color(0xFFA60000)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _share() {
    final buffer = StringBuffer();
    buffer.writeln('Rappel produit : ${recall.libelle}');
    if (recall.marqueProduit.isNotEmpty) {
      buffer.writeln('Marque : ${recall.marqueProduit}');
    }
    if (recall.motifRappel.isNotEmpty) {
      buffer.writeln('Motif : ${recall.motifRappel}');
    }
    if (recall.lienVersAffichettePdf.isNotEmpty) {
      buffer.writeln('\nFiche officielle : ${recall.lienVersAffichettePdf}');
    }
    Share.share(buffer.toString());
  }

  Future<void> _openPdf() async {
    final uri = Uri.parse(recall.lienVersAffichettePdf);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.0, color: AppColors.grey2),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13.0)),
          ),
        ],
      ),
    );
  }
}
