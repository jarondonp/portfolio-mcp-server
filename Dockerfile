FROM node:22-alpine AS builder
WORKDIR /app
COPY . /app  # Copiar TODO el repositorio al contenedor
WORKDIR /app/servers/src/brave-search # Cambiar el directorio de trabajo específico

RUN npm install
RUN npm run build

FROM node:22-alpine AS release
WORKDIR /app
COPY --from=builder /app/servers/src/brave-search/dist /app/dist
COPY --from=builder /app/servers/src/brave-search/package*.json /app/
ENV NODE_ENV=production
RUN npm ci --ignore-scripts --omit=dev
ENTRYPOINT ["node", "dist/index.js"]
