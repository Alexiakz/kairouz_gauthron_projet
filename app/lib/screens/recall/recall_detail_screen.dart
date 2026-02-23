import 'package:flutter/material.dart';
import 'package:formation_flutter/model/recall.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RecallDetailScreen extends StatelessWidget {
  const RecallDetailScreen({super.key, required this.recall});

  final Recall recall;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D\u00e9tail du rappel'),
        centerTitle: false,
        actions: [
          if (recall.lienVersAffichettePdf.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Voir le PDF officiel',
              onPressed: () => _openUrl(recall.lienVersAffichettePdf),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFA60000),
                    size: 28.0,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Produit rappel\u00e9',
                      style: TextStyle(
                        color: const Color(0xFFA60000),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Product photo
            if (recall.liensVersLesImages.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    recall.liensVersLesImages,
                    height: 200.0,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            if (recall.liensVersLesImages.isNotEmpty)
              const SizedBox(height: 16.0),

            // Product name
            Text(
              recall.libelle,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Product info
            _SectionTitle(title: 'Informations produit'),
            const SizedBox(height: 8.0),
            _InfoRow(label: 'Marque', value: recall.marqueProduit),
            _InfoRow(label: 'Cat\u00e9gorie', value: recall.categorieProduit),
            _InfoRow(label: 'Code-barres (GTIN)', value: recall.gtin),

            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Commercialization dates
            _SectionTitle(title: 'Dates de commercialisation'),
            const SizedBox(height: 8.0),
            _InfoRow(label: 'D\u00e9but', value: recall.dateDebutCommercialisation),
            _InfoRow(label: 'Fin', value: recall.dateFinCommercialisation),

            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Recall dates
            _SectionTitle(title: 'Dates du rappel'),
            const SizedBox(height: 8.0),
            if (recall.datePublication != null)
              _InfoRow(
                label: 'Publication',
                value: DateFormat('dd/MM/yyyy').format(recall.datePublication!),
              ),
            if (recall.dateFinRappel != null)
              _InfoRow(
                label: 'Fin de proc\u00e9dure',
                value: DateFormat('dd/MM/yyyy').format(recall.dateFinRappel!),
              ),

            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Distributors
            if (recall.distributeurs.isNotEmpty) ...[
              _SectionTitle(title: 'Distributeurs'),
              const SizedBox(height: 8.0),
              Text(recall.distributeurs, style: const TextStyle(fontSize: 14.0)),
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
            ],

            // Zone
            _SectionTitle(title: 'Zone g\u00e9ographique de vente'),
            const SizedBox(height: 8.0),
            Text(
              recall.zoneGeographique.isNotEmpty
                  ? recall.zoneGeographique
                  : 'Non renseign\u00e9e',
              style: const TextStyle(fontSize: 14.0),
            ),

            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Reason
            _SectionTitle(title: 'Motif du rappel'),
            const SizedBox(height: 8.0),
            Text(
              recall.motifRappel.isNotEmpty
                  ? recall.motifRappel
                  : 'Non renseign\u00e9',
              style: const TextStyle(fontSize: 14.0),
            ),

            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Risks
            _SectionTitle(title: 'Risques encourus'),
            const SizedBox(height: 8.0),
            Text(
              recall.risquesEncourus.isNotEmpty
                  ? recall.risquesEncourus
                  : 'Non renseign\u00e9s',
              style: const TextStyle(fontSize: 14.0),
            ),

            // Complementary risk description
            if (recall.descriptionComplementaireRisque.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              _SectionTitle(title: 'Description compl\u00e9mentaire du risque'),
              const SizedBox(height: 8.0),
              Text(
                recall.descriptionComplementaireRisque,
                style: const TextStyle(fontSize: 14.0),
              ),
            ],

            // Preconisations
            if (recall.preconisationsSanitaires.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              _SectionTitle(title: 'Pr\u00e9conisations sanitaires'),
              const SizedBox(height: 8.0),
              Text(
                recall.preconisationsSanitaires,
                style: const TextStyle(fontSize: 14.0),
              ),
            ],

            // Additional info
            if (recall.informationsComplementaires.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              _SectionTitle(title: 'Informations compl\u00e9mentaires'),
              const SizedBox(height: 8.0),
              Text(
                recall.informationsComplementaires,
                style: const TextStyle(fontSize: 14.0),
              ),
            ],

            // Conduites a tenir
            if (recall.conduitesATenir.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Divider(),
              const SizedBox(height: 16.0),
              _SectionTitle(title: 'Conduites \u00e0 tenir'),
              const SizedBox(height: 8.0),
              Text(
                recall.conduitesATenir.replaceAll('|', '\n'),
                style: const TextStyle(fontSize: 14.0),
              ),
            ],

            const SizedBox(height: 24.0),

            // PDF button
            if (recall.lienVersAffichettePdf.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _openUrl(recall.lienVersAffichettePdf),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Voir la fiche officielle (PDF)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA60000),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160.0,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13.0,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}
