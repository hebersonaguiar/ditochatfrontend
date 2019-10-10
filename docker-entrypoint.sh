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

    
      sed -i "s/IPADDRESS/$REACT_APP_BACKEND_WS_URL/g" /app/src/Chat.js
      
else
	echo "Please enter the required variables!"
	help

fi

exec "$@"      
