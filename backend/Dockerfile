FROM docker.io/library/postgres:latest

# Set environment variables
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=mydb

# Expose PostgreSQL default port
EXPOSE 5432

# Volume for persisting data
VOLUME ["/var/lib/postgresql/data"]

# Default command
CMD ["postgres"]