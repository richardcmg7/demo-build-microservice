#!/bin/bash

# Script para conectar el slave automáticamente
JENKINS_URL="http://jenkins-master:8080"
AGENT_NAME="jenkins-slave"
AGENT_WORKDIR="/home/jenkins/agent"
TOKEN_FILE="/shared/slave-token.txt"

echo "🔄 Iniciando conexión del Jenkins Slave..."

# Esperar a que Jenkins Master esté disponible
echo "⏳ Esperando a que Jenkins Master esté disponible..."
while ! curl -f ${JENKINS_URL}/login >/dev/null 2>&1; do
    echo "   Esperando Jenkins Master..."
    sleep 5
done

echo "✅ Jenkins Master disponible!"

# Esperar a que el token esté disponible
echo "⏳ Esperando token del slave..."
while [ ! -f "$TOKEN_FILE" ]; do
    echo "   Esperando token en $TOKEN_FILE..."
    sleep 5
done

# Leer el token
TOKEN=$(cat $TOKEN_FILE)
echo "🔑 Token obtenido: ${TOKEN:0:10}..."

# Descargar el agent.jar
echo "📥 Descargando agent.jar..."
curl -sO ${JENKINS_URL}/jnlpJars/agent.jar

# Conectar el slave
echo "🚀 Conectando slave al master..."
java ${JAVA_OPTS:-"-Xmx512m -Xms256m -XX:+UseG1GC"} -jar agent.jar \
    -url ${JENKINS_URL} \
    -secret ${TOKEN} \
    -name ${AGENT_NAME} \
    -workDir ${AGENT_WORKDIR} \
    -webSocket