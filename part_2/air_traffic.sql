-- from the terminal run:
-- psql < air_traffic.sql

DROP DATABASE IF EXISTS air_traffic;

CREATE DATABASE air_traffic;

\c air_traffic

CREATE TABLE airline
(
  code VARCHAR(2) PRIMARY KEY,
  airline_name VARCHAR(100)
);

INSERT INTO airline 
  (code, airline_name)
VALUES
  ('01', 'Delta'),
  ('02', 'United Airlines'),
  ('03', 'British Airways'),
  ('04', 'Air China'),
  ('05', 'Air France');

CREATE TABLE flight
(
  flight_n INT NOT NULL,
  flight_begin VARCHAR(100),
  flight_end VARCHAR(100),
  code VARCHAR(2),
  FOREIGN KEY (code) REFERENCES airline (code),
  PRIMARY KEY (code, flight_n)
);

INSERT INTO flight
  (flight_n, flight_begin, flight_end, code)
VALUES
  (123, 'Los Angeles', 'Atlanta', '01'),
  (453, 'Atlanta', 'Beijing', '02'),
  (398, 'Madrid', 'Budapest', '03'),
  (113, 'Utrecht', 'Hong Kong', '04'),
  (349, 'Aalborg', 'Toulouse', '05');

CREATE TABLE incoming
(
  code VARCHAR(2),
  incoming_n INT,
  arrive_time DATE,
  FOREIGN KEY (code, incoming_n) REFERENCES flight(code, flight_n),
  PRIMARY KEY (code, incoming_n)
);

INSERT INTO incoming
  (code, incoming_n, arrive_time)
VALUES
  ('01', '123', To_date('01:00:00', 'HH24:MI:SS')),
  ('02', '453', To_date('03:00:00', 'HH24:MI:SS'));

CREATE TABLE outgoing
(
  code VARCHAR(2),
  outgoing_n INT,
  depart_time DATE,
  FOREIGN KEY (code, outgoing_n) REFERENCES flight(code, flight_n),
  PRIMARY KEY (code, outgoing_n)
);

INSERT INTO outgoing
  (code, outgoing_n, depart_time)
VALUES
  ('03', '398', To_date('06:00:00', 'HH24:MI:SS')),
  ('04', '113', To_date('09:00:00', 'HH24:MI:SS')),
  ('05', '349', To_date('12:00:00', 'HH24:MI:SS'));

CREATE TABLE passengers
(
  p_id INT NOT NULL,
  p_first_name VARCHAR(100),
  p_last_name VARCHAR(100),
  birthday VARCHAR(100),
  PRIMARY KEY (p_id)
);

INSERT INTO passengers
  (p_id, p_first_name, p_last_name, birthday)
VALUES
  ('001', 'Jennifer', 'Finch', To_date('1996-09-01', 'YYYY-MM-DD')),
  ('002', 'Sonja', 'Pauley', To_date('1967-12-07', 'YYYY-MM-DD')),
  ('003', 'Waneta', 'Skeleton', To_date('2001-02-04', 'YYYY-MM-DD')),
  ('004', 'Berkie', 'Wycliff', To_date('1936-05-29', 'YYYY-MM-DD')),
  ('005', 'Cory', 'Squibbes', To_date('1985-06-11', 'YYYY-MM-DD'));

CREATE TABLE arrival
(
  gate VARCHAR(100),
  arrival_date DATE,
  code VARCHAR(2),
  incoming_n INT,
  FOREIGN KEY (code, incoming_n) REFERENCES incoming (code, incoming_n),
  PRIMARY KEY (code, incoming_n, arrival_date)
);

INSERT INTO arrival
  (gate, arrival_date, code, incoming_n)
VALUES
  (1, To_date('01/01/2020', 'dd/mm/yy'), '01', '123'),
  (2, To_date('02/12/2020', 'dd/mm/yy'), '02', '453');

CREATE TABLE departure
(
  gate VARCHAR(100),
  departure_date DATE,
  code VARCHAR(2),
  outgoing_n INT,
  FOREIGN KEY (code, outgoing_n) REFERENCES outgoing (code, outgoing_n),
  PRIMARY KEY (code, outgoing_n, departure_date)
);

INSERT INTO departure
  (gate, departure_date, code, outgoing_n)
VALUES
  (03, To_date('03/05/2020', 'mm/dd/yy'), '03', '398'),
  (04, To_date('04/20/2020', 'mm/dd/yy'), '04', '113'),
  (05, To_date('05/26/2020', 'mm/dd/yy'), '05', '349');

CREATE TABLE p_arrival
(
  code VARCHAR(2),
  incoming_n INT,
  arrival_date DATE,
  p_id INT,
  FOREIGN KEY (code, incoming_n, arrival_date) REFERENCES arrival (code, incoming_n, arrival_date),
  FOREIGN KEY (p_id) REFERENCES passengers (p_id)
);

INSERT INTO p_arrival
(code, incoming_n, arrival_date, p_id)
VALUES
('01', '123', To_date('01/01/2020', 'dd/mm/yy'), '01'),
('02', '453', To_date('02/12/2020', 'dd/mm/yy'), '02');

CREATE TABLE p_departure
(
  code VARCHAR(2),
  outgoing_n INT,
  departure_date DATE,
  p_id INT,
  FOREIGN KEY (code, outgoing_n, departure_date) REFERENCES departure (code, outgoing_n, departure_date),
  FOREIGN KEY (p_id) REFERENCES passengers (p_id)
);

INSERT INTO p_departure
  (code, outgoing_n, departure_date, p_id)
VALUES
  ('03', '398', To_date('03/05/2020', 'mm/dd/yy'), '03'),
  ('04', '113', To_date('04/20/2020', 'mm/dd/yy'), '04'),
  ('05', '349', To_date('05/26/2020', 'mm/dd/yy'), '05');


CREATE VIEW income AS SELECT code, incoming_n, arrival_date FROM arrival NATURAL JOIN incoming;

CREATE VIEW outgo AS SELECT code, outgoing_n, departure_date FROM departure NATURAL JOIN outgoing;

CREATE VIEW odp AS SELECT p_id, outgoing.depart_time, departure.departure_date FROM outgoing, departure natural JOIN p_departure;

-- INSERT INTO tickets
--   (first_name, last_name, seat, departure, arrival, airline, from_city, from_country, to_city, to_country)
-- VALUES
--   ('Jennifer', 'Finch', '33B', '2018-04-08 09:00:00', '2018-04-08 12:00:00', 'United', 'Washington DC', 'United States', 'Seattle', 'United States'),
--   ('Thadeus', 'Gathercoal', '8A', '2018-12-19 12:45:00', '2018-12-19 16:15:00', 'British Airways', 'Tokyo', 'Japan', 'London', 'United Kingdom'),
--   ('Sonja', 'Pauley', '12F', '2018-01-02 07:00:00', '2018-01-02 08:03:00', 'Delta', 'Los Angeles', 'United States', 'Las Vegas', 'United States'),
--   ('Jennifer', 'Finch', '20A', '2018-04-15 16:50:00', '2018-04-15 21:00:00', 'Delta', 'Seattle', 'United States', 'Mexico City', 'Mexico'),
--   ('Waneta', 'Skeleton', '23D', '2018-08-01 18:30:00', '2018-08-01 21:50:00', 'TUI Fly Belgium', 'Paris', 'France', 'Casablanca', 'Morocco'),
--   ('Thadeus', 'Gathercoal', '18C', '2018-10-31 01:15:00', '2018-10-31 12:55:00', 'Air China', 'Dubai', 'UAE', 'Beijing', 'China'),
--   ('Berkie', 'Wycliff', '9E', '2019-02-06 06:00:00', '2019-02-06 07:47:00', 'United', 'New York', 'United States', 'Charlotte', 'United States'),
--   ('Alvin', 'Leathes', '1A', '2018-12-22 14:42:00', '2018-12-22 15:56:00', 'American Airlines', 'Cedar Rapids', 'United States', 'Chicago', 'United States'),
--   ('Berkie', 'Wycliff', '32B', '2019-02-06 16:28:00', '2019-02-06 19:18:00', 'American Airlines', 'Charlotte', 'United States', 'New Orleans', 'United States'),
--   ('Cory', 'Squibbes', '10D', '2019-01-20 19:30:00', '2019-01-20 22:45:00', 'Avianca Brasil', 'Sao Paolo', 'Brazil', 'Santiago', 'Chile');