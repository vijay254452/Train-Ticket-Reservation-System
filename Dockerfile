# Use official Tomcat base image
FROM tomcat:9.0-jdk17

# Remove default ROOT app (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR file into Tomcat webapps directory
# Assuming your Maven/Gradle build creates target/TrainTicketReservationSystem.war
COPY target/TrainTicketReservationSystem.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
