FROM openjdk:11-oracle
VOLUME /tmp
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar","/app.jar", "--spring.profiles.active=docker"]
