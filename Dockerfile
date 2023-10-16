FROM ubuntu:latest
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget -y && apt-get install npm -y && apt-get install unzip -y && apt-get install vim -y && apt-get install python2 -y && apt-get install openjdk-8-jdk -y && update-java-alternatives --set java-1.8.0-openjdk-arm64 && cd /tmp && wget https://cdn.sencha.com/cmd/6.0.2.14/no-jre/SenchaCmd-6.0.2.14-linux-amd64.sh.zip && unzip /tmp/SenchaCmd-6.0.2.14-linux-amd64.sh && cd /tmp && ./SenchaCmd-6.0.2.14-linux-amd64.sh -q && apt install android-sdk -y && npm install -g cordova@5.4 && npm install -g n && n 11.15.0 && hash -r && touch /tmp/google-chrome && chmod 755 /tmp/google-chrome && apt install sdkmanager -y && sdkmanager --install "build-tools;34.0.0-rc4" && sdkmanager --install "platforms;android-33"
# SDK manager setup is not needed unless building android plugin
# yes | sdkmanager --licenses
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV PATH=$PATH:/root/bin/Sencha/Cmd/6.0.2.14:/tmp
COPY . /app

# Cordova Platform RM Browser and upgrading of nodejs/cordova to the latest version has to be done after the initial setup as setupForDocker.sh requires cordova 5.4 and node 11.15 to be successful. See setupForDocker.sh on details
RUN chmod 755 /app/setupForDocker.sh && chmod 755 /app/run.sh && cd /app && ./setupForDocker.sh && n stable && npm install -g cordova && cd /app/cordova && cordova platform rm browser && cd /app && sencha app build native
EXPOSE 80
EXPOSE 8000
