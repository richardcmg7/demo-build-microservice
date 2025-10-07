#!/bin/bash

echo "🔍 Verificando estado de Jenkins..."
echo ""

# Verificar contenedores
echo "🐳 Estado de contenedores:"
docker-compose ps
echo ""

# Verificar logs del master
echo "📋 Últimas líneas del log del master:"
docker-compose logs --tail=10 jenkins-master
echo ""

# Verificar logs del slave
echo "🔗 Últimas líneas del log del slave:"
docker-compose logs --tail=10 jenkins-slave
echo ""

# Verificar conectividad
echo "🌐 Verificando conectividad:"
if curl -f http://localhost:5080/login >/dev/null 2>&1; then
    echo "✅ Jenkins Master accesible en http://localhost:5080"
else
    echo "❌ Jenkins Master no accesible"
fi

# Verificar token
if docker-compose exec jenkins-master test -f /shared/slave-token.txt 2>/dev/null; then
    echo "✅ Token del slave generado"
else
    echo "❌ Token del slave no encontrado"
fi

echo ""
echo "💡 Comandos útiles:"
echo "   Ver logs completos: docker-compose logs jenkins-slave"
echo "   Reiniciar slave: docker-compose restart jenkins-slave"
echo "   Acceder al master: http://localhost:5080"