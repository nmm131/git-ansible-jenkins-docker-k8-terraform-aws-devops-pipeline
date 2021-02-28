FROM jenkins/jenkins:lts
USER root
RUN apt update && \
        apt install -y \
           apt-transport-https \
           ca-certificates \
           curl \
           gnupg-agent \
           software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - 
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt update && \
        apt install -y docker-ce docker-ce-cli containerd.io
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/jcasc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY jcasc.yaml /var/jenkins_home/jcasc.yaml
