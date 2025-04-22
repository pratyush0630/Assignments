# Assignments
All the training assignments


Task_1: Kubernetes

1) Create a deplyment file and service file for the nginx and wrap it in new_app.yaml: 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80


kubectl apply -f new_app.yaml
( We will get the number of deplyments and services with the desired number of replicas (i.e. 3) )

kubectl scale deployment nginx-deployment --replicas=0 ==== to scale down
kubectl scale deployment nginx-deployment --replicas=1 === to scale up to 1 replica.


2) Enter the nginx pod and access it from there using the service

create 2 pods and then use the command to get into the conatainer

kubectl exec -it <nginx-deployment-58cdc7b878-7csf9> -- sh
( Now you will be inside the another pod try using CURL or WGET to ping to any service to check the connectivity)
curl http://nginx-svc

3) Check the logs of the PODS:
kubectl get pods
kubectl logs nginx-deployment
kubectl logs nginx-deploymet_1


4)View the pod and deployment status
kubectl get pods  ( to get the number of pods running)
kubectl get deployment  (to get the deployments running)
kubectl get rs  (to get the number of replicas running)
kubectl get svc   (to get the services running)
kubectl get pods -o wide (to get the detailed info. about the pods)


5) Create an ingress for your deployment

Install the ingress controller:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.5/deploy/static/provider/kind/deploy.yaml


writing the ingress file for the deployments
 /
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: nginx.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
/

Install metallb for allocating the ip tp the Ingress resource:

Add Metallb config file:
# metallb-config.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: kind-address-pool
  namespace: metallb-system
spec:
  addresses:
    - 172.18.255.200-172.18.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: advert
  namespace: metallb-system

kubectl apply -f metallb-config.yaml
Now your service will get the ip once you change the service type from NodePort to LoadBalancer.
doing it manually inside the file or using Command line args.

kubectl get svc

kubectl label node kind-control-plane ingress-ready=true

Website is now available on the :http://nginx.local:8080/
adding this enttry inside the /etc/hosts/ file and using the link.


