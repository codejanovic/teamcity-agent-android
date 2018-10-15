[![codejanovic/teamcity-agent-android](https://img.shields.io/docker/pulls/codejanovic/teamcity-agent-android.svg)](https://hub.docker.com/r/codejanovic/teamcity-agent-android/)
# teamcity-agent-android
Teamcity Docker Build Agent for Android. Based on the [teamcity-minimal-agent](https://hub.docker.com/r/jetbrains/teamcity-minimal-agent/) image from Jetbrains.

## Run with `docker run`
```
docker run -d --name="container_name" -e AGENT_NAME="agent_name" -e SERVER_URL="https://your.teamcity.com" codejanovic/teamcity-agent-android:latest
```

## Run with docker-compose
Within your `docker-compose.yml` file create a new service:
```docker
 teamcity-agent1:
    container_name: teamcity-agent1
    image: codejanovic/teamcity-agent-android:latest
    expose:
      - 9090     
    environment:
      - SERVER_URL=https://your.teamcity.com
      - AGENT_NAME=agent_name
    restart: always
```