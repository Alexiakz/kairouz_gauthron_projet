/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("rappels_produits")

  collection.fields.addAt(14, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_distributeurs",
    "max": 0,
    "min": 0,
    "name": "distributeurs",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(15, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_date_debut_commercialisation",
    "max": 0,
    "min": 0,
    "name": "date_debut_commercialisation",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(16, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_date_fin_commercialisation",
    "max": 0,
    "min": 0,
    "name": "date_fin_commercialisation",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(17, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_liens_vers_les_images",
    "max": 0,
    "min": 0,
    "name": "liens_vers_les_images",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(18, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_lien_vers_affichette_pdf",
    "max": 0,
    "min": 0,
    "name": "lien_vers_affichette_pdf",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(19, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_description_complementaire_risque",
    "max": 0,
    "min": 0,
    "name": "description_complementaire_risque",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(20, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text_informations_complementaires",
    "max": 0,
    "min": 0,
    "name": "informations_complementaires",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("rappels_produits")

  collection.fields.removeById("text_distributeurs")
  collection.fields.removeById("text_date_debut_commercialisation")
  collection.fields.removeById("text_date_fin_commercialisation")
  collection.fields.removeById("text_liens_vers_les_images")
  collection.fields.removeById("text_lien_vers_affichette_pdf")
  collection.fields.removeById("text_description_complementaire_risque")
  collection.fields.removeById("text_informations_complementaires")

  return app.save(collection)
})
