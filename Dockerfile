FROM ubuntu:18.04

MAINTAINER Unoparty Developers <dev@unobtanium.uno>

# Install extra dependencies
RUN apt-get update && apt-get -y install python python-pip

# Download and install armory
ENV ARMORY_VER="0.96.5_ubuntu-64bit"
RUN apt-get update && apt-get -y install xvfb python-qt4 python-twisted python-psutil xdg-utils hicolor-icon-theme
RUN wget -O /tmp/armory.deb https://transfer.sh/52eqRj/armory_${ARMORY_VER}.deb
RUN mkdir -p /usr/share/desktop-directories/
RUN dpkg -i /tmp/armory.deb && rm /tmp/armory.deb
RUN mkdir /root/.armory

# Bitcoin datadir must be mounted in the container as /root/unobtanium_data`
RUN mkdir /unobtanium_data
    
# Install
COPY . /armory-utxsvr
WORKDIR /armory-utxsvr
RUN pip2 install -r requirements.txt
RUN python3 setup.py develop

COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod a+x /usr/local/bin/start.sh

EXPOSE 6490 6491

# NOTE: Defaults to running on mainnet, specify -e TESTNET=1 to start up on testnet
ENTRYPOINT ["start.sh"]
