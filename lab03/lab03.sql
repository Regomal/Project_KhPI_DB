DROP TABLE IF EXISTS suppliers CASCADE;
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

-- Процедура для генерації нових даних
CREATE OR REPLACE PROCEDURE generate_suppliers(num_rows INT DEFAULT 1)
AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..num_rows LOOP
        INSERT INTO suppliers (name, product, delivery, price, phone, email)
        VALUES (
            'Supplier_' || i,
            'Product_' || i,
            CURRENT_DATE + ((-100 + random() * 200)::INT * INTERVAL '1 day'),
            (1 + random() * 1999)::NUMERIC(10,2),
            '+38066' || (10000000 + (random() * 99999999)::BIGINT)::TEXT,
            'usermail' || i || '@mail.com'
        );
    END LOOP;

    RAISE NOTICE 'Створено % строк', num_rows;
END;
$$ LANGUAGE plpgsql;

CALL generate_suppliers(20);
SELECT * FROM suppliers;


-- Скалярна функція
CREATE OR REPLACE FUNCTION get_dc_price(p_id INT, dc_percent NUMERIC)
    RETURNS NUMERIC(10, 2)
AS $$
BEGIN
    RETURN (
        SELECT ROUND(price * (1 - dc_percent / 100), 2)
        FROM suppliers
        WHERE id = p_id
    );
END;
    $$ LANGUAGE plpgsql;

SELECT name, get_dc_price(id, 15) as sale_price
    FROM suppliers
    WHERE id = 5;


-- Таблична функція
CREATE OR REPLACE FUNCTION get_exp_suppliers(min_price NUMERIC)
    RETURNS TABLE(s_name VARCHAR, s_product VARCHAR, s_price NUMERIC)
AS $$
BEGIN
    RETURN QUERY
    SELECT name, product, price
    FROM suppliers
    WHERE price > min_price;
END;
    $$ LANGUAGE plpgsql;

SELECT * FROM get_exp_suppliers(1000.00);


-- Уявлення(view)
CREATE OR REPLACE VIEW view_supplier_contacts AS
SELECT
    name AS "Постачальник",
    product AS "Товар",
    phone AS "Телефон",
    email AS "Пошта",
    price_with_tax AS "Ціна з податком"
FROM suppliers
ORDER BY name;

SELECT * FROM view_supplier_contacts;


-- Таблиця для ведення історій
DROP TABLE IF EXISTS suppliers_history;
CREATE TABLE suppliers_history (
    id             INT,
    name           VARCHAR(100),
    product        VARCHAR(100),
    deleted_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operation      VARCHAR(20)
);

CREATE OR REPLACE FUNCTION log_supplier_deletion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO suppliers_history (id, name, product, operation)
    VALUES (OLD.id, OLD.name, OLD.product, 'DELETED');
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_suppliers_delete ON suppliers;

CREATE TRIGGER trg_suppliers_delete
AFTER DELETE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION log_supplier_deletion();
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
CREATE OR REPLACE FUNCTION log_supplier_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO suppliers_history (id, name, product, operation)
    VALUES (OLD.id, OLD.name, OLD.product, 'UPDATED');
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_suppliers_update ON suppliers;

CREATE TRIGGER trg_suppliers_update
AFTER UPDATE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION log_supplier_update();

DELETE FROM suppliers WHERE id BETWEEN 13 AND 17;
UPDATE suppliers SET phone = NULL WHERE id IN (5, 6, 7, 15, 16);

SELECT id, name, product, 'ACTIVE' AS status
FROM suppliers

UNION ALL

SELECT id, name, product, operation
FROM suppliers_history;