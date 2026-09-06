# ------------------------------------------------------------
# Build stage
# ------------------------------------------------------------

FROM node:22-alpine AS build

WORKDIR /app

# Copier d'abord les fichiers de dépendances pour profiter du cache Docker
COPY package.json package-lock.json ./

# Installation reproductible
RUN npm ci

# Copier le reste du projet
COPY . .

# Build
RUN npm run build


# ------------------------------------------------------------
# Runtime stage
# ------------------------------------------------------------

FROM nginx:alpine

# Supprimer le contenu nginx par défaut
RUN rm -rf /usr/share/nginx/html/*

# Copier uniquement le résultat du build
COPY --from=build /app/dist/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]