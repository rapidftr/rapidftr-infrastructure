FROM ubuntu:14.04

RUN (ln -s -f /bin/true /usr/bin/chfn) && \
    (apt-get update) && \
    (apt-get install -y --no-install-recommends openjdk-7-jdk build-essential git openssh-client wget curl) && \
    (apt-get clean) && \
    (rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

RUN (curl http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | apt-key add -) && \
    (echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list) && \
    (apt-get update) && \
    (apt-get install -y --no-install-recommends jenkins) && \
    (apt-get clean) && \
    (rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

VOLUME /var/lib/jenkins
EXPOSE 8080

ADD run /usr/bin/jenkins
CMD ["/usr/bin/jenkins"]
