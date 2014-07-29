FROM ubuntu:14.04

# Add Build Essentials
RUN (ln -s -f /bin/true /usr/bin/chfn) && \
    (apt-get update) && \
    (apt-get install -y --no-install-recommends openjdk-7-jdk build-essential git openssh-client wget curl) && \
    (apt-get clean) && \
    (rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

# Add OpenSSH Server
RUN (apt-get update) && \
    (apt-get install -y --no-install-recommends openssh-server) && \
    (mkdir -p /var/run/sshd) && \
    (sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd) && \
    (apt-get clean) && \
    (rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

# Add Jenkins User
RUN (adduser --quiet jenkins) && \
    (echo "jenkins:jenkins" | chpasswd) && \
    (echo 'jenkins ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins)

# Add Jenkins user to the sudoers
RUN (apt-get update) && \
    (apt-get install -y --no-install-recommends sudo) && \
    (echo 'jenkins ALL = NOPASSWD: ALL' > /etc/sudoers.d/jenkins) && \
    (apt-get clean) && \
    (rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
