#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ec2-user/app/step3
PROJECT_NAME=hello-spring

echo "start.sh >>> copy Build files"
echo "start.sh >>> cp $REPOSITORY/zip/*.jar $REPOSITORY/"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "start.sh >>> new application deploy"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "start.sh >>> JAR Name: $JAR_NAME"

echo "start.sh >>> add new permission $JAR_NAME"

chmod +x $JAR_NAME

echo "start.sh >>> run $JAR_NAME"

IDLE_PROFILE=$(find_idle_profile)

echo "start.sh >>> target : $JAR_NAME // profile=$IDLE_PROFILE"
nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,classpath:/application-$IDLE_PROFILE.properties,/home/ec2-user/app/oauth/application-oauth.properties,/home/ec2-user/app/db/application-real-db.properties,classpath:application-real.properties \
    -Dspring.profiles.active=$IDLE_PROFILE \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &