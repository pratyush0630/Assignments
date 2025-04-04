FROM node:18.16.0

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY src/ .

EXPOSE 3000

CMD [ "npm", "run", "dev"]