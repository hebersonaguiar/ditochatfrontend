FROM centos:7

RUN yum -y update && \
	yum -y install gcc-c++ make curl

RUN  curl -sL https://rpm.nodesource.com/setup_10.x |  bash -

RUN yum -y install nodejs && \
    node -v && \
    npm -v 

ENV REACT_APP_BACKEND_WS='ws://172.16.0.4:8080'
ENV REACT_APP_BACKEND_URL='http://172.16.0.4:8080'

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN npm install --silent && \
    npm audit fix && \
    npm audit fix --force && \
    npm install

COPY . ./

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
