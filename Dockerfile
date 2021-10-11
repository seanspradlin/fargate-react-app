FROM node:lts-alpine
RUN apk add dumb-init
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY --chown=node:node . /usr/src/app
RUN npm ci --only=production
EXPOSE 8080
USER node
CMD [ "dumb-init", "node", "index.js" ]

