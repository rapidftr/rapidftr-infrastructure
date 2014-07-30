FROM ubuntu:14.04

# Add Build Essentials
RUN (ln -s -f /bin/true /usr/bin/chfn) && \
    (apt-get update) && \
    (apt-get install -y --no-install-recommends openjdk-7-jdk build-essential git openssh-client curl wget rsync) && \
    (apt-get clean) && \
    (rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

# Download Swarm CLI
ADD http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.16/swarm-client-1.16-jar-with-dependencies.jar /usr/local/bin/swarm-client.jar

ENTRYPOINT ["java", "-jar", "/usr/local/bin/swarm-client.jar"]
CMD []
