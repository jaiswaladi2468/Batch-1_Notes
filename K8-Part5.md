In Kubernetes, taints and tolerations are mechanisms used to control which nodes a pod can be scheduled on. They are important for ensuring that certain pods are only deployed on specific nodes or types of nodes.

### Taints:

A taint is a key-value pair that is applied to a node. It prevents pods from being scheduled onto a node unless the pod has a corresponding toleration. Taints are typically used to mark nodes as unsuitable for certain types of workloads, such as reserving nodes for specific tasks or isolating nodes due to hardware limitations.

Here's an example of applying a taint to a node:

```bash
kubectl taint nodes <node-name> key=value:taint-effect
```

For example:

```bash
kubectl taint nodes node1 app=backend:NoSchedule
```

In this example, we're tainting `node1` with a key-value pair `app=backend` and the taint effect `NoSchedule`. This means that pods without a toleration for `app=backend` will not be scheduled on `node1`.

### Tolerations:

A toleration is a part of a pod's specification that allows the pod to be scheduled onto a node with a matching taint. It effectively tells the scheduler that the pod is "tolerant" of the taint on the node.

Here's an example of adding a toleration to a pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: my-image
  tolerations:
  - key: "app"
    operator: "Equal"
    value: "backend"
    effect: "NoSchedule"
```

In this example, the pod has a toleration for the taint with key `app`, value `backend`, and taint effect `NoSchedule`. This means that the pod can be scheduled on a node with the taint `app=backend:NoSchedule`.

### Taint Effects:

There are three taint effects:

1. **NoSchedule**: The pod will not be scheduled on the tainted node.
2. **PreferNoSchedule**: The scheduler will try to avoid placing the pod on the tainted node, but it's not an absolute restriction.
3. **NoExecute**: If a pod is already running on a node when it gets tainted with `NoExecute`, the pod will be evicted from the node.


# EXAMPLE

Tainting a Node:
kubectl taint nodes <nodename> key=value:effect
kubectl taint nodes ip-172-31-36-109 app=backend:NoSchedule


```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-boot-k8s-deployment
spec:
  selector:
    matchLabels:
      app: spring-boot-k8s
  replicas: 2
  template:
    metadata:
      labels:
        app: spring-boot-k8s
    spec:
      containers:
        - name: spring-boot-k8s
          image: adijaiswal/shopping-cart:latest
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8070
      tolerations:
        - key: app
          operator: Equal
          value: backend
          effect: NoSchedule
---
apiVersion: v1
kind: Service
metadata:
  name: springboot-k8ssvc
spec:
  selector:
    app: spring-boot-k8s
  ports:
    - protocol: TCP
      port: 8070
      targetPort: 8070
  type: NodePort
```


