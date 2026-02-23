cronAdd("syncRecalls", "*/1 * * * *", async () => {
  console.log("Sync des rappels produits...");

  const url = "https://codelabs.formation-flutter.fr/assets/rappels.json";

  try {
    const response = await fetch(url);
    const data = await response.json();

    const collection = $app.dao().findCollectionByNameOrId("rappels_produits");

    for (const item of data) {

      const guid = item.rappel_guid;

      let existing = null;

      try {
        existing = await $app.dao().findFirstRecordByData(
          collection.id,
          "rappel_guid",
          guid
        );
      } catch (e) {}

      const recordData = {
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
        date_publication: item.date_publication || null,
        date_fin_rappel: item.date_de_fin_de_la_procedure_de_rappel || null,
        is_active: true
      };

      if (existing) {
        Object.assign(existing, recordData);
        await $app.dao().saveRecord(existing);
      } else {
        const record = new Record(collection, recordData);
        await $app.dao().saveRecord(record);
      }
    }

    console.log("✅ Sync terminée !");
  } catch (error) {
    console.error("❌ Erreur sync rappels :", error);
  }
});