DNS01 - 192.168.0.1
Pi-Holesetup on K3s
Docs:
https://k3s.io/
https://vikaspogu.dev/posts/pi-hole-kubernetes/#install-chart

Grant VS code permissions to edit files
```
sudo chown -R debian /home/_Project
```

Generate ssh keys for GitOps
```Bash
ssh-keygen
cat /root/.ssh/id_rsa.pub
```
Copy SSH key to github


## Install Helm
```Bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
```

# K3s_Setup
Link to doc: https://k3s.io/

Create Namespace for Pi-Hole 
```Bash
kubectl create namespace pi-hole
```
# Commands
```Bash
curl -sfL https://get.k3s.io | sh -
k3s kubectl get node
```

Grab Pi-Hole Helm Files
#Note You should place this in your github repo to organize and not lose your files
```bash
git clone https://github.com/ChrisPhillips-cminion/pihole-helm.git
cd pihole-helm
```
## Edit Files
Edit Deployment.yaml file for updated values:
Line 26: 
```
image: pihole/pihole:v5.1.1
```
Line 33-43
        env:
```
- name: 'ServerIP'

          value: '192.168.0.190'

        - name: 'DNS1'

          value: '8.8.8.8'

        - name: 'DNS2'

          value: '8.8.4.4'

                - name: TZ

                  value: "America/New_York"

                - name: WEBPASSWORD

                  value: "Password"
```
#### Ask Dan about this file and the Server IP
Move to values.yaml
Lines 17-21:
```
configData: |-

  server=/local/192.168.1.1 -- 

  address=/.danielrailsback.com/192.168.0.185

  

ingress:

  host: pi-hole.danielrailsback.com
```


## Configure K3s
create name space for Pi-Hole and Install helm
```Bash
kubectl create ns pi-hole
helm install pi-hole .
```
##### Change KUBCONFIG to maatch k3s instead of k8s --BIG ONE NOT TO FORGET
```Bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
##### Swtich namespace 
```Bash
kubectl config set-context --current --namespace=pi-hole
```
##### Deploy Pi-hole from helm 
```Bash
cd /home/_Project/HomeLab-Environment/DNS/DNS01/Pi-Hole/k3s/manifests/
helm install pi-hole .
```



Now i'm stuck again in the same spot again...

```
root@DNS01:/home/_Project/HomeLab-Environment/DNS/DNS01/Pi-Hole/k3s/manifests# kubectl get pods
No resources found in pi-hole namespace.
```
