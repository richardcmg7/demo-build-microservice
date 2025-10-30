# Demo Microservice - Reto 2 & Reto 3 (CI/CD + k8s)

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

### Pipeline (Reto 2)
El `Jenkinsfile` (rama `reto-2/Jenkins`) implementa:
1. **Checkout**
2. **Build JAR**
3. **Build & Push Image**

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
## Despliegue k3s (Reto 3)

### Objetivo
Extender la pipeline para ejecutar pruebas, construir imagen y desplegar automáticamente en un clúster k3s usando manifiestos Kubernetes (Namespace, Deployment y Service NodePort).

### Estructura Kubernetes
```
k8s/
   namespace.yaml
   deployment.yaml
   service.yaml
```

### Pipeline extendida (rama `reto-3/k8s`)
Etapas:
1. **Checkout**
2. **Test** (mvn test + reporte JUnit)
3. **Build JAR**
4. **Build & Push Image** (tags: BUILD_NUMBER y latest)
5. **Deploy to k3s** (condicional: solo si hubo cambios en `src/`, `pom.xml` o `k8s/` y en la rama de despliegue)

Incluye triggers: `githubPush` y `pollSCM` cada 5 minutos.

### Requisitos
- k3s instalado (`curl -sfL https://get.k3s.io | sh -`)
- Jenkins con acceso a `kubectl` y credencial Docker Hub `dockerhub-creds`
- Contexto de kubectl apuntando al cluster (variable `KUBECONFIG` o archivo montado).

### Despliegue manual
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl -n demo get pods
kubectl -n demo get svc demo-micro
curl http://<node-ip>:30080/
```

### Limpieza
```bash
kubectl delete -f k8s/deployment.yaml
kubectl delete -f k8s/service.yaml
kubectl delete -f k8s/namespace.yaml
```

### Próximas mejoras
- Escaneo de imagen (Trivy)
- Aprobación manual antes de producción
- Métricas y observabilidad (Prometheus/Grafana)

- **Base**: eclipse-temurin:21-jre-alpine
- **Puerto**: 8080
- **Multi-stage build** para optimización