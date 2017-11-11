echo "Creating a new project => myproject ...."
oc new-project myproject --description="Springboot project" --display-name="Springboot test project"
echo "Switching projects to => myproject ...."
oc project myproject
echo "Deploying MySQL (ephemeral) v5.7...."
oc new-app --template=mysql-ephemeral MYSQL_USER=mysql MYSQL_PASSWORD=password MYSQL_ROOT_PASSWORD=password
echo "Waiting 10 seconds for mysql pod to come up ...."
sleep 10
echo "Creating new build (binary) for po-service application ...."
oc new-build --binary=true --name=po-service --image-stream=redhat-openjdk18-openshift
echo "Starting the build ...."
oc start-build po-service --from-dir=../test --follow
echo "Creating the po-service application ...."
oc new-app po-service
echo "Exposing route for po-service application ...."
oc expose svc/po-service
echo "DONE."
