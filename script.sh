sudo apt-get update
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg; echo "deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo touch /etc/modules-load.d/k8s.conf

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo nano /etc/sysctl.conf
    
    net.bridge.bridge-nf-call-iptables = 1

sudo -s
sudo echo '1' > /proc/sys/net/ipv4/ip_forward
exit

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

sudo kubeadm config images pull







ubuntu@so2-workernode2:~$ sudo kubeadm join 192.168.100.153:6443 --token xqcb8i.x9lyk15fq0h0y5qv --discovery-token-ca-cert-hash sha256:1a76d0881e7e51dcfded698608d91d2ff5c5e7e1bf22ec45b3efaeb8855329ba
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.




ubuntu@so2-master:~$ kubectl get nodes
NAME              STATUS   ROLES           AGE   VERSION
so2-master        Ready    control-plane   42h   v1.28.15
so2-workernode1   Ready    <none>          42h   v1.28.15
so2-workernode2   Ready    <none>          36s   v1.28.15

ubuntu@so2-master:~$ kubectl get ns
NAME              STATUS   AGE
2048-game         Active   43h
default           Active   43h
kube-flannel      Active   43h
kube-node-lease   Active   43h
kube-public       Active   43h
kube-system       Active   43h


ubuntu@so2-master:~$ kubectl get svc -A
NAMESPACE     NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                  AGE
2048-game     service-2048   NodePort    10.98.160.72   <none>        80:31306/TCP             42h
default       kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP                  42h
kube-system   kube-dns       ClusterIP   10.96.0.10     <none>        53/UDP,53/TCP,9153/TCP   42h
ubuntu@so2-master:~$ kubectl get deployment -A
NAMESPACE     NAME              READY   UP-TO-DATE   AVAILABLE   AGE
2048-game     deployment-2048   5/5     5            5           42h
kube-system   coredns           2/2     2            2           42h
ubuntu@so2-master:~$ kubectl get pods -A
NAMESPACE      NAME                                 READY   STATUS    RESTARTS   AGE
2048-game      deployment-2048-75db5866dd-9tnt7     1/1     Running   0          42h
2048-game      deployment-2048-75db5866dd-cshz4     1/1     Running   0          42h
2048-game      deployment-2048-75db5866dd-jbfd2     1/1     Running   0          42h
2048-game      deployment-2048-75db5866dd-lhlqq     1/1     Running   0          42h
2048-game      deployment-2048-75db5866dd-mqnj7     1/1     Running   0          42h
kube-flannel   kube-flannel-ds-d6n5q                1/1     Running   0          29m
kube-flannel   kube-flannel-ds-gd2hn                1/1     Running   0          42h
kube-flannel   kube-flannel-ds-t6f9r                1/1     Running   0          42h
kube-system    coredns-5dd5756b68-mqmcv             1/1     Running   0          42h
kube-system    coredns-5dd5756b68-zqsbj             1/1     Running   0          42h
kube-system    etcd-so2-master                      1/1     Running   0          42h
kube-system    kube-apiserver-so2-master            1/1     Running   0          42h
kube-system    kube-controller-manager-so2-master   1/1     Running   0          42h
kube-system    kube-proxy-82hgs                     1/1     Running   0          42h
kube-system    kube-proxy-l7xb7                     1/1     Running   0          42h
kube-system    kube-proxy-twz6f                     1/1     Running   0          29m
kube-system    kube-scheduler-so2-master            1/1     Running   0          42h



ubuntu@so2-master:~$ kubectl scale deployment deployment-2048 --replicas=10 -n 2048-game
deployment.apps/deployment-2048 scaled
ubuntu@so2-master:~$ kubectl get pods -n 2048-game
NAME                               READY   STATUS    RESTARTS   AGE
deployment-2048-75db5866dd-5h4hq   1/1     Running   0          22s
deployment-2048-75db5866dd-6p4t2   1/1     Running   0          22s
deployment-2048-75db5866dd-bg58k   1/1     Running   0          22s
deployment-2048-75db5866dd-g6fl2   1/1     Running   0          22s
deployment-2048-75db5866dd-mqnj7   1/1     Running   0          42h
deployment-2048-75db5866dd-qp9m8   1/1     Running   0          22s
deployment-2048-75db5866dd-tv4dn   1/1     Running   0          22s
deployment-2048-75db5866dd-tvsm9   1/1     Running   0          22s
deployment-2048-75db5866dd-vdkrx   1/1     Running   0          22s
deployment-2048-75db5866dd-xk87g   1/1     Running   0          22s
ubuntu@so2-master:~$ 

mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % export KUBECONFIG=~/.kube/so2


mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % kubectl apply -f deployments/2048-game.yaml 
deployment.apps/deployment-2048 created
mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % 

mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % kubectl apply -f deployments/2048-game.yaml 
deployment.apps/deployment-2048 configured
mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % 

ubuntu@so2-master:~$ kubectl describe deployment deployment-2048 -n 2048-game
Name:                   deployment-2048
Namespace:              2048-game
CreationTimestamp:      Fri, 22 Nov 2024 18:30:51 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app.kubernetes.io/name=app-2048
Replicas:               20 desired | 20 updated | 20 total | 20 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app.kubernetes.io/name=app-2048
  Containers:
   app-2048:
    Image:        public.ecr.aws/l6m2t8p7/docker-2048:latest
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   deployment-2048-75db5866dd (20/20 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  17m   deployment-controller  Scaled up replica set deployment-2048-75db5866dd to 5
  Normal  ScalingReplicaSet  83s   deployment-controller  Scaled up replica set deployment-2048-75db5866dd to 20 from 5


mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm repo add longhorn https://charts.longhorn.io
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
"longhorn" has been added to your repositories
mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm repo update
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "longhorn" chart repository
...Successfully got an update from the "openebs" chart repository
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈

mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % kubectl apply -f namespaces/longhorn-system.yaml 
namespace/longhorn-system created

mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm install longhorn longhorn/longhorn --namespace longhorn-system --values helms/longhorn/values.yaml 
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
NAME: longhorn
LAST DEPLOYED: Fri Nov 22 16:18:38 2024
NAMESPACE: longhorn-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Longhorn is now installed on the cluster!

Please wait a few minutes for other Longhorn components such as CSI deployments, Engine Images, and Instance Managers to be initialized.

Visit our documentation at https://longhorn.io/docs/


ubuntu@so2-master:~$ kubectl get pods -n longhorn-system
NAME                                                READY   STATUS    RESTARTS      AGE
csi-attacher-5579f877b5-b287g                       1/1     Running   1 (77m ago)   79m
csi-attacher-5579f877b5-jw79q                       1/1     Running   1 (77m ago)   79m
csi-attacher-5579f877b5-zjtcg                       1/1     Running   1 (77m ago)   79m
csi-provisioner-85c666b879-kmbzb                    1/1     Running   0             79m
csi-provisioner-85c666b879-lvjbd                    1/1     Running   0             79m
csi-provisioner-85c666b879-zdcvm                    1/1     Running   0             79m
csi-resizer-5dc4d54cb7-9xtc9                        1/1     Running   0             79m
csi-resizer-5dc4d54cb7-kkn8n                        1/1     Running   0             79m
csi-resizer-5dc4d54cb7-wsw49                        1/1     Running   0             79m
csi-snapshotter-7cd5568c6d-8lxrt                    1/1     Running   0             79m
csi-snapshotter-7cd5568c6d-pg7q2                    1/1     Running   1 (77m ago)   79m
csi-snapshotter-7cd5568c6d-zxndw                    1/1     Running   0             79m
engine-image-ei-b0369a5d-hxltt                      1/1     Running   0             79m
engine-image-ei-b0369a5d-zhjxd                      1/1     Running   0             79m
instance-manager-96c7ce7c8d218707c0c930c609e8f609   1/1     Running   0             79m
instance-manager-e9aa51a6c33c56c65378d7d28bc2f11f   1/1     Running   0             79m
longhorn-csi-plugin-5q2mr                           3/3     Running   0             79m
longhorn-csi-plugin-xblt4                           3/3     Running   0             79m
longhorn-driver-deployer-68cb9bf546-7v4nf           1/1     Running   1 (79m ago)   80m
longhorn-manager-6dnpz                              1/1     Running   0             79m
longhorn-manager-j6nw9                              1/1     Running   1 (79m ago)   79m
longhorn-ui-585bb57bf4-gm89s                        1/1     Running   0             80m
longhorn-ui-585bb57bf4-qtb8b                        1/1     Running   0             80m
ubuntu@so2-master:~$ 



mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
"prometheus-community" already exists with the same configuration, skipping
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "longhorn" chart repository
...Successfully got an update from the "openebs" chart repository
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈

mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % kubectl apply -f namespaces/monitoring.yaml 
namespace/monitoring created
mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm install prometheus prometheus-community/prometheus --namespace monitoring       
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
NAME: prometheus
LAST DEPLOYED: Fri Nov 22 17:01:55 2024
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
prometheus-server.monitoring.svc.cluster.local


Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 9090


The Prometheus alertmanager can be accessed via port 9093 on the following DNS name from within your cluster:
prometheus-alertmanager.monitoring.svc.cluster.local


Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=alertmanager,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 9093
#################################################################################
######   WARNING: Pod Security Policy has been disabled by default since    #####
######            it deprecated after k8s 1.25+. use                        #####
######            (index .Values "prometheus-node-exporter" "rbac"          #####
###### .          "pspEnabled") with (index .Values                         #####
######            "prometheus-node-exporter" "rbac" "pspAnnotations")       #####
######            in case you still need it.                                #####
#################################################################################


The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
prometheus-prometheus-pushgateway.monitoring.svc.cluster.local


Get the PushGateway URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus-pushgateway,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 9091

For more information on running Prometheus, visit:
https://prometheus.io/



mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm repo add grafana https://grafana.github.io/helm-charts                     
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
"grafana" has been added to your repositories
mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm repo list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
NAME                    URL                                               
bitnami                 https://charts.bitnami.com/bitnami                
openebs                 https://openebs.github.io/charts                  
prometheus-community    https://prometheus-community.github.io/helm-charts
longhorn                https://charts.longhorn.io                        
grafana                 https://grafana.github.io/helm-charts             
mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm repo update
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "longhorn" chart repository
...Successfully got an update from the "openebs" chart repository
...Successfully got an update from the "grafana" chart repository
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈
mateuswgoettems@MacBook-Air-de-Mateus Sistemas_Operacionais_II % helm install grafana grafana/grafana --namespace monitoring --set adminPassword=VOhnKS490m3Q
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /Users/mateuswgoettems/.kube/so2
NAME: grafana
LAST DEPLOYED: Fri Nov 22 17:27:41 2024
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:

   kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

   grafana.monitoring.svc.cluster.local




ubuntu@so2-master:~$ kubectl get pods -A
NAMESPACE         NAME                                                 READY   STATUS    RESTARTS       AGE
2048-game         deployment-2048-75db5866dd-242s7                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-5npjz                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-69c46                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-8xgtd                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-f866d                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-gjlwb                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-hxfk5                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-jgnx9                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-kcgxn                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-kjlhr                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-kszsk                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-mh62s                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-mwv26                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-n762j                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-phh9q                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-tzbfc                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-vfbnx                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-vltjx                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-zktkk                     1/1     Running   0              6m57s
2048-game         deployment-2048-75db5866dd-ztjz2                     1/1     Running   0              6m57s
kube-flannel      kube-flannel-ds-d6n5q                                1/1     Running   1 (173m ago)   4h45m
kube-flannel      kube-flannel-ds-gd2hn                                1/1     Running   0              47h
kube-flannel      kube-flannel-ds-t6f9r                                1/1     Running   1 (173m ago)   47h
kube-system       coredns-5dd5756b68-mqmcv                             1/1     Running   0              47h
kube-system       coredns-5dd5756b68-zqsbj                             1/1     Running   0              47h
kube-system       etcd-so2-master                                      1/1     Running   0              47h
kube-system       kube-apiserver-so2-master                            1/1     Running   0              47h
kube-system       kube-controller-manager-so2-master                   1/1     Running   0              47h
kube-system       kube-proxy-82hgs                                     1/1     Running   0              47h
kube-system       kube-proxy-l7xb7                                     1/1     Running   1 (173m ago)   47h
kube-system       kube-proxy-twz6f                                     1/1     Running   1 (173m ago)   4h45m
kube-system       kube-scheduler-so2-master                            1/1     Running   0              47h
kube-system       tiller-deploy-756b857bbb-dpj8k                       1/1     Running   1 (173m ago)   3h15m
longhorn-system   csi-attacher-5579f877b5-b287g                        1/1     Running   1 (153m ago)   155m
longhorn-system   csi-attacher-5579f877b5-jw79q                        1/1     Running   1 (153m ago)   155m
longhorn-system   csi-attacher-5579f877b5-zjtcg                        1/1     Running   1 (153m ago)   155m
longhorn-system   csi-provisioner-85c666b879-kmbzb                     1/1     Running   0              155m
longhorn-system   csi-provisioner-85c666b879-lvjbd                     1/1     Running   0              155m
longhorn-system   csi-provisioner-85c666b879-zdcvm                     1/1     Running   0              155m
longhorn-system   csi-resizer-5dc4d54cb7-9xtc9                         1/1     Running   0              155m
longhorn-system   csi-resizer-5dc4d54cb7-kkn8n                         1/1     Running   0              155m
longhorn-system   csi-resizer-5dc4d54cb7-wsw49                         1/1     Running   0              155m
longhorn-system   csi-snapshotter-7cd5568c6d-8lxrt                     1/1     Running   0              155m
longhorn-system   csi-snapshotter-7cd5568c6d-pg7q2                     1/1     Running   1 (153m ago)   155m
longhorn-system   csi-snapshotter-7cd5568c6d-zxndw                     1/1     Running   0              155m
longhorn-system   engine-image-ei-b0369a5d-hxltt                       1/1     Running   0              155m
longhorn-system   engine-image-ei-b0369a5d-zhjxd                       1/1     Running   0              155m
longhorn-system   instance-manager-96c7ce7c8d218707c0c930c609e8f609    1/1     Running   0              155m
longhorn-system   instance-manager-e9aa51a6c33c56c65378d7d28bc2f11f    1/1     Running   0              155m
longhorn-system   longhorn-csi-plugin-5q2mr                            3/3     Running   0              155m
longhorn-system   longhorn-csi-plugin-xblt4                            3/3     Running   0              155m
longhorn-system   longhorn-driver-deployer-68cb9bf546-7v4nf            1/1     Running   1 (155m ago)   156m
longhorn-system   longhorn-manager-6dnpz                               1/1     Running   0              155m
longhorn-system   longhorn-manager-j6nw9                               1/1     Running   1 (155m ago)   155m
longhorn-system   longhorn-ui-585bb57bf4-gm89s                         1/1     Running   0              156m
longhorn-system   longhorn-ui-585bb57bf4-qtb8b                         1/1     Running   0              156m
monitoring        grafana-6556797755-qbvdl                             1/1     Running   0              116m
monitoring        prometheus-alertmanager-0                            1/1     Running   0              120m
monitoring        prometheus-kube-state-metrics-575d666cdf-pd9v7       1/1     Running   0              120m
monitoring        prometheus-prometheus-node-exporter-4xxx7            1/1     Running   0              120m
monitoring        prometheus-prometheus-node-exporter-blt2d            1/1     Running   0              120m
monitoring        prometheus-prometheus-node-exporter-fg7dw            1/1     Running   0              120m
monitoring        prometheus-prometheus-pushgateway-576b8c6cd8-5c4fb   1/1     Running   0              120m
monitoring        prometheus-server-777c7f488f-2dnvw                   2/2     Running   0              120m
ubuntu@so2-master:~$ 


ubuntu@so2-master:~$ kubectl get svc -A
NAMESPACE         NAME                                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
2048-game         service-2048                          NodePort    10.98.160.72     <none>        80:31306/TCP             46h
default           kubernetes                            ClusterIP   10.96.0.1        <none>        443/TCP                  47h
kube-system       kube-dns                              ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   47h
kube-system       tiller-deploy                         ClusterIP   10.97.73.10      <none>        44134/TCP                3h17m
longhorn-system   longhorn-admission-webhook            ClusterIP   10.111.144.189   <none>        9502/TCP                 3h7m
longhorn-system   longhorn-backend                      ClusterIP   10.96.114.140    <none>        9500/TCP                 3h7m
longhorn-system   longhorn-conversion-webhook           ClusterIP   10.99.180.248    <none>        9501/TCP                 3h7m
longhorn-system   longhorn-engine-manager               ClusterIP   None             <none>        <none>                   157m
longhorn-system   longhorn-frontend                     ClusterIP   10.103.104.132   <none>        80/TCP                   3h7m
longhorn-system   longhorn-recovery-backend             ClusterIP   10.104.84.43     <none>        9503/TCP                 3h7m
longhorn-system   longhorn-replica-manager              ClusterIP   None             <none>        <none>                   157m
monitoring        grafana                               ClusterIP   10.105.8.252     <none>        80/TCP                   117m
monitoring        prometheus-alertmanager               ClusterIP   10.104.80.22     <none>        9093/TCP                 121m
monitoring        prometheus-alertmanager-headless      ClusterIP   None             <none>        9093/TCP                 121m
monitoring        prometheus-kube-state-metrics         ClusterIP   10.97.71.175     <none>        8080/TCP                 121m
monitoring        prometheus-prometheus-node-exporter   ClusterIP   10.98.54.174     <none>        9100/TCP                 121m
monitoring        prometheus-prometheus-pushgateway     ClusterIP   10.111.104.222   <none>        9091/TCP                 121m
monitoring        prometheus-server                     ClusterIP   10.108.141.191   <none>        80/TCP                   121m

ubuntu@so2-master:~$ kubectl describe deployment deployment-2048 -n 2048-game
Name:                   deployment-2048
Namespace:              2048-game
CreationTimestamp:      Fri, 22 Nov 2024 18:30:51 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app.kubernetes.io/name=app-2048
Replicas:               20 desired | 20 updated | 20 total | 20 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app.kubernetes.io/name=app-2048
  Containers:
   app-2048:
    Image:        public.ecr.aws/l6m2t8p7/docker-2048:latest
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   deployment-2048-75db5866dd (20/20 replicas created)
Events:          <none>
ubuntu@so2-master:~$ 

