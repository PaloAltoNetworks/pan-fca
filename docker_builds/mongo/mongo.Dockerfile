FROM mongo:latest
COPY db_init.js /docker-entrypoint-initdb.d/