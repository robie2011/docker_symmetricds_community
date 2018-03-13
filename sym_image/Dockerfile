FROM anapsix/alpine-java
ENV SYM_ENGINE_FILE client-machine01.properties

ADD data /data
RUN /data/setup.sh

CMD /data/symmetricds_start.sh