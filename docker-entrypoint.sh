#!/bin/bash

cd /app
/usr/bin/npm install react@16.8.1 react-chat-elements@10.2.0 react-dom@16.8.1 react-router-dom@4.3.1 typescript react-scripts@2.1.5 
/usr/bin/npm audit fix
/usr/bin/npm audit fix --force
/usr/bin/npm start 
