
# Etapa 1: Construcción (incluye Maven y Java)
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /build

# Copiar archivos del proyecto
COPY pom.xml .
COPY src ./src

# Compilar la aplicación
RUN mvn clean package -DskipTests

# Etapa 2: Runtime (solo Java)
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copiar el JAR desde la etapa anterior
COPY --from=builder /build/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]