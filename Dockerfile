FROM openjdk
#expose port 8088
EXPOSE 8088
#copy hello world to docker image from builder image
COPY target/hello-world-0.1.0.jar /data/hello-world-0.1.0.jar
#default command
CMD java -jar /data/hello-world-0.1.0.jar
