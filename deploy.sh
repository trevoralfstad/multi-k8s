# build our images
docker build -t talfstad/multi-client:latest -t talfstad/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t talfstad/multi-server:latest -t talfstad/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t talfstad/multi-worker:latest -f -t talfstad/multi-worker:$SHA ./worker/Dockerfile ./worker

# push up to docker hub w/ latest tag
docker push talfstad/multi-client:latest
docker push talfstad/multi-server:latest
docker push talfstad/multi-worker:latest
# push up to docker hub with SHA tag
docker push talfstad/multi-client:$SHA
docker push talfstad/multi-server:$SHA
docker push talfstad/multi-worker:$SHA

# deploy what we built build everything to google cloud
# goes out to docker and pulls down images we just pushed
kubectl apply -f k8s # apply k8s config files

# tell GCE to to update the image to <image-name>:latest
kubectl set image deployments/client-deployment client=talfstad@multi-client:$SHA
kubectl set image deployments/server-deployment server=talfstad@multi-server:$SHA
kubectl set image deployments/worker-deployment worker=talfstad@multi-worker:$SHA
