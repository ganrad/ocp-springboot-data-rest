# ocp-springboot-data-rest

### Create a *Secret* and mount it into the Pod running the Springboot application

1.  Download the *mysql-secret* file from this project to your local machine.
2.  Generate a *Base64* encoded value for the MySql user name and password. See the commands below.
```
$ echo "mysql.user=mysql" | base64 -w 0
$ echo "mysql.password=password" | base64 -w 0
```
3.  Substitute the *Base64* encoded values for the MySql server user name and password in the *mysql-secret* file as shown below.
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
7. Deploy your Springboot application.
8. Mount the *mysql-secret* into your application pod.
```
$ oc volume dc/springboot-app --add --name=mysqldb --type=secret --secret-name='mysql-secret' --mount-path='/etc/vol-secrets'

