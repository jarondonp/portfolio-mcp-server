FROM node:22-alpine AS builder
WORKDIR /app/brave-search  # Cambiar el directorio de trabajo
COPY servers/src/brave-search/package*.json ./
COPY servers/src/brave-search/tsconfig.json ./
COPY servers/src/brave-search/index.ts ./
# Copia otros archivos necesarios aquí individualmente o usa COPY servers/src/brave-search/. . con precaución
RUN npm install
RUN npm run build
FROM node:22-alpine AS release
WORKDIR /app
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package*.json /app/
ENV NODE_ENV=production
RUN npm ci --ignore-scripts --omit=dev
ENTRYPOINT ["node", "dist/index.js"]
