FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    git \
    unzip \
    zip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    openssh-server \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Set working directory
WORKDIR /var/www/html

# Copy Laravel files
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy NGINX config
COPY default.conf /etc/nginx/conf.d/default.conf

# Configure SSH
RUN echo 'root:P@ssw0rd1' | chpasswd && ssh-keygen -A

# Expose ports
EXPOSE 8080 22

# Start services
CMD service ssh start && service nginx start && php-fpm
