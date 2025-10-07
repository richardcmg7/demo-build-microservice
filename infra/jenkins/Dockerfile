# Dockerfile para Jenkins Slave con herramientas de desarrollo
FROM jenkins/agent:latest

USER root

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    maven \
    git \
    curl \
    wget \
    unzip \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Configurar Java 21 como default
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Configurar Maven
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$PATH:$MAVEN_HOME/bin

# Crear directorio de trabajo para el agent
RUN mkdir -p /home/jenkins/agent
RUN chown -R jenkins:jenkins /home/jenkins/agent

# Agregar usuario jenkins al grupo docker
RUN usermod -aG docker jenkins

# Copiar y dar permisos al script de conexión
COPY slave-connect.sh /usr/local/bin/slave-connect.sh
RUN chmod +x /usr/local/bin/slave-connect.sh

USER jenkins
WORKDIR /home/jenkins/agent