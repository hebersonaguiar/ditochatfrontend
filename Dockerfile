# base image
FROM node:12.2.0-alpine

ENV	REACT_APP_BACKEND_WS='ws://backend:8080'
ENV REACT_APP_BACKEND_URL='http://backend:8080'

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install --silent
#RUN npm install react-scripts@2.1.5 -g --silent

COPY . ./

EXPOSE 3000

# start app
CMD ["npm", "start"]