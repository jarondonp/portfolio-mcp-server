FROM node:22-alpine AS builder
WORKDIR /app
RUN mkdir -p /app/src/brave-search # Crear la carpeta src/brave-search

COPY servers/src/brave-search /app/src/brave-search # Copiar la carpeta brave-search dentro de /app/src

WORKDIR /app/src/brave-search # Cambiar el directorio de trabajo

RUN npm install
RUN npm run build

FROM node:22-alpine AS release
WORKDIR /app
COPY --from=builder /app/src/brave-search/dist /app/dist
COPY --from=builder /app/src/brave-search/package*.json /app/
ENV NODE_ENV=production
RUN npm ci --ignore-scripts --omit=dev
ENTRYPOINT ["node", "dist/index.js"]
