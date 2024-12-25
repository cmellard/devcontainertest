#!/bin/bash
set -e

echo "Running post-create setup..."

# Configure Redis

mkdir -p /workspaces/redis-data
chown redis:redis /workspaces/redis-data
chmod 770 /workspaces/redis-data

# Configure Postgres

# Set runtime variables
DATA_DIR="/workspaces/postgres-data"

# Create the data directory if it doesn't exist
if [ ! -d "$DATA_DIR" ]; then
    echo "Data directory not found. Creating $DATA_DIR..."
    mkdir -p "$DATA_DIR"
    chown postgres:postgres "$DATA_DIR"
    chmod 700 "$DATA_DIR"
fi

# Initialize the database if needed
if [ ! -f "$DATA_DIR/PG_VERSION" ]; then
    echo "Initializing PostgreSQL data directory at $DATA_DIR"
    sudo -u postgres /usr/lib/postgresql/14/bin/initdb -D "$DATA_DIR" --encoding=UTF8
fi

# Start PostgreSQL in the foreground
echo "Starting PostgreSQL without systemd..."
sudo -u postgres /usr/lib/postgresql/14/bin/postgres -D "$DATA_DIR" > /dev/null 2>&1 &
POSTGRES_PID=$!

# Wait for PostgreSQL to become ready
echo "Waiting for PostgreSQL to become ready..."
RETRIES=600
for i in $(seq 1 $RETRIES); do
    if sudo -u postgres psql -c '\q' > /dev/null 2>&1; then
        echo "PostgreSQL is ready."
        break
    fi
    echo "PostgreSQL not ready yet. Retrying in 2 seconds... ($i/$RETRIES)"
    sleep 2
done

# Ensure root is a superuser in PostgreSQL
sudo -u postgres psql -c "DO \$\$ BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'root') THEN
        CREATE ROLE root WITH SUPERUSER LOGIN;
    END IF;
END
\$\$;"

# Stop PostgreSQL gracefully
echo "Stopping PostgreSQL..."
sudo -u postgres /usr/lib/postgresql/14/bin/pg_ctl -D "$DATA_DIR" stop

/root/.rvm/rubies/ruby-3.3.6/bin/bundle config set --global path /workspaces/gems

echo "Post-create setup completed successfully."
