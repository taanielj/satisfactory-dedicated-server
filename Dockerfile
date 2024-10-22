FROM ubuntu:24.04

# Create steam user
RUN useradd -m steam

# Install dependencies as root
RUN apt-get update -y && \
    dpkg --add-architecture i386 && \
    apt-get install -y software-properties-common && \
    add-apt-repository multiverse && \
    apt-get update -y

# Pre-answer Steam license questions and install steamcmd
RUN echo steam steam/license note '' | debconf-set-selections && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    apt-get install -y steamcmd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to steam user to prepare steamcmd directory
USER steam
WORKDIR /home/steam

# Download and install steamcmd as steam user
RUN mkdir -p /home/steam/Steam && \
    /usr/games/steamcmd +quit

# Install Satisfactory Dedicated Server
WORKDIR /home/steam/.steam/steam/steamcmd
RUN ./steamcmd.sh +force_install_dir ~/SatisfactoryDedicatedServer +login anonymous +app_update 1690800 -beta public validate +quit

# Start the server
ENTRYPOINT ["/home/steam/SatisfactoryDedicatedServer/FactoryServer.sh"]
# build
# docker build -t satisfactory .
# start 
# docker run -d --name satisfactory -p 7777:7777/udp satisfactory
# enter with bash
# docker exec -it satisfactory bash
# take down
# docker stop satisfactory

