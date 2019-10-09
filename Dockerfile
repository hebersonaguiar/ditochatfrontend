FROM centos:7

RUN yum -y update && \
    yum -y install gcc c++ make curl bind-utils

RUN  curl -sL https://rpm.nodesource.com/setup_10.x |  bash -

RUN yum -y install nodejs

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
   
RUN npm install react@16.8.1 react-chat-elements@10.2.0 react-dom@16.8.1 react-router-dom@4.3.1 typescript react-scripts@2.1.5
RUN npm audit fix
RUN npm audit fix --force

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 

COPY . ./

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000

CMD ["npm", "start"]
