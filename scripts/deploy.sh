#!/bin/bash

REPO=/home/ec2-user/app/step2
PROJECT_NAME=hello_spring

echo "Auto Deploy >>>  copy build files... (1/4)"

cp $REPO/$PROJECT_NAME/build/libs/*.jar $REPO/

echo "Auto Deploy >>>  check running application... (2/4)"

CURRENT_PID=$(pgrep -fl demo | grep java | awk '{print $1}')

if [ -z "$CURRENT_PID" ]; then
    echo "Auto Deploy >>>  cannot find running application, skip this step"
else
    echo "Auto Deploy >>>  found running application   pid : $CURRENT_PID"
    echo "Auto Deploy >>>   try kill $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

echo "Auto Deploy >>>  deploy new application... (3/4)"

JAR_NAME=$(ls -tr $REPO/*.jar | tail -n 1)

echo "Auto Deploy >>>  start run new application... name : $JAR_NAME (4/4)"

chmod +x $JAR_NAME

nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,/home/ec2-user/app/oauth/application-oauth.properties,/home/ec2-user/app/db/application-real-db.properties,classpath:application-real.properties/\
    -Dspring.profiles.active=real \
    $JAR_NAME > $REPO/nohup.out 2>&1 &

echo "Auto Deploy >>>  deploy fin!"