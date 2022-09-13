FROM node:16 as builder

WORKDIR /app

COPY package*.json .

RUN npm i

COPY /src /app/src
COPY tsconfig*.json .

RUN npm run build

FROM node:16-alpine3.15 as run

WORKDIR /app

ARG ARG_PORT
ENV PORT=$ARG_PORT

ARG ARG_ENABLE_METRICS
ENV ENABLE_METRICS=$ARG_ENABLE_METRICS

ARG ARG_PROM_TOKEN
ENV PROM_TOKEN=$ARG_PROM_TOKEN

COPY package*.json .
RUN npm i --production

COPY --from=builder /app/dist /app/dist

CMD [ "npm", "run", "prod" ]