# Jenkins CI/CD Setup

Configuración de Jenkins con Master y Slave para el Reto 2 de CI/CD.

## 🚀 Inicio Rápido

```bash
cd infra/jenkins
./start-jenkins.sh
```

**Acceso:**
- URL: http://localhost:5080
- Usuario: `admin` (configurable en jenkins-init.groovy)
- Contraseña: `admin123` (configurable en jenkins-init.groovy)

## 📋 Configuración para Reto 2

1. **Crear Pipeline Job**
2. **Pipeline script from SCM**:
   - Repository: `https://github.com/tu-usuario/tu-repositorio.git`
   - Branch: `*/main` (o la rama que uses)
   - Script Path: `Jenkinsfile`

3. **Configurar credenciales Docker Hub**:
   - Manage Jenkins → Manage Credentials → System → Global credentials
   - Add Credentials: Username/Password
   - ID: `dockerhub-creds`
   - Username: `tu-usuario-dockerhub`
   - Password: `tu-token-dockerhub`

## 🔧 Comandos Útiles

```bash
# Ver logs
docker-compose logs -f jenkins-master
docker-compose logs -f jenkins-slave

# Reiniciar
./restart-jenkins.sh

# Verificar estado
./check-status.sh

# Detener
docker-compose down
```

## ⚙️ Configuración

- **Master**: 1.5GB RAM, 0.8 CPU, Puerto 5080
- **Slave**: 768MB RAM, 0.4 CPU, Java 21, Maven, Docker
- **Plugins**: Pipeline, Git, Docker, Maven
- **Red**: `devops` (externa)

## 🎯 Resultado

El pipeline construirá y publicará:
- Imagen: `tu-usuario/demo-micro:BUILD_NUMBER`
- Docker Hub: https://hub.docker.com/r/tu-usuario/demo-micro

## ⚙️ Personalización

**Cambiar usuario/contraseña de Jenkins:**
- Edita `jenkins-init.groovy` líneas:
  ```groovy
  hudsonRealm.createAccount("admin", "admin123")
  ```

**Cambiar namespace de Docker Hub:**
- Edita `Jenkinsfile` línea:
  ```groovy
  DOCKERHUB_NAMESPACE = "tu-usuario"
  ```

## 📁 Archivos

```
infra/jenkins/
├── docker-compose.yaml     # Configuración principal
├── Dockerfile             # Imagen del slave (Java 21)
├── Dockerfile.master      # Imagen del master
├── jenkins-init.groovy    # Script de inicialización (usuario/contraseña)
├── plugins.txt           # Lista de plugins
├── start-jenkins.sh      # Script de inicio
└── README.md            # Este archivo
```