FROM ubuntu:14.04
MAINTAINER Rodrigo Fernandes <rtfrodrigo at gmail dot com>

RUN \
  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install lib32gcc1 lib32z1 lib32ncurses5 lib32bz2-1.0 curl && \
  apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER tf2

RUN useradd $USER
ENV HOME /home/$USER
RUN mkdir $HOME
RUN chown $USER:$USER $HOME

USER $USER
ENV SERVER $HOME/hlserver
RUN mkdir $SERVER
RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz
ADD ./tf2_ds.txt $SERVER/tf2_ds.txt
ADD ./update.sh $SERVER/update.sh
ADD ./tf.sh $SERVER/tf.sh
RUN $SERVER/update.sh

EXPOSE 27015/udp

WORKDIR /home/$USER/hlserver
ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "1", "+mapcycle", "mapcycle_quickplay_payload.txt", "+map", "pl_badwater", "+maxplayers", "24"]
