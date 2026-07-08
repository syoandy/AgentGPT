#!/bin/bash
cd "$(dirname "$0")"

sed -ie 's/mysql/sqlite/g' schema.prisma
sed -ie 's/postgres/sqlite/g' schema.prisma
sed -ie 's/@db.Text//' schema.prisma
# MySQL-only features (used by the in-house memory FULLTEXT index) are not
# supported on the SQLite dev/CI datasource, so strip them for that path only.
sed -ie 's/, "fullTextIndex"//' schema.prisma
sed -ie '/@@fulltext/d' schema.prisma
# Prisma's SQLite connector does not support the Json scalar type; use String
# for the SQLite dev/CI path only (MySQL production keeps real Json).
sed -ie 's/Json?/String?/' schema.prisma
