FROM maven:3.6.3-openjdk-11-slim AS build
ENV DB_USERNAME=default
ENV DB_PASSWORD=default
ENV DB_URL=default
COPY src /src
COPY pom.xml .
RUN mvn package -DskipTests

FROM openjdk:11-oracle
ENV DB_USERNAME=default
ENV DB_PASSWORD=default
ENV DB_URL=default
VOLUME /tmp
COPY --from=build target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar", "--spring.profiles.active=docker"]
