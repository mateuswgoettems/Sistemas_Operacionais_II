# Projeto Kubernetes com Cluster em Proxmox

Este projeto configura um cluster Kubernetes em um ambiente bare-metal no Proxmox, com instalação e configuração de diversas ferramentas, como o MetalLB e o Ingress Nginx, para gerenciar o tráfego de rede e expor serviços externamente. Segue uma lista das ferramentas necessárias para a instalação e gerenciamento do cluster e instruções sobre como instalá-las.

## Ferramentas Utilizadas

### 1. Proxmox
   - **Descrição**: Proxmox é uma plataforma de virtualização que permite gerenciar múltiplas máquinas virtuais (VMs) e containers, servindo como o ambiente base para criar os nós do cluster.
   - **Instalação**: [Proxmox VE Installation Guide](https://www.proxmox.com/en/downloads)

### 2. Kubernetes
   - **Descrição**: Kubernetes é a plataforma de orquestração de containers usada para implantar, escalar e gerenciar as aplicações. Precisamos do **kubectl** para gerenciar o cluster.
   - **Instalação do Kubectl**: 
     ```bash
     curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
     chmod +x kubectl
     sudo mv kubectl /usr/local/bin/
     ```
   - **Documentação**: [Kubernetes Documentation](https://kubernetes.io/docs/)

### 3. Helm
   - **Descrição**: Helm é o gerenciador de pacotes para Kubernetes, que facilita a instalação e gerenciamento de aplicações, como o MetalLB e o Ingress Nginx.
   - **Instalação**:
     ```bash
     curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
     chmod 700 get_helm.sh
     ./get_helm.sh
     ```
   - **Documentação**: [Helm Documentation](https://helm.sh/docs/)

### 4. MetalLB
   - **Descrição**: MetalLB é um add-on que fornece funcionalidade de LoadBalancer em clusters Kubernetes em ambiente bare-metal, permitindo alocar endereços IP externos para serviços expostos.
   - **Instalação**: A instalação do MetalLB será feita dentro do cluster Kubernetes usando o Helm, após a configuração inicial dos nós.

### 5. Ingress Nginx
   - **Descrição**: O Ingress Nginx é um controlador de Ingress para Kubernetes que gerencia o roteamento de tráfego HTTP e HTTPS, essencial para expor os serviços do cluster de maneira controlada.
   - **Instalação**: A instalação do Ingress Nginx também será realizada com Helm dentro do cluster Kubernetes.

### 6. Docker
   - **Descrição**: Docker é o runtime de container padrão para Kubernetes, usado para construir e gerenciar imagens de containers para as aplicações.
   - **Instalação**:
     ```bash
     sudo apt-get update
     sudo apt-get install -y docker-ce docker-ce-cli containerd.io
     ```
   - **Documentação**: [Docker Documentation](https://docs.docker.com/)

### 7. OpenSSH (para acesso remoto)
   - **Descrição**: OpenSSH permite o acesso remoto seguro aos nós do cluster para gerenciar e monitorar as máquinas de forma prática.
   - **Instalação**:
     ```bash
     sudo apt-get install -y openssh-server
     ```

### 8. curl (para transferências de arquivos e instalação de ferramentas)
   - **Descrição**: curl é uma ferramenta de linha de comando usada para transferências de dados, necessária para baixar alguns pacotes e recursos.
   - **Instalação**:
     ```bash
     sudo apt-get install -y curl
     ```

## Configuração

Após instalar essas ferramentas, prossiga com a configuração do cluster conforme descrito nas tarefas do projeto, utilizando o Proxmox para criar as VMs, kubectl para gerenciar o Kubernetes, e Helm para instalar os add-ons.