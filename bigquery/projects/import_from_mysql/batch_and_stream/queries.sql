CREATE TABLE user (
    id INTEGER(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    address VARCHAR(500)
);

INSERT INTO users.user (id, first_name, last_name, address) VALUES (1, 'Adam', 'Smith', '12 Main Street');
INSERT INTO users.user (id, first_name, last_name, address) VALUES (2, 'Jacques', 'Dupont', '12 rue de la Ville');
INSERT INTO users.user (id, first_name, last_name, address) VALUES (3, 'Antonio', 'Perez', '12 calle Madrid');
