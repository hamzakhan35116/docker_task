# Use an official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    nginx \
    php8.1-fpm \
    php8.1-cli \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-zip \
    php8.1-curl \
    postgresql-client \
    composer \
    nodejs \
    npm \
    python3 \
    python3-pip

# Configure PHP-FPM
RUN sed -i 's/;clear_env = no/clear_env = no/' /etc/php/8.1/fpm/pool.d/www.conf

# Create Laravel project directory
RUN composer create-project --prefer-dist laravel/laravel /var/www/laravel

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install application dependencies
RUN npm install

RUN pip install flask mysql.connector  mysql-connector-python 

# Copy all source code to the working directory
COPY . .

# Copy index.php file to Laravel public directory
COPY index.php /var/www/laravel/public

# Copy Nginx configuration
COPY default.conf /etc/nginx/sites-enabled/default

# Set PostgreSQL environment variables for Laravel
ENV PG_HOST postgres-container
ENV PG_DATABASE mydatabase
ENV PG_USER myuser
ENV PG_PASSWORD mypassword

ENV MYSQL_HOST=mysql_container
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=password
ENV MYSQL_DB=mydatabase


# Expose port 8080 for Laravel
EXPOSE 8080

# Set the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Run the entrypoint script
ENTRYPOINT  ["/app/entrypoint.sh"]

