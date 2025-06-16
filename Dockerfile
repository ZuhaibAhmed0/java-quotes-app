# Use an official Maven image to build the application
FROM maven:3.9.3-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy the pom.xml and download dependencies (better for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build the project
COPY src ./src
RUN mvn package -DskipTests

# Use a minimal JDK image for running the app
FROM eclipse-temurin:17-jdk-alpine

# Set working directory
WORKDIR /app

# Copy the built jar file from the builder stage
COPY --from=build /app/target/*.jar app.jar

# Expose application port
EXPOSE 8000

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
