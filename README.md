#  Create, Build and Deploy a Springboot Microservice (Application/API Endpoint) in OpenShift CP

This Springboot application demonstrates how to build and deploy a *Purchase Order* microservice as a containerized application on OpenShift CP. The deployed microservice supports all CRUD operations on purchase orders.

### A] First, create a new project in OpenShift using the Web Console (UI).
Name the project as *myproject*.
### B] Deploy a ephemeral MySql database server instance (Pod) in OpenShift.
Name the application as *mysql*.  Specify the following values for the database parameters
```
Database service name = mysql
Database name = sampledb
Database user name = mysql
Database password = password
```
### C] Deploy the *Purchase Order* microservice application on OpenShift CP.
1.  Download the *mysql-secret.yaml* file from this project to your local machine.
2.  Generate a *Base64* encoded value for the MySql server user name and password. See the commands below.
```
$ echo "mysql.user=mysql" | base64 -w 0
$ echo "mysql.password=password" | base64 -w 0
```
3.  Substitute the *Base64* encoded values for the MySql server user name and password in the *mysql-secret.yaml* file as shown below.
```
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
data:
  db.username: bW9uZ29kYi51c2VyPW9zZVVzZXIK
  db.password: bW9uZ29kYi5wYXNzd29yZD1vcGVuc2hpZnQK
```
4. Create the secret API object in your project/namespace.
```
$ oc create -f mysql-secret.yaml
```
5. List the secret objects in your project/namespace.
```
$ oc get secrets
```
6. Add the *mysql-secret* secret to the default Service Account.
```
$ oc secrets add serviceaccount/default secret/mysql-secret --for=mount
```
7. Use the OpenShift Web Console (UI) to deploy the Springboot application instance (Pod) in OpenShift. Name the application as *po-service*.  Allow the application build to finish and the application Pod to come up (start).  The application Pod will start and terminate as we have not injected the secret (*mysql-secret*) containing the database user name and password into the Pod yet.  We will do this in the next step.
8. Use the command below to mount the *mysql-secret* into your application Pod.
```
$ oc volume dc/po-service --add --name=mysqldb --type=secret --secret-name='mysql-secret' --mount-path='/etc/vol-secrets'
```
The above command will trigger a new application deployment.  Wait for the deployment to finish.  As soon as the deployment finishes, the *po-service* application Pod should start Ok.  The application should now be able to connect to the backend MySql database.
9.  Test the microservice by using the *scripts* in the */scripts* directory.  The microservice exposes a HATEAS API and supports all CRUD operations on purchase orders.

Congrats!  You have just built and deployed a simple Springboot microservice on OpenShift CP.
