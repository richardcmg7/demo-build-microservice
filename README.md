# Demo Microservice - Reto 2 CI/CD

Proyecto de demostración para integración continua con Jenkins y Docker Hub.

## 🚀 Estructura del Proyecto

```
├── src/                    # Código fuente Java
├── pom.xml                # Configuración Maven
├── Dockerfile             # Imagen Docker
├── Jenkinsfile            # Pipeline CI/CD
└── infra/jenkins/         # Configuración Jenkins (opcional)
```

## 📋 Reto 2: Integración Continua

### Objetivo
Automatizar la compilación del microservicio con Maven, construir y etiquetar la imagen Docker, y publicarla en Docker Hub desde Jenkins.

### Pipeline
El `Jenkinsfile` implementa:
1. **Checkout** - Descarga código desde Git
2. **Build JAR** - Compila con Maven
3. **Build & Push Image** - Construye y publica imagen Docker

### Configuración Jenkins
1. Crear job tipo **Pipeline**
2. Configurar **Pipeline script from SCM**:
   - Repository URL: `https://github.com/richardcmg7/demo-build-microservice.git`
   - Branch: `*/reto-2/Jenkins`
   - Script Path: `Jenkinsfile`
3. Configurar credenciales Docker Hub con ID: `dockerhub-creds`

### Resultado
- Imagen Docker: `richardc7/demo-micro:BUILD_NUMBER`
- Disponible en: https://hub.docker.com/r/richardc7/demo-micro

## 🛠️ Desarrollo Local

```bash
# Compilar
mvn clean package

# Construir imagen
docker build -t demo-micro:local .

# Ejecutar
docker run -p 8080:8080 demo-micro:local
```

## 📦 Imagen Docker
- **Base**: eclipse-temurin:21-jre-alpine
- **Puerto**: 8080
- **Multi-stage build** para optimización