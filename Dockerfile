FROM node:22-alpine AS dependencies
WORKDIR /src
COPY package*.json ./
RUN npm ci --omit=dev

FROM node:22-alpine AS builder
WORKDIR /src
COPY --from=dependencies /src/node_modules ./node_modules
COPY . .

FROM node:22-alpine AS production
RUN addgroup -S node-order && adduser -S node-order -G node-order
WORKDIR /src
COPY --from=builder /src ./
RUN chown -R node-order:node-order /src
USER appuser
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "index.js"]