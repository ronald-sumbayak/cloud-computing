CREATE DATABASE tekankata;
GRANT ALL PRIVILEGES ON *.* TO 'cloud'@'localhost' IDENTIFIED BY 'cloud';
USE tekankata;
CREATE TABLE pembayaran (
    id       INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR (64),
    email    VARCHAR (128),
    file     VARCHAR (512),
    verified INT
);
INSERT INTO pembayaran VALUES (1, 'www', 'admin@tekankata.com', '.', 2);
