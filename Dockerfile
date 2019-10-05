FROM centos:7

RUN yum -y update && \
    yum -y install gcc-c++ make curl

RUN  curl -sL https://rpm.nodesource.com/setup_10.x |  bash -

RUN yum -y install nodejs

ENV REACT_APP_BACKEND_WS='ws://172.26.0.3:8080'
ENV REACT_APP_BACKEND_URL='http://172.26.0.3:8080'

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN npm install react@16.8.1 react-chat-elements@10.2.0 react-dom@16.8.1 react-router-dom@4.3.1 typescript react-scripts@2.1.5 && \
    npm audit fix && \
    npm audit fix --force
    
COPY . ./

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
