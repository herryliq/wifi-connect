FROM resin/armv7hf-node:0.12.2

RUN apt-get update && apt-get install -y \
	bind9 \
	bridge-utils \
	connman \
	iptables \
	libdbus-1-dev \
	libexpat-dev \
	net-tools \
	usbutils \
	wireless-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY ./assets/bind /etc/bind

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

COPY package.json ./
RUN JOBS=MAX npm install --unsafe-perm --production && npm cache clean

COPY bower.json .bowerrc ./
RUN ./node_modules/.bin/bower install

COPY . ./
RUN ./node_modules/.bin/coffee -c ./src
RUN chmod +x ./start

VOLUME /var/lib/connman

CMD ./start
