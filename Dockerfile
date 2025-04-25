FROM node:22-alpine AS builder
WORKDIR /app/brave-search
COPY servers/src/brave-search/package*.json ./
COPY servers/src/brave-search/tsconfig.json ./
COPY servers/src/brave-search/index.ts ./
# Si tienes otros archivos necesarios en la misma carpeta, puedes copiarlos así:
COPY servers/src/brave-search/*.js ./
COPY servers/src/brave-search/*.json ./
COPY servers/src/brave-search/*.ts ./
# O, para copiar todo el contenido de la carpeta:
# COPY servers/src/brave-search/. .
RUN npm install
RUN npm run build

FROM node:22-alpine AS release
WORKDIR /app
COPY --from=builder /app/brave-search/dist /app/dist
COPY --from=builder /app/brave-search/package*.json /app/
ENV NODE_ENV=production
RUN npm ci --ignore-scripts --omit=dev
ENTRYPOINT ["node", "dist/index.js"]
