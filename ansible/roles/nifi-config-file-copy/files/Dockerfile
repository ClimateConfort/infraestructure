FROM apache/nifi:latest

# Copy configuration files
COPY nifi.properties /opt/nifi/nifi-current/conf/
COPY state-management.xml /opt/nifi/nifi-current/conf/
COPY zookeeper.properties /opt/nifi/nifi-current/conf/
COPY zookeeper/myid /opt/nifi/nifi-current/state/zookeeper/myid
