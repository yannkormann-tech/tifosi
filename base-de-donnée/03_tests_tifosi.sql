-- Projet Tifosi - requetes de verification
-- Les resultats indiques ci-dessous correspondent au jeu de donnees insere par 02_seed_tifosi.sql.

USE tifosi;

-- Requete 1 - Noms des focaccias (ordre alphabetique)
-- Attendu : 8 lignes triees de A a Z
-- Obtenu  : Americaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne, Raclaccia, Tradizione
-- Ecart   : aucun
SELECT nom_focaccia
FROM focaccia
ORDER BY nom_focaccia ASC;

-- Requete 2 - Nombre total d'ingredients
-- Attendu : 25
-- Obtenu  : 25
-- Ecart   : aucun
SELECT COUNT(*) AS total_ingredients
FROM ingredient;

-- Requete 3 - Prix moyen des focaccias
-- Attendu : 10.38
-- Obtenu  : 10.38
-- Ecart   : aucun
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM focaccia;

-- Requete 4 - Boissons avec leur marque (tri sur le nom de boisson)
-- Attendu : 12 lignes
-- Obtenu  : Capri-sun/Coca-cola, Coca-cola original/Coca-cola, Coca-cola zero/Coca-cola,
--           Eau de source/Cristalline, Fanta citron/Coca-cola, Fanta orange/Coca-cola,
--           Lipton Peach/Pepsico, Lipton zero citron/Pepsico,
--           Monster energy ultra blue/Monster, Monster energy ultra gold/Monster,
--           Pepsi/Pepsico, Pepsi Max Zero/Pepsico
-- Ecart   : aucun
SELECT b.nom_boisson, m.nom_marque
FROM boisson b
JOIN marque m ON m.id_marque = b.id_marque
ORDER BY b.nom_boisson ASC;

-- Requete 5 - Ingredients de la Raclaccia
-- Attendu : 7 ingredients
-- Obtenu  : Ail, Base Tomate, Champignon, Cresson, Parmesan, Poivre, Raclette
-- Ecart   : aucun
SELECT i.nom_ingredient, fi.quantite_grammes
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
WHERE f.nom_focaccia = 'Raclaccia'
ORDER BY i.nom_ingredient ASC;

-- Requete 6 - Nombre d'ingredients par focaccia
-- Attendu : 8 lignes
-- Obtenu  : Americaine(8), Emmentalaccia(7), Gorgonzollaccia(8), Hawaienne(9),
--           Mozaccia(10), Paysanne(12), Raclaccia(7), Tradizione(9)
-- Ecart   : aucun
SELECT f.nom_focaccia, COUNT(fi.id_ingredient) AS nb_ingredients
FROM focaccia f
LEFT JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY f.nom_focaccia ASC;

-- Requete 7 - Focaccia avec le plus d'ingredients
-- Attendu : Paysanne (12)
-- Obtenu  : Paysanne (12)
-- Ecart   : aucun
SELECT f.nom_focaccia, COUNT(fi.id_ingredient) AS nb_ingredients
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
GROUP BY f.id_focaccia, f.nom_focaccia
ORDER BY nb_ingredients DESC, f.nom_focaccia ASC
LIMIT 1;

-- Requete 8 - Focaccias qui contiennent de l'ail
-- Attendu : Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia
-- Obtenu  : Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia
-- Ecart   : aucun
SELECT DISTINCT f.nom_focaccia
FROM focaccia f
JOIN focaccia_ingredient fi ON fi.id_focaccia = f.id_focaccia
JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
WHERE i.nom_ingredient = 'Ail'
ORDER BY f.nom_focaccia ASC;

-- Requete 9 - Ingredients inutilises
-- Attendu : Salami, Tomate cerise
-- Obtenu  : Salami, Tomate cerise
-- Ecart   : aucun
SELECT i.nom_ingredient
FROM ingredient i
LEFT JOIN focaccia_ingredient fi ON fi.id_ingredient = i.id_ingredient
WHERE fi.id_focaccia IS NULL
ORDER BY i.nom_ingredient ASC;

-- Requete 10 - Focaccias sans champignons
-- Attendu : Hawaienne
-- Obtenu  : Hawaienne
-- Ecart   : aucun
SELECT f.nom_focaccia
FROM focaccia f
WHERE NOT EXISTS (
  SELECT 1
  FROM focaccia_ingredient fi
  JOIN ingredient i ON i.id_ingredient = fi.id_ingredient
  WHERE fi.id_focaccia = f.id_focaccia
    AND i.nom_ingredient = 'Champignon'
)
ORDER BY f.nom_focaccia ASC;
