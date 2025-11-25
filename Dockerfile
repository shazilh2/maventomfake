# ===== Stage 1: Build the WAR with Maven =====
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source
COPY src ./src

# Build WAR
RUN mvn package -DskipTests


# ===== Stage 2: Run with webapp-runner =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy WAR (matches <finalName>MyMavenApp</finalName>)
COPY --from=build /app/target/MyMavenApp.war app.war

# Download webapp-runner manually (recommended)
ADD https://repo1.maven.org/maven2/com/github/jsimone/webapp-runner/8.5.11.3/webapp-runner-8.5.11.3.jar webapp-runner.jar

EXPOSE 8096

ENTRYPOINT ["java", "-jar", "webapp-runner.jar", "--port", "8096", "app.war"]

