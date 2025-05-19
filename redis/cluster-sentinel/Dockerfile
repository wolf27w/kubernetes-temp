FROM redis:7.0
COPY *.conf /usr/local/etc/redis/
COPY run.sh /usr/local/etc/redis/run.sh
RUN apt update -y;apt-get install vim net-tools -y;apt-get clean && \
    chmod +x /usr/local/etc/redis/run.sh
CMD /usr/local/etc/redis/run.sh
