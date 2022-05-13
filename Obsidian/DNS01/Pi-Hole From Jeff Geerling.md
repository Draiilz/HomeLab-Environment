Docs: 
https://github.com/MoJo2600/pihole-kubernetes


Create pihole.yaml
Copy paste the following into the file
```
---

persistentVolumeClaim:

  enabled: true

ingress:

  enabled: true

serviceTCP:

  loadBalancerIP: '192.168.0.190'
  #This is my Traefik Loadbalancer IP other option is 10.43.210.244

  type: LoadBalancer

serviceUDP:

  loadBalancerIP: '192.168.0.190'
  #This is my Traefik Loadbalancer IP other option is 10.43.210.244

  type: LoadBalancer

resources:

  limits:

    cpu: 200m

    memory: 256Mi

  requests:

    cpu: 100m

    memory: 128Mi

# If using in the real world, set up admin.existingSecret instead.

adminPassword: admin
```


Deploy PiHole using hell
```
cd /home/_Project/HomeLab-Environment/DNS/DNS01
helm install --version '2.5.8' --namespace pi-hole --values pihole.yaml pihole mojo2600/pihole
```

Check if pod is running
```
root@DNS01:/home/_Project/HomeLab-Environment/DNS/DNS01# kubectl get pods -n pi-hole
NAME                      READY   STATUS    RESTARTS   AGE
pihole-754f98c5dd-ghlkl   1/1     Running   0          19m
```



Check services:
```
root@DNS01:/home/_Project/HomeLab-Environment/DNS/DNS01# kubectl get svc --all-namespaces
NAMESPACE     NAME             TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
default       kubernetes       ClusterIP      10.43.0.1       <none>          443/TCP                      176m
kube-system   kube-dns         ClusterIP      10.43.0.10      <none>          53/UDP,53/TCP,9153/TCP       176m
kube-system   metrics-server   ClusterIP      10.43.74.13     <none>          443/TCP                      176m
kube-system   traefik          LoadBalancer   10.43.210.244   192.168.0.190   80:32225/TCP,443:31610/TCP   175m
pi-hole       pihole-dhcp      NodePort       10.43.5.145     <none>          67:31835/UDP                 19m
pi-hole       pihole-web       ClusterIP      10.43.222.160   <none>          80/TCP,443/TCP               19m
pi-hole       pihole-dns-tcp   NodePort       10.43.161.80    <none>          53:30391/TCP                 19m
pi-hole       pihole-dns-udp   NodePort       10.43.142.231   <none>          53:31119/UDP                 19m
```

```
root@DNS01:/home/_Project/HomeLab-Environment/DNS/DNS01# kubectl get ns
NAME              STATUS   AGE
default           Active   177m
kube-system       Active   177m
kube-public       Active   177m
kube-node-lease   Active   177m
pi-hole           Active   132m
```


Same error 404...