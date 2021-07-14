FROM postgres:12-alpine

COPY ./db /docker-entrypoint-initdb.d/

CMD ["postgres"]
