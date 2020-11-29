CREATE TABLE "doctors" (
  "id" SERIAL PRIMARY KEY,
  "doctor_name" varchar,
  "department" varchar
);

CREATE TABLE "patients" (
  "id" SERIAL PRIMARY KEY,
  "insurance_id" int,
  "patient_name" varchar,
  "birthday" varchar
);

CREATE TABLE "appointments" (
  "id" SERIAL PRIMARY KEY,
  "doctor_id" int,
  "patient_id" int,
  "date" varchar
);

CREATE TABLE "diagnoses" (
  "id" int PRIMARY KEY,
  "appointment_id" int,
  "disease_id" int
);

CREATE TABLE "diseases" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "department" varchar
);

ALTER TABLE "appointments" ADD FOREIGN KEY ("doctor_id") REFERENCES "doctors" ("id");

ALTER TABLE "diseases" ADD FOREIGN KEY ("id") REFERENCES "diagnoses" ("disease_id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("id");

ALTER TABLE "diagnoses" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("id");

ALTER TABLE "diseases" ADD FOREIGN KEY ("department") REFERENCES "doctors" ("department");
