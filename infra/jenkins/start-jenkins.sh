#!/bin/bash

# Script para iniciar Jenkins con slave
echo "🚀 Iniciando Jenkins Master y Slave..."

# Crear la red si no existe
docker network create devops 2>/dev/null || echo "Red 'devops' ya existe"

# Construir e iniciar los servicios
docker-compose up --build -d

echo "✅ Jenkins iniciado correctamente!"
echo ""
echo "📋 Información de acceso:"
echo "   URL: http://localhost:5080"
echo "   Usuario: admin"
echo "   Contraseña: admin123"
echo ""
echo "🔧 Para ver los logs:"
echo "   docker-compose logs -f jenkins-master"
echo "   docker-compose logs -f jenkins-slave"
echo ""
echo "⏹️  Para detener:"
echo "   docker-compose down"