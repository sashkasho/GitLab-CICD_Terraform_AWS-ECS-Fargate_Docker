FROM maven:3.6.3-openjdk-11-slim AS build
COPY src /src
COPY pom.xml .
RUN mvn package

FROM openjdk:11-oracle
VOLUME /tmp
COPY --from=build target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar", "--spring.profiles.active=docker"]
