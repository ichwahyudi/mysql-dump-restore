FROM alpine:3.11.5
LABEL maintainer="ichsanlab@gmail.com"

WORKDIR /app
ADD sql-dump-import.sh .env ./
RUN chmod +x sql-dump-import.sh
RUN apk update && apk add --no-cache mysql-client gzip bash
ENTRYPOINT [ "bash", "/app/sql-dump-import.sh" ]