# The EKS cluster setup repo

This repository hosts the cluster provisioning functionality for Amazon EKS.
To successfully provision the EKS cluster we need to first install the
`aws-iam-authenticator` ( `curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator` ).

Next, we need to install Terraform providers and modules:

```bash
# terraform init
```

and then

```bash
# terraform apply
```

After the successfull provision we can grab the `kubectl config` with the command:

```bash
# terraform output kubectl_config
```

and save it for future EKS cluster communication.



## POD deployments

The deployment of the pods is very straigthforward:

With this deployment file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
```

We can run the command:

```bash
# kubectl apply -f deployment.yaml
```

And get pods running:

```
NAME                     READY   STATUS    RESTARTS   AGE
nginx-6985d585b6-k46dc   1/1     Running   0          10s

```


