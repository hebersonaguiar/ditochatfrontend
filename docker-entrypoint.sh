#!/bin/bash

set -e

help() {
    echo "Usage: docker run -dti -e REACT_APP_BACKEND_WS_URL=<value1> image:tag" >&2
    echo
    echo "   REACT_APP_BACKEND_WS_URL        Url for webservice chat ex: backend.example.com"
    echo
    exit 1
}

if [ ! -z "$REACT_APP_BACKEND_WS_URL" ] ; then

      REACT_APP_BACKEND_WS=$(dig +short $REACT_APP_BACKEND_WS_URL)
      REACT_APP_BACKEND_URL=$(dig +short $REACT_APP_BACKEND_WS_URL)

      echo "export REACT_APP_BACKEND_WS='ws://$REACT_APP_BACKEND_WS:8080'" >> ~/.bash_profile
      echo "export REACT_APP_BACKEND_URL='https://$REACT_APP_BACKEND_URL:8080'" >> ~/.bash_profile
      export -p
      source ~/.bash_profile 

      #cd /app
      #/usr/bin/npm install react@16.8.1 react-chat-elements@10.2.0 react-dom@16.8.1 react-router-dom@4.3.1 typescript react-scripts@2.1.5 
      #/usr/bin/npm audit fix
      #/usr/bin/npm audit fix --force
      #/usr/bin/npm start 

else
	echo "Please enter the required variables!"
	help

fi

exec "$@"      
