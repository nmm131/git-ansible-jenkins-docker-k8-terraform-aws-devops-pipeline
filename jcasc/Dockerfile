FROM jenkins/jenkins:lts
RUN apt remove docker docker-engine docker.io containerd runc && \
        apt update && \
        apt install \
           apt-transport-https \
           ca-certificates \
           curl \
           gnupg-agent \
           software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
        apt update && \
        apt install docker-ce docker-ce-cli containerd.io
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/jcasc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY jcasc.yaml /var/jenkins_home/jcasc.yaml
