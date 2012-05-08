CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "type" integer, "active" boolean, "encrypted_password" varchar(255), "salt" varchar(255), "created_at" datetime, "updated_at" datetime, "admin" boolean DEFAULT 'f', "first_name" varchar(255), "last_name" varchar(255), "username" varchar(255));
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120411174507');

INSERT INTO schema_migrations (version) VALUES ('20110903183530');

INSERT INTO schema_migrations (version) VALUES ('20110905041434');

INSERT INTO schema_migrations (version) VALUES ('20120402212543');