FROM mysql:5.7.29

COPY create_db_users.sh .

ENTRYPOINT [ "./create_db_users.sh" ]

CMD [ "mysqld" ]
