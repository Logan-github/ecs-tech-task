echo "Starting to deploy docker image.."
DOCKER_IMAGE=demo-task-image
CONTAINER_NAME=nginx-task
sudo docker pull $DOCKER_IMAGE
sudo docker ps -q --filter ancestor=$DOCKER_IMAGE | xargs sudo docker stop
sudo docker run --name $CONTAINER_NAME -p 80:80 -dit $DOCKER_IMAGE