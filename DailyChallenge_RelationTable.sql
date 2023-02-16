/*1. Créez 2 tables : Client et Profil client. Ils ont une relation One to One.
Un client ne peut avoir qu'un seul profil et un profil appartient à un seul client
La table Customer doit avoir les colonnes : id, first_name,last_name NOT NULL
La table de profil Client doit avoir les colonnes : id, isLoggedIn DEFAULT false(un booléen), customer_id(une référence à la table Client)
*/
CREATE TABLE customer(customer_id SERIAL PRIMARY KEY,
					   first_name VARCHAR (100) NOT NULL, 
					   last_name VARCHAR (100) NOT NULL
					  );
CREATE TABLE customer_profil( customer_profil_id SERIAL NOT NULL PRIMARY KEY,
							 isLoggedIn BOOLEAN  NOT NULL DEFAULT false,
							 customer_id INTEGER NOT NULL,
							 
CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES customer (customer_id));

-- 2/ Insérez ces clients							
INSERT INTO customer(first_name, last_name)	

VALUES 
('Jean', 'Doe'),
('Jerome', 'Lalu'),
('Lea', 'Rive');

SELECT * FROM customer;

/*3. Insérez ces profils clients, utilisez des sous-requêtes

Jean est connecté
Jérôme n'est pas connecté*/

INSERT INTO customer_profil(customer_id,isLoggedIn)
							
VALUES ((SELECT customer_id FROM customer WHERE first_name = 'Jean'),'TRUE');
							 
INSERT INTO customer_profil(customer_id,isLoggedIn)
VALUES ((SELECT customer_id FROM customer WHERE first_name = 'Jerome'),'FALSE');
			
SELECT * FROM customer_profil;


/*4. Utilisez les types de jointures pertinents pour afficher :

1.Le prénom des clients connectés
2.Toutes les colonnes first_name et isLoggedIn des clients - même les clients qui n'ont pas de profil.
3.Le nombre de clients non connectés*/

-- 1
SELECT customer.first_name FROM customer  INNER JOIN customer_profil ON customer.customer_id = customer_profil.customer_profil_id
AND isLoggedIn = TRUE;

-- 2
SELECT * FROM customer LEFT JOIN customer_profil ON customer.customer_id = customer_profil.customer_profil_id;

-- 3.
SELECT COUNT(isLoggedIn) AS nombre FROM customer  INNER JOIN customer_profil ON customer.customer_id = customer_profil.customer_profil_id
GROUP BY customer_profil.isloggedin
HAVING  IsloggedIn IS FALSE;

-- Partie II :

-- 1.Créez une table nommée Book , avec culumb : book_id SERIAL PRIMARY KEY, title NOT NULL,author NOT NULL


CREATE TABLE bOOK (book_id SERIAL NOT NULL PRIMARY KEY,
				  title VARCHAR (100) NOT NULL,
				   author VARCHAR(100) NOT NULL
				  );
				    
--2. Insérez ces livres :
INSERT INTO book(title,author)

VALUES 
	('Alice au pays des merveilles',' Lewis Carroll'),
	('Harry Potter', 'JK Rowling'),
	('Pour tuer un oiseau moqueur', 'Harper Lee');
	
-- 3. Créez une table nommée Student
CREATE TABLE student( std_id SERIAL PRIMARY KEY NOT NULL,
					 name VARCHAR (100) UNIQUE NOT NULL,
					 age SMALLINT );
					 
/*
-- 4. Insérez ces étudiants :

Jean, 12 ans
Léra, 11 ans
Patrick, 10 ans
Bob, 14 ans
*/


INSERT INTO student(name,age)

VALUES ('Jean', 12),
		('Léra', 11),
		('Patrick', 10),
		('Bob', 14);

-- Créez une table nommée Library , avec les colonnes :
-- book_fk_id ON DELETE CASCADE ON UPDATE CASCADE
-- student_id ON DELETE CASCADE ON UPDATE CASCADE
-- borrowed_date
-- Cette table, est une table de jonction pour une relation Plusieurs à Plusieurs avec les tables Livre et Élève : Un élève peut emprunter plusieurs livres, et un livre peut être emprunté par plusieurs enfants
-- book_fk_idest une clé étrangère représentant la colonne book_idde la table Book
-- student_fk_idest une clé étrangère représentant la colonne student_idde la table Student
-- La paire de clés étrangères est la clé primaire de la table de jonction

CREATE TABLE library (book_fk_id INTEGER NOT NULL,
					  student_fk_id INTEGER NOT NULL,
					  PRIMARY KEY (book_fk_id,student_fk_id),
					  borrowed_date TIMESTAMP,
FOREIGN KEY (book_fk_id) REFERENCES book(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (student_fk_id) REFERENCES student(std_id) ON DELETE CASCADE ON UPDATE CASCADE
 );
 
 
--  6/Ajoutez 4 enregistrements dans la table de jonction, utilisez des sous-requêtes.
-- l'étudiant nommé John , a emprunté le livre Alice au pays des merveilles le 15/02/2022
-- l'étudiant nommé Bob , a emprunté le livre To kill a mockingbird le 03/03/2021
-- l'étudiante nommée Lera , a emprunté le livre Alice au pays des merveilles le 23/05/2021
-- l'étudiant nommé Bob , a emprunté le livre Harry Potter le 12/08/2021

INSERT INTO library(student_fk_id,book_fk_id,brorrowed_date)

VALUES ((SELECT std_id FROM student WHERE student.name ILIKE '%Jean%'),
		(SELECT book_id FROM book WHERE book.title ILIKE '%Alice%'),'15/02/2022'),
		
		((SELECT std_id FROM student WHERE student.name ILIKE '%Bob%'),
		(SELECT book_id FROM book WHERE book.title ILIKE '%kill%'),'03/03/2021'),
		
		((SELECT std_id FROM student WHERE student.name ILIKE '%Bob%'),
		(SELECT book_id FROM book WHERE book.title ILIKE '%kill%'),'03/03/2021');
		
		
-- 7. Afficher les données
-- Sélectionnez toutes les colonnes de la table de jonction
SELECT * FROM library
-- Sélectionnez le nom de l'élève et le titre des livres empruntés
SELECT student.name,title FROM student INNER JOIN library ON library.student_fk_id = student.std_id INNER JOIN book ON book.book_id = library.book_fk_id
-- Sélectionnez l'âge moyen des enfants qui ont emprunté le livre Alice au pays des merveilles

-- Supprimer un étudiant de la table des étudiants, que s'est-il passé dans la table de jonction ?