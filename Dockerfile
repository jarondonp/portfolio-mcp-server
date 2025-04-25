FROM node:22-alpine AS builder
WORKDIR /app

COPY servers/src/brave-search/package*.json ./
COPY servers/src/brave-search/package-lock.json ./
COPY servers/src/brave-search/tsconfig.json ./
COPY servers/src/brave-search/index.ts ./
COPY servers ./servers

WORKDIR /app/servers/src/brave-search

RUN npm install
RUN npm run build

FROM node:22-alpine AS release
WORKDIR /app
COPY --from=builder /app/servers/src/brave-search/dist /app/dist
COPY package*.json ./
ENV NODE_ENV=production
RUN npm ci --ignore-scripts --omit=dev
ENTRYPOINT ["node", "dist/index.js"]
