# Usar la imagen oficial de Ruby como base
FROM ruby:3.1.2

# Instalar las dependencias necesarias para Rails y PostgreSQL
RUN apt-get update -qq && apt-get install -y  curl postgresql-client

# Crear un directorio para el código de la aplicación
COPY . /app
WORKDIR /app

#Instalar node
RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash - && apt-get install -y nodejs

#Instalar yarn
RUN corepack enable
RUN corepack prepare yarn@1.22.19 --activate

# Instalar las gemas especificadas en el Gemfile
RUN yarn install
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Exponer el puerto 3000 para que sea accesible desde fuera del contenedor
#EXPOSE 3000
