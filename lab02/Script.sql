DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers (
    id             INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    product        VARCHAR(100) NOT NULL,
    delivery       DATE NOT NULL,
    price          NUMERIC(10, 2) DEFAULT 0.0 CHECK (price  >= 0),
    price_with_tax NUMERIC(10, 2) GENERATED ALWAYS AS (price * 1.20) STORED,
    phone          VARCHAR(20) UNIQUE,
    email          VARCHAR(100) UNIQUE,
    photo          BYTEA 
);

INSERT INTO suppliers (name, product, delivery, price, phone, email)
VALUES ('Sup_0', 'Prod_0', CURRENT_DATE, 1654.0, '+380661111111', 'zero@mail.com');

DO $$ 
DECLARE 
    n INT := 20; 
	i INT := 1;
BEGIN
    WHILE i <= n LOOP
        INSERT INTO suppliers (name, product, delivery, price, phone, email)
        VALUES (
            'Supplier_' || i, 
            'Product_' || i, 
            CURRENT_DATE + ((-100 + random() * 200)::INT * INTERVAL '1 day'), 
            (1 + random() * 1999)::NUMERIC(10,2), 
            '+38066' || (10000000 + (random() * 99999999)::BIGINT)::TEXT, 
            'usermail' || i || '@mail.com'
        );
		i := i + 1;
    END LOOP;
END $$;

SELECT * FROM suppliers;

UPDATE suppliers SET email = NULL WHERE id IN (3, 4, 7, 16, 19);
UPDATE suppliers SET phone = NULL WHERE id IN (5, 6, 7, 15, 16);

SELECT * FROM suppliers ORDER BY delivery ASC;
SELECT * FROM suppliers LIMIT 5;
SELECT * FROM suppliers 
	ORDER BY id
	OFFSET 10 ROWS 
	FETCH NEXT 5 ROWS ONLY;
SELECT * FROM suppliers WHERE phone LIKE '%0';
SELECT * FROM suppliers WHERE product ILIKE 'product_1%';
SELECT * FROM suppliers WHERE product IN ('Product_7', 'Product_14');
SELECT * FROM suppliers WHERE price BETWEEN 500 AND 1000;
SELECT * FROM suppliers WHERE email IS NULL;
SELECT * FROM suppliers WHERE phone IS NOT NULL AND (id % 3 != 0);
SELECT * FROM suppliers WHERE NOT id = 7;

DELETE FROM suppliers WHERE id BETWEEN 13 AND 17;

SELECT name, price,
    CASE 
        WHEN price > 1500 THEN 'Преміум'
        WHEN price BETWEEN 500 AND 1000 THEN 'Середній'
        ELSE 'Бюджетний'
    END AS category
FROM suppliers;
