/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_2162793822")

  // add field
  collection.fields.addAt(2, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3396881563",
    "max": 0,
    "min": 0,
    "name": "gtin",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(3, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text2765490009",
    "max": 0,
    "min": 0,
    "name": "libelle",
    "pattern": "",
    "presentable": true,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(4, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text4034875186",
    "max": 0,
    "min": 0,
    "name": "marque_produit",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(5, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1982218885",
    "max": 0,
    "min": 0,
    "name": "categorie_produit",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(6, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1132946274",
    "max": 0,
    "min": 0,
    "name": "motif_rappel",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(7, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text452101428",
    "max": 0,
    "min": 0,
    "name": "risques_encourus",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(8, new Field({
    "convertURLs": false,
    "hidden": false,
    "id": "editor2286552982",
    "maxSize": 0,
    "name": "preconisations_sanitaires",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "editor"
  }))

  // add field
  collection.fields.addAt(9, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3539253638",
    "max": 0,
    "min": 0,
    "name": "conduites_a_tenir",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(10, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3656063658",
    "max": 0,
    "min": 0,
    "name": "zone_geographique",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(11, new Field({
    "hidden": false,
    "id": "date2420462245",
    "max": "",
    "min": "",
    "name": "date_publication",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "date"
  }))

  // add field
  collection.fields.addAt(12, new Field({
    "hidden": false,
    "id": "date2458159525",
    "max": "",
    "min": "",
    "name": "date_fin_rappel",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "date"
  }))

  // add field
  collection.fields.addAt(13, new Field({
    "hidden": false,
    "id": "bool458715613",
    "name": "is_active",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "bool"
  }))

  // update field
  collection.fields.addAt(1, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1542800728",
    "max": 0,
    "min": 0,
    "name": "rappel_guid",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": true,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2162793822")

  // remove field
  collection.fields.removeById("text3396881563")

  // remove field
  collection.fields.removeById("text2765490009")

  // remove field
  collection.fields.removeById("text4034875186")

  // remove field
  collection.fields.removeById("text1982218885")

  // remove field
  collection.fields.removeById("text1132946274")

  // remove field
  collection.fields.removeById("text452101428")

  // remove field
  collection.fields.removeById("editor2286552982")

  // remove field
  collection.fields.removeById("text3539253638")

  // remove field
  collection.fields.removeById("text3656063658")

  // remove field
  collection.fields.removeById("date2420462245")

  // remove field
  collection.fields.removeById("date2458159525")

  // remove field
  collection.fields.removeById("bool458715613")

  // update field
  collection.fields.addAt(1, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1542800728",
    "max": 0,
    "min": 0,
    "name": "field",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
})
