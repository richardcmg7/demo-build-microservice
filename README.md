# Reto 1: Integración continua con GitHub Actions y Docker Hub

## Descripción
Este repositorio contiene un microservicio Java (Spring Boot) que se construye y publica automáticamente como imagen Docker en Docker Hub usando GitHub Actions.

### Objetivo
- Construir el artefacto (JAR) del microservicio Java.
- Construir la imagen Docker a partir del JAR.
- Publicar la imagen en Docker Hub con etiquetas trazables.

## Prerrequisitos
- Repositorio en GitHub con el microservicio (Maven).
- Dockerfile válido en la raíz del proyecto.
- Cuenta y repositorio en Docker Hub (ejemplo: `docker.io/richardc7/reto-maven`).
- Configurar en GitHub → Settings → Secrets:
	- `DOCKERHUB_USERNAME`
	- `DOCKERHUB_TOKEN`

## Estructura mínima del proyecto

```
.
├─ src/...
├─ pom.xml
├─ Dockerfile
└─ .github/workflows/ci-dockerhub.yml
```

## Comandos útiles

### Construir y probar localmente

```bash
mvn clean package
mvn test
```

### Construir imagen Docker local

```bash
docker build -t reto-maven:local .
```

### Ejecutar el microservicio localmente

```bash
java -jar target/demo-micro-1.0.0.jar
```

### Ejecutar el contenedor Docker

```bash
docker run -p 8080:8080 reto-maven:local
```

## Pipeline CI/CD (GitHub Actions)
Al hacer push a `main` o crear un tag, se ejecuta el workflow `.github/workflows/ci-dockerhub.yml`:
1. Compila el JAR con Maven.
2. Construye la imagen Docker.
3. Publica la imagen en Docker Hub usando los secretos configurados.


---
Para dudas o mejoras, consulta el código fuente y los archivos de configuración incluidos.
