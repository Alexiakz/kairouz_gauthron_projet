onBootstrap((e) => {
  e.next();

  const doSync = () => {
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

          const fields = {
            rappel_guid: guid,
            gtin: item.gtin ? item.gtin.toString() : "",
            libelle: item.libelle || "",
            marque_produit: item.marque_produit || "",
            categorie_produit: item.categorie_produit || "",
            motif_rappel: item.motif_rappel || "",
            risques_encourus: item.risques_encourus || "",
            preconisations_sanitaires: item.preconisations_sanitaires || "",
            conduites_a_tenir: item.conduites_a_tenir_par_le_consommateur || "",
            zone_geographique: item.zone_geographique_de_vente || "",
            date_publication: item.date_publication || "",
            date_fin_rappel: item.date_de_fin_de_la_procedure_de_rappel || "",
            distributeurs: item.distributeurs || "",
            date_debut_commercialisation: item.date_debut_commercialisation || "",
            date_fin_commercialisation: item.date_date_fin_commercialisation || "",
            liens_vers_les_images: item.liens_vers_les_images || "",
            lien_vers_affichette_pdf: item.lien_vers_affichette_pdf || "",
            description_complementaire_risque: item.description_complementaire_risque || "",
            informations_complementaires: item.informations_complementaires || "",
            is_active: true,
          };

          if (existing) {
            for (const key in fields) {
              existing.set(key, fields[key]);
            }
            $app.save(existing);
            updated++;
          } else {
            const record = new Record(collection);
            for (const key in fields) {
              record.set(key, fields[key]);
            }
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
  };

  // Sync immediate au demarrage
  doSync();

  // Sync toutes les 12h ensuite
  $app.cron().add("syncRecalls", "0 */12 * * *", () => {
    doSync();
  });
});
