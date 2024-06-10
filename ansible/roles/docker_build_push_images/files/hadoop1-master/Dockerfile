FROM registry.datuen-ingenieritza.local:5000/hadoop2-base

WORKDIR /root

ADD config/bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

COPY mapreduce /root/mapreduce

CMD ["/etc/bootstrap.sh", "-d"]

