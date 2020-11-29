CREATE TABLE "teams" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar,
  "city" varchar
);

CREATE TABLE "referees" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "players" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar,
  "birthday" varchar,
  "height" varchar,
  "weight" int,
  "team_id" int
);

CREATE TABLE "matches" (
  "id" SERIAL PRIMARY KEY,
  "home_id" int,
  "away_id" int,
  "field_id" int,
  "date" varchar(10),
  "start_time" varchar(4),
  "season_id" int,
  "referee_id" int
);

CREATE TABLE "goals" (
  "id" SERIAL PRIMARY KEY,
  "player_id" int,
  "match_id" int
);

CREATE TABLE "season" (
  "id" SERIAL PRIMARY KEY,
  "start_date" varchar(10),
  "end_date" varchar(10)
);

CREATE TABLE "matchups" (
  "id" SERIAL PRIMARY KEY,
  "player_id" int,
  "match_id" int,
  "team_id" int
);

CREATE TABLE "results" (
  "id" SERIAL PRIMARY KEY,
  "team_id" int,
  "match_id" int,
  "outcome" varchar
);

ALTER TABLE "teams" ADD FOREIGN KEY ("id") REFERENCES "players" ("team_id");

ALTER TABLE "referees" ADD FOREIGN KEY ("id") REFERENCES "matches" ("referee_id");

ALTER TABLE "teams" ADD FOREIGN KEY ("id") REFERENCES "matches" ("home_id");

ALTER TABLE "teams" ADD FOREIGN KEY ("id") REFERENCES "matches" ("away_id");

ALTER TABLE "players" ADD FOREIGN KEY ("id") REFERENCES "goals" ("player_id");

ALTER TABLE "matches" ADD FOREIGN KEY ("id") REFERENCES "goals" ("match_id");

ALTER TABLE "players" ADD FOREIGN KEY ("id") REFERENCES "matchups" ("player_id");

ALTER TABLE "matches" ADD FOREIGN KEY ("id") REFERENCES "matchups" ("match_id");

ALTER TABLE "teams" ADD FOREIGN KEY ("id") REFERENCES "matchups" ("team_id");

ALTER TABLE "season" ADD FOREIGN KEY ("id") REFERENCES "matches" ("season_id");

ALTER TABLE "teams" ADD FOREIGN KEY ("id") REFERENCES "results" ("team_id");

ALTER TABLE "matches" ADD FOREIGN KEY ("id") REFERENCES "results" ("match_id");
