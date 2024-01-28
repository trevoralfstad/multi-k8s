# build our images
docker build -t talfstad/multi-client-k8s:latest -t talfstad/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t talfstad/multi-server-k8s:latest -t talfstad/multi-server-k8s:$SHA -f ./server/Dockerfile ./server
docker build -t talfstad/multi-worker-k8s:latest -t talfstad/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

# push up to docker hub w/ latest tag
docker push talfstad/multi-client-k8s:latest
docker push talfstad/multi-server-k8s:latest
docker push talfstad/multi-worker-k8s:latest
# push up to docker hub with SHA tag
docker push talfstad/multi-client-k8s:$SHA
docker push talfstad/multi-server-k8s:$SHA
docker push talfstad/multi-worker-k8s:$SHA

# deploy what we built build everything to google cloud
# goes out to docker and pulls down images we just pushed
kubectl apply -Rf k8s # apply k8s config files

# tell GCE to to update the image to <image-name>:latest
kubectl set image deployments/client-deployment client=talfstad/multi-client-k8s:$SHA
kubectl set image deployments/server-deployment server=talfstad/multi-server-k8s:$SHA
kubectl set image deployments/worker-deployment worker=talfstad/multi-worker-k8s:$SHA
