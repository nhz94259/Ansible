FROM jenkinsci/blueocean:latest
USER root
RUN mkdir -p /opt/nodejs/{global,cache,npm-packages-offline-cache} && apk add nodejs && apk add npm && npm install yarn -g && yarn config set global-folder  /opt/nodejs/global && yarn config set cache-folder /opt/nodejs/cache && y
arn config set yarn-offline-mirror /opt/nodejs/npm-packages-offline-cache && yarn config set yarn-offline-mirror-pruning true 
