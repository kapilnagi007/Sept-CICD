FROM node:23-alpine

WORKDIR jenkins-react-ci/app

COPY jenkins-react-ci/package*.json ./

RUN npm ci

COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "host", "0.0.0.0"]