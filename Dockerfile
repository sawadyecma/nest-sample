# FROM node:16-alpine AS builder
FROM node:16-stretch AS builder
WORKDIR "/app"
COPY . .
RUN npm ci
RUN npm run build
RUN npm prune --production

FROM node:16-stretch AS production
WORKDIR "/app"
COPY --from=builder /app/set-up.sh ./set-up.sh
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json ./package-lock.json
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["npm", "run", "start:prod"]