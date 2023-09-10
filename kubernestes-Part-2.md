## Kubernetes resources:

1. **Deployment**:
   - A Deployment in Kubernetes is a resource that allows you to define, create, and manage a set of identical pods. It provides features such as rolling updates, scaling, and rollback.

   Sample YAML for a basic Deployment:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: example-deployment
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: example
     template:
       metadata:
         labels:
           app: example
       spec:
         containers:
         - name: nginx
           image: nginx:latest
   ```

2. **Service**:
   - A Service in Kubernetes is an abstraction that defines a logical set of pods and a policy by which to access them. It enables network access to a set of pods.

   Sample YAML for a basic Service (LoadBalancer type):

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: example-service
   spec:
     selector:
       app: example
     ports:
       - protocol: TCP
         port: 80
         targetPort: 80
     type: LoadBalancer
   ```

3. **ConfigMap**:
   - A ConfigMap in Kubernetes is a way to store configuration data separate from application code. It allows you to decouple configuration from your pods.

   Sample YAML for a basic ConfigMap:

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: example-config
   data:
     key1: value1
     key2: value2
   ```

4. **Secrets**:
   - A Secret in Kubernetes is an object that allows you to store sensitive information, such as passwords, OAuth tokens, and ssh keys. They are stored in a base64 encoded format.

   Sample YAML for a basic Secret:

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: example-secret
   type: Opaque
   data:
     username: dXNlcm5hbWU=
     password: cGFzc3dvcmQ=
   ```

# SAMPLE


```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-configmap
data:
  db_host: mongodb-service
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mongodb-secret
type: Opaque
data:
  username: dXNlcm5hbWU=
  password: cGFzc3dvcmQ=
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_ROOT_USERNAME
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: username
        - name: MONGO_INITDB_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: password
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
spec:
  selector:
    app: mongodb
  ports:
    - protocol: TCP
      port: 27017
      targetPort: 27017
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-express
  labels:
    app: mongo-express
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongo-express
  template:
    metadata:
      labels:
        app: mongo-express
    spec:
      containers:
      - name: mongo-express
        image: mongo-express
        ports:
        - containerPort: 8081
        env:
        - name: ME_CONFIG_MONGODB_ADMINUSERNAME
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: username
        - name: ME_CONFIG_MONGODB_ADMINPASSWORD
          valueFrom:
            secretKeyRef:
              name: mongodb-secret
              key: password
        - name: ME_CONFIG_MONGODB_SERVER 
          valueFrom: 
            configMapKeyRef:
              name: mongodb-configmap
              key: db_host
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mongo-express-service
spec:
  selector:
    app: mongo-express
  type: LoadBalancer  
  ports:
    - protocol: TCP
      port: 8081
      targetPort: 8081
      nodePort: 30000
```
```

Just remember to format this Markdown code appropriately in your specific Markdown document or platform to render it as intended.
