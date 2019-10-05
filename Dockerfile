# base image
FROM node:10.16.3

ENV REACT_APP_BACKEND_WS='ws://172.16.0.4:8080'
ENV REACT_APP_BACKEND_URL='http://172.16.0.4:8080'

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install --silent && \
    npm audit fix && \
    npm audit fix --force && \
    npm install

COPY . ./

RUN npm run build

EXPOSE 3000

# start app
CMD ["npm", "start"]
