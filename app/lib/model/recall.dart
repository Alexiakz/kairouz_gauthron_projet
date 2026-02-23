class Recall {
  final String id;
  final String rappelGuid;
  final String gtin;
  final String libelle;
  final String marqueProduit;
  final String categorieProduit;
  final String motifRappel;
  final String risquesEncourus;
  final String preconisationsSanitaires;
  final String conduitesATenir;
  final String zoneGeographique;
  final String distributeurs;
  final String dateDebutCommercialisation;
  final String dateFinCommercialisation;
  final String liensVersLesImages;
  final String lienVersAffichettePdf;
  final String descriptionComplementaireRisque;
  final String informationsComplementaires;
  final DateTime? datePublication;
  final DateTime? dateFinRappel;
  final bool isActive;

  Recall({
    required this.id,
    required this.rappelGuid,
    required this.gtin,
    required this.libelle,
    required this.marqueProduit,
    required this.categorieProduit,
    required this.motifRappel,
    required this.risquesEncourus,
    required this.preconisationsSanitaires,
    required this.conduitesATenir,
    required this.zoneGeographique,
    required this.distributeurs,
    required this.dateDebutCommercialisation,
    required this.dateFinCommercialisation,
    required this.liensVersLesImages,
    required this.lienVersAffichettePdf,
    required this.descriptionComplementaireRisque,
    required this.informationsComplementaires,
    this.datePublication,
    this.dateFinRappel,
    required this.isActive,
  });

  factory Recall.fromJson(Map<String, dynamic> json) {
    return Recall(
      id: json['id'] as String? ?? '',
      rappelGuid: json['rappel_guid'] as String? ?? '',
      gtin: json['gtin'] as String? ?? '',
      libelle: json['libelle'] as String? ?? '',
      marqueProduit: json['marque_produit'] as String? ?? '',
      categorieProduit: json['categorie_produit'] as String? ?? '',
      motifRappel: json['motif_rappel'] as String? ?? '',
      risquesEncourus: json['risques_encourus'] as String? ?? '',
      preconisationsSanitaires:
          json['preconisations_sanitaires'] as String? ?? '',
      conduitesATenir: json['conduites_a_tenir'] as String? ?? '',
      zoneGeographique: json['zone_geographique'] as String? ?? '',
      distributeurs: json['distributeurs'] as String? ?? '',
      dateDebutCommercialisation:
          json['date_debut_commercialisation'] as String? ?? '',
      dateFinCommercialisation:
          json['date_fin_commercialisation'] as String? ?? '',
      liensVersLesImages: json['liens_vers_les_images'] as String? ?? '',
      lienVersAffichettePdf:
          json['lien_vers_affichette_pdf'] as String? ?? '',
      descriptionComplementaireRisque:
          json['description_complementaire_risque'] as String? ?? '',
      informationsComplementaires:
          json['informations_complementaires'] as String? ?? '',
      datePublication: json['date_publication'] != null &&
              (json['date_publication'] as String).isNotEmpty
          ? DateTime.tryParse(json['date_publication'] as String)
          : null,
      dateFinRappel: json['date_fin_rappel'] != null &&
              (json['date_fin_rappel'] as String).isNotEmpty
          ? DateTime.tryParse(json['date_fin_rappel'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}
