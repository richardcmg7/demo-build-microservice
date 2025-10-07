#!/bin/bash

echo "🔄 Reiniciando Jenkins Master y Slave..."

# Detener servicios existentes
docker-compose down

# Limpiar contenedores huérfanos
docker-compose rm -f

# Crear la red si no existe
docker network create devops 2>/dev/null || echo "Red 'devops' ya existe"

# Reconstruir e iniciar
docker-compose up --build -d

echo "✅ Jenkins reiniciado!"
echo ""
echo "📋 Verificando estado de los servicios..."
sleep 5

# Verificar estado de los contenedores
echo "🐳 Estado de contenedores:"
docker-compose ps

echo ""
echo "📋 Información de acceso:"
echo "   URL: http://localhost:5080"
echo "   Usuario: admin"
echo "   Contraseña: admin123"
echo ""
echo "🔧 Para ver los logs en tiempo real:"
echo "   docker-compose logs -f jenkins-master"
echo "   docker-compose logs -f jenkins-slave"
echo ""
echo "⏳ El slave puede tardar unos minutos en conectarse..."