#!/bin/bash

set -e

help() {
    echo "Usage: docker run -dti -e REACT_APP_BACKEND_WS=<value1> -e REACT_APP_BACKEND_URL=<value2> image:tag" >&2
    echo
    echo "   REACT_APP_BACKEND_WS        Url for webservice chat ex: ws://0.0.0.0:8080"
    echo "   REACT_APP_BACKEND_URL       Url for access backend ex: http://0.0.0.0:8080"

    echo
    exit 1
}

if [ ! -z "$ALLOWED_ORIGIN" ] || [ ! -z "$REDIS_ADDR" ] ; then

      echo "export REACT_APP_BACKEND_WS='$REACT_APP_BACKEND_WS'" >> ~/.bash_profile
      echo "export REACT_APP_BACKEND_URL='$REACT_APP_BACKEND_URL'" >> ~/.bash_profile
      export -p
      source ~/.bash_profile 

      cd /app
      /usr/bin/npm install react@16.8.1 react-chat-elements@10.2.0 react-dom@16.8.1 react-router-dom@4.3.1 typescript react-scripts@2.1.5 
      /usr/bin/npm audit fix
      /usr/bin/npm audit fix --force
      /usr/bin/npm start 

else
	echo "Please enter the required variables!"
	help

fi

exec "$@"      
