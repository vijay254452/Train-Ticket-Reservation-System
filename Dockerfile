# Use official OpenJDK as base
FROM openjdk:17-jdk-slim

# Set work directory
WORKDIR /app

# Copy jar file (assuming Maven/Gradle build outputs to target/*.jar)
COPY target/train-ticket-reservation-system-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
