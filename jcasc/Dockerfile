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
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        unzip awscliv2.zip && \
        ./aws/install && \
        curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator && \
        chmod +x ./aws-iam-authenticator && \
        mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin && \
        echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jcasc/jcasc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY jcasc.yaml /var/jcasc/jcasc.yaml
