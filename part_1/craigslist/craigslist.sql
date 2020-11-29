CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "username" varchar(16),
  "password" varchar(32),
  "preferred_region" int
);

CREATE TABLE "posts" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int,
  "region_id" int,
  "category_id" int,
  "location" varchar,
  "title" varchar,
  "text" varchar
);

CREATE TABLE "regions" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "categories" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar
);

ALTER TABLE "users" ADD FOREIGN KEY ("id") REFERENCES "posts" ("user_id");

ALTER TABLE "regions" ADD FOREIGN KEY ("id") REFERENCES "posts" ("region_id");

ALTER TABLE "categories" ADD FOREIGN KEY ("id") REFERENCES "posts" ("category_id");

ALTER TABLE "regions" ADD FOREIGN KEY ("id") REFERENCES "users" ("preferred_region");
