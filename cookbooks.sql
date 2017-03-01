  CREATE TABLE cookbooks(
   id INTEGER PRIMARY KEY,
   title STRING
 );

  CREATE TABLE recipes(
   id INTEGER PRIMARY KEY,
   name STRING,
   cookbook_id INTEGER,
   FOREIGN KEY (cookbook_id) REFERENCES cookbook(id)
 );

  CREATE TABLE ingredients(
   id INTEGER PRIMARY KEY,
   name STRING,
   recipe_id INTEGER,
   FOREIGN KEY (recipe_id) REFERENCES recipe(id)
 );


  INSERT INTO
    cookbooks (id, title)
  VALUES
    (1, "Chloe's Vegan Italian Kitchen"), (2, "The Joy of Cooking");

  INSERT INTO
    recipes (id, name, cookbook_id)
  VALUES
    (1, "Butternut Ravioli", 1),
    (2, "Chocolate Layer Cake", 2),
    (3, "Mint Chip Gelato Sandwich", 1),
    (4, "Grilled Corn", 2);

  INSERT INTO
    ingredients (id, name, recipe_id)
  VALUES
    (1, "Squash", 1),
    (2, "Sage", 1),
    (3, "Cacao", 2),
    (4, "Flour", 2),
    (5, "Mint", 3),
    (6, "Cashew Milk", 3),
    (7, "Corn", 4),
    (8, "Butter", 4);
