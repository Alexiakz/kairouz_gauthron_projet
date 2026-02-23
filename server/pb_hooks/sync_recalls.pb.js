cronAdd("syncRecalls", "0 */12 * * *", () => {
  console.log("=== DEBUT SYNC ===");

  const url = "https://codelabs.formation-flutter.fr/assets/rappels.json";

  try {
    const response = $http.send({
      url: url,
      method: "GET",
    });

    const data = response.json;
    const collection = $app.findCollectionByNameOrId("rappels_produits");

    let created = 0;
    let updated = 0;
    let errors = 0;

    for (const item of data) {
      try {
        const guid = item.rappel_guid || "";
        if (!guid) continue;

        let existing = null;
        try {
          existing = $app.findFirstRecordByData("rappels_produits", "rappel_guid", guid);
        } catch (err) {}

        if (existing) {
          existing.set("gtin", item.gtin ? item.gtin.toString() : "");
          existing.set("libelle", item.libelle || "");
          existing.set("marque_produit", item.marque_produit || "");
          existing.set("categorie_produit", item.categorie_produit || "");
          existing.set("motif_rappel", item.motif_rappel || "");
          existing.set("risques_encourus", item.risques_encourus || "");
          existing.set("preconisations_sanitaires", item.preconisations_sanitaires || "");
          existing.set("conduites_a_tenir", item.conduites_a_tenir_par_le_consommateur || "");
          existing.set("zone_geographique", item.zone_geographique_de_vente || "");
          existing.set("date_publication", item.date_publication || "");
          existing.set("date_fin_rappel", item.date_de_fin_de_la_procedure_de_rappel || "");
          existing.set("is_active", true);
          $app.save(existing);
          updated++;
        } else {
          const record = new Record(collection);
          record.set("rappel_guid", guid);
          record.set("gtin", item.gtin ? item.gtin.toString() : "");
          record.set("libelle", item.libelle || "");
          record.set("marque_produit", item.marque_produit || "");
          record.set("categorie_produit", item.categorie_produit || "");
          record.set("motif_rappel", item.motif_rappel || "");
          record.set("risques_encourus", item.risques_encourus || "");
          record.set("preconisations_sanitaires", item.preconisations_sanitaires || "");
          record.set("conduites_a_tenir", item.conduites_a_tenir_par_le_consommateur || "");
          record.set("zone_geographique", item.zone_geographique_de_vente || "");
          record.set("date_publication", item.date_publication || "");
          record.set("date_fin_rappel", item.date_de_fin_de_la_procedure_de_rappel || "");
          record.set("is_active", true);
          $app.save(record);
          created++;
        }
      } catch (itemError) {
        errors++;
        console.log("ERREUR sur item: " + itemError);
      }
    }

    console.log("=== SYNC TERMINEE === Crees: " + created + " | Maj: " + updated + " | Erreurs: " + errors);
  } catch (error) {
    console.log("=== ERREUR GLOBALE === " + error);
  }
});
