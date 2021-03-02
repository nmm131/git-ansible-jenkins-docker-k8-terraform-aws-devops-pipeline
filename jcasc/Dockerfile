FROM jenkins/jenkins:lts
USER root
RUN mkdir -p /var/jcasc
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
RUN apt update && \
apt install -y software-properties-common && \
apt install -y ansible
RUN apt update && apt install -y apt-transport-https gnupg2 && \
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
        apt update && \
        apt install -y kubectl
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jcasc/jcasc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY jcasc.yaml /var/jcasc/jcasc.yaml
