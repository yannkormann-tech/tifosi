-- Projet Tifosi - creation du schema (MySQL 8)
-- Ce script cree la base + l'utilisateur local + toutes les tables.

-- Base de donnees
CREATE DATABASE IF NOT EXISTS tifosi
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

-- Compte local pour administrer uniquement la base tifosi
CREATE USER IF NOT EXISTS 'tifosi'@'localhost' IDENTIFIED BY 'Tifosi@2026!';
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

USE tifosi;

-- Reset propre si le script est relance
DROP TABLE IF EXISTS focaccia_ingredient;
DROP TABLE IF EXISTS boisson;
DROP TABLE IF EXISTS focaccia;
DROP TABLE IF EXISTS ingredient;
DROP TABLE IF EXISTS marque;

-- Tables principales
CREATE TABLE marque (
  id_marque INT UNSIGNED NOT NULL,
  nom_marque VARCHAR(100) NOT NULL,
  CONSTRAINT pk_marque PRIMARY KEY (id_marque),
  CONSTRAINT uq_marque_nom UNIQUE (nom_marque)
) ENGINE=InnoDB;

CREATE TABLE ingredient (
  id_ingredient INT UNSIGNED NOT NULL,
  nom_ingredient VARCHAR(100) NOT NULL,
  CONSTRAINT pk_ingredient PRIMARY KEY (id_ingredient),
  CONSTRAINT uq_ingredient_nom UNIQUE (nom_ingredient)
) ENGINE=InnoDB;

CREATE TABLE focaccia (
  id_focaccia INT UNSIGNED NOT NULL,
  nom_focaccia VARCHAR(100) NOT NULL,
  prix DECIMAL(5,2) NOT NULL,
  CONSTRAINT pk_focaccia PRIMARY KEY (id_focaccia),
  CONSTRAINT uq_focaccia_nom UNIQUE (nom_focaccia),
  CONSTRAINT ck_focaccia_prix CHECK (prix > 0)
) ENGINE=InnoDB;

CREATE TABLE boisson (
  id_boisson INT UNSIGNED NOT NULL,
  nom_boisson VARCHAR(120) NOT NULL,
  id_marque INT UNSIGNED NOT NULL,
  CONSTRAINT pk_boisson PRIMARY KEY (id_boisson),
  CONSTRAINT uq_boisson_nom_marque UNIQUE (nom_boisson, id_marque),
  CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque)
    REFERENCES marque(id_marque)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE focaccia_ingredient (
  id_focaccia INT UNSIGNED NOT NULL,
  id_ingredient INT UNSIGNED NOT NULL,
  quantite_grammes INT UNSIGNED NOT NULL,
  CONSTRAINT pk_focaccia_ingredient PRIMARY KEY (id_focaccia, id_ingredient),
  CONSTRAINT ck_focaccia_ingredient_qte CHECK (quantite_grammes > 0),
  CONSTRAINT fk_fi_focaccia FOREIGN KEY (id_focaccia)
    REFERENCES focaccia(id_focaccia)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_fi_ingredient FOREIGN KEY (id_ingredient)
    REFERENCES ingredient(id_ingredient)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;
