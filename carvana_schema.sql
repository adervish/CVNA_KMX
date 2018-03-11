--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.4
-- Dumped by pg_dump version 9.6.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: carvana; Type: SCHEMA; Schema: -; Owner: acd
--

CREATE SCHEMA carvana;


ALTER SCHEMA carvana OWNER TO acd;

SET search_path = carvana, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: carvana_doc; Type: TABLE; Schema: carvana; Owner: acd
--

CREATE TABLE carvana_doc (
    doc jsonb,
    filename text,
    date date
);


ALTER TABLE carvana_doc OWNER TO acd;

--
-- Name: carvana_vehicles; Type: MATERIALIZED VIEW; Schema: carvana; Owner: acd
--

CREATE MATERIALIZED VIEW carvana_vehicles AS
 SELECT (vehicles_jsonb.vehicle -> 'vin'::text) AS vin,
    vehicles_jsonb.date,
    (vehicles_jsonb.vehicle -> 'stockNumber'::text) AS stockid,
    (vehicles_jsonb.vehicle -> 'make'::text) AS make,
    (vehicles_jsonb.vehicle -> 'model'::text) AS model,
    (vehicles_jsonb.vehicle -> 'trim'::text) AS "trim",
    (vehicles_jsonb.vehicle -> 'trimLine1'::text) AS trimline1,
    (vehicles_jsonb.vehicle -> 'trimLine2'::text) AS trimline2,
    ((vehicles_jsonb.vehicle -> 'tileMoreFeatures'::text))::text AS morefeatures,
    (((vehicles_jsonb.vehicle -> 'mileage'::text))::text)::numeric AS miles,
    ((((vehicles_jsonb.vehicle -> 'price'::text) -> 'total'::text))::text)::numeric AS price,
    (vehicles_jsonb.vehicle -> 'year'::text) AS year,
    max(((vehicles_jsonb.vehicle -> 'isPurchasePending'::text))::text) AS pending,
    max(((vehicles_jsonb.vehicle -> 'daysUntilAvailable'::text))::text) AS daystoavail,
    (vehicles_jsonb.vehicle -> 'addedToCoreInventoryDateTime'::text) AS dateadded,
    max(((vehicles_jsonb.vehicle -> 'locationId'::text))::text) AS location,
    (vehicles_jsonb.vehicle -> 'ext_TileColorName'::text) AS color
   FROM ( SELECT carvana_doc.date,
            jsonb_array_elements(((carvana_doc.doc -> 'inventory'::text) -> 'vehicles'::text)) AS vehicle
           FROM carvana_doc) vehicles_jsonb
  GROUP BY (vehicles_jsonb.vehicle -> 'vin'::text), (vehicles_jsonb.vehicle -> 'stockNumber'::text), (vehicles_jsonb.vehicle -> 'make'::text), (vehicles_jsonb.vehicle -> 'model'::text), (vehicles_jsonb.vehicle -> 'trim'::text), (((vehicles_jsonb.vehicle -> 'mileage'::text))::text)::numeric, ((((vehicles_jsonb.vehicle -> 'price'::text) -> 'total'::text))::text)::numeric, (vehicles_jsonb.vehicle -> 'year'::text), (vehicles_jsonb.vehicle -> 'addedToCoreInventoryDateTime'::text), (vehicles_jsonb.vehicle -> 'ext_TileColorName'::text), (vehicles_jsonb.vehicle -> 'trimLine1'::text), (vehicles_jsonb.vehicle -> 'trimLine2'::text), vehicles_jsonb.date, ((vehicles_jsonb.vehicle -> 'tileMoreFeatures'::text))::text
  WITH NO DATA;


ALTER TABLE carvana_vehicles OWNER TO acd;

--
-- Name: kmx_doc; Type: TABLE; Schema: carvana; Owner: acd
--

CREATE TABLE kmx_doc (
    doc jsonb,
    filename text,
    date date
);


ALTER TABLE kmx_doc OWNER TO acd;

--
-- Name: kmx_vehicles; Type: MATERIALIZED VIEW; Schema: carvana; Owner: acd
--

CREATE MATERIALIZED VIEW kmx_vehicles AS
 SELECT (vehicle_jsonb.v -> 'StockNumber'::text) AS stocknumber,
    vehicle_jsonb.date,
    (vehicle_jsonb.v -> 'Vin'::text) AS vin,
    (vehicle_jsonb.v -> 'Year'::text) AS year,
    (vehicle_jsonb.v -> 'Make'::text) AS make,
    (vehicle_jsonb.v -> 'Model'::text) AS model,
    (vehicle_jsonb.v -> 'Description'::text) AS descr,
    (vehicle_jsonb.v -> 'Price'::text) AS price,
    (vehicle_jsonb.v -> 'ExteriorColor'::text) AS color,
        CASE
            WHEN ((vehicle_jsonb.v -> 'Miles'::text) = '"New"'::jsonb) THEN (0)::numeric
            ELSE (btrim(((vehicle_jsonb.v -> 'Miles'::text))::text, '"K'::text))::numeric
        END AS miles,
    (vehicle_jsonb.v -> 'DriveTrain'::text) AS drivetrain,
    (vehicle_jsonb.v -> 'Transmission'::text) AS transmission,
    (vehicle_jsonb.v -> 'IsSold'::text) AS sold
   FROM ( SELECT kmx_doc.date,
            jsonb_array_elements((kmx_doc.doc -> 'Results'::text)) AS v
           FROM kmx_doc) vehicle_jsonb
  GROUP BY (vehicle_jsonb.v -> 'Vin'::text), (vehicle_jsonb.v -> 'Year'::text), (vehicle_jsonb.v -> 'Make'::text), (vehicle_jsonb.v -> 'Model'::text), (vehicle_jsonb.v -> 'Description'::text), (vehicle_jsonb.v -> 'Price'::text), (vehicle_jsonb.v -> 'ExteriorColor'::text), (vehicle_jsonb.v -> 'Miles'::text), (vehicle_jsonb.v -> 'DriveTrain'::text), (vehicle_jsonb.v -> 'Transmission'::text), (vehicle_jsonb.v -> 'IsSold'::text), (vehicle_jsonb.v -> 'StockNumber'::text), vehicle_jsonb.date
  WITH NO DATA;


ALTER TABLE kmx_vehicles OWNER TO acd;

--
-- Name: compare; Type: VIEW; Schema: carvana; Owner: acd
--

CREATE VIEW compare AS
 SELECT c.year,
    c.miles AS c_miles,
    c.price AS c_price,
    (((kmx.price)::text)::double precision - ((c.price)::text)::double precision) AS price_diff,
    kmx.price AS k_price,
    kmx.miles AS k_miles,
    c.vin AS c_vin,
    c.stockid AS c_stockid,
    kmx.vin AS k_vin,
    kmx.stocknumber AS k_stocknumber,
    kmx.transmission AS k_transmission,
    c.make,
    c.model,
    c."trim" AS c_trim,
    kmx.descr AS k_trim,
    kmx.drivetrain AS k_drivetrain
   FROM (carvana_vehicles c
     LEFT JOIN LATERAL ( SELECT k.miles,
            k.vin,
            k.stocknumber,
            k.transmission,
            k.drivetrain,
            k.price,
            k.make,
            k.model,
            k.descr
           FROM kmx_vehicles k
          WHERE ((k.model = c.model) AND (k.make = c.make) AND (c.year = k.year) AND (abs((k.miles - (((c.miles / (1000)::numeric))::integer)::numeric)) < (3)::numeric) AND ((k.descr)::text ~~* (('%'::text || btrim((c."trim")::text, '"'::text)) || '"'::text)) AND (((k.drivetrain)::text = '"2WD"'::text) OR (c.morefeatures ~~ (('%'::text || btrim((k.drivetrain)::text, '"'::text)) || '%'::text))))
          ORDER BY (abs((k.miles - (((c.miles / (1000)::numeric))::integer)::numeric)))
         LIMIT 1) kmx ON (true))
  WHERE (kmx.price IS NOT NULL);


ALTER TABLE compare OWNER TO acd;

--
-- Name: honda_compare; Type: VIEW; Schema: carvana; Owner: acd
--

CREATE VIEW honda_compare AS
 SELECT k.year,
    k.model,
    k.make,
    k.miles AS k_miles,
    ((c.miles / (1000)::numeric))::integer AS c_miles,
    (k.miles - (((c.miles / (1000)::numeric))::integer)::numeric) AS miles_diff,
    k.price AS k_price,
    c.price AS c_price,
    (((k.price)::text)::double precision - ((c.price)::text)::double precision) AS price_diff,
    k.descr AS k_trim,
    (k.drivetrain)::text AS k_drivetrain,
    c."trim" AS c_trim
   FROM kmx_vehicles k,
    carvana_vehicles c
  WHERE ((k.model = '"Civic"'::jsonb) AND (k.year = c.year) AND (k.model = c.model) AND (k.make = c.make) AND (k.make = '"Honda"'::jsonb) AND (abs((k.miles - (((c.miles / (1000)::numeric))::integer)::numeric)) < (3)::numeric) AND ((k.descr)::text ~~* (('%'::text || btrim((c."trim")::text, '"'::text)) || '"'::text)) AND (((k.drivetrain)::text = '"2WD"'::text) OR (c.morefeatures ~~ (('%'::text || btrim((k.drivetrain)::text, '"'::text)) || '%'::text))))
  ORDER BY k.make, k.model, k.year;


ALTER TABLE honda_compare OWNER TO acd;

--
-- Name: honda_compare_2; Type: VIEW; Schema: carvana; Owner: acd
--

CREATE VIEW honda_compare_2 AS
 SELECT c.year,
    c.miles AS c_miles,
    c.price AS c_price,
    (((kmx.price)::text)::double precision - ((c.price)::text)::double precision) AS price_diff,
    kmx.price AS k_price,
    kmx.miles AS k_miles,
    c.make,
    c.model,
    c."trim" AS c_trim,
    kmx.descr AS k_trim,
    kmx.drivetrain AS k_drivetrain
   FROM (carvana_vehicles c
     LEFT JOIN LATERAL ( SELECT k.miles,
            k.drivetrain,
            k.price,
            k.make,
            k.model,
            k.descr
           FROM kmx_vehicles k
          WHERE ((k.model = c.model) AND (k.make = c.make) AND (c.year = k.year) AND (abs((k.miles - (((c.miles / (1000)::numeric))::integer)::numeric)) < (3)::numeric) AND ((k.descr)::text ~~* (('%'::text || btrim((c."trim")::text, '"'::text)) || '"'::text)) AND (((k.drivetrain)::text = '"2WD"'::text) OR (c.morefeatures ~~ (('%'::text || btrim((k.drivetrain)::text, '"'::text)) || '%'::text))))
          ORDER BY (abs((k.miles - (((c.miles / (1000)::numeric))::integer)::numeric)))
         LIMIT 1) kmx ON (true));


ALTER TABLE honda_compare_2 OWNER TO acd;

--
-- Name: temp; Type: TABLE; Schema: carvana; Owner: acd
--

CREATE TABLE temp (
    year jsonb,
    c_miles numeric,
    c_price numeric,
    price_diff double precision,
    k_price jsonb,
    k_miles numeric,
    c_vin jsonb,
    c_stockid jsonb,
    k_vin jsonb,
    k_stocknumber jsonb,
    k_transmission jsonb,
    make jsonb,
    model jsonb,
    c_trim jsonb,
    k_trim jsonb,
    k_drivetrain jsonb
);


ALTER TABLE temp OWNER TO acd;

--
-- Name: kmx_idx; Type: INDEX; Schema: carvana; Owner: acd
--

CREATE INDEX kmx_idx ON kmx_vehicles USING btree (model, make);


--
-- PostgreSQL database dump complete
--

