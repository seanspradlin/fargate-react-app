FROM node:lts-alpine
RUN apk add dumb-init
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm ci --only=production
RUN npm run build
EXPOSE 8080
CMD [ "dumb-init", "/usr/src/app/node_modules/.bin/next", "start" ]

