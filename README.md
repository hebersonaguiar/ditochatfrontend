App frontend desenvolvida em React que se conecta com o backend do repositório [https://github.com/hebersonaguiar/ditochatbackend](https://github.com/hebersonaguiar/ditochatbackend), no qual é o repossável por servir ao usuário final uma interface amigável de envio de mensagens, basta informar o nome ou não e começar a enviar as mensagens.

## Docker
O Docker é uma plataforma para desenvolvedores e administradores de sistemas para desenvolver, enviar e executar aplicativos. O Docker permite montar aplicativos rapidamente a partir de componentes e elimina o atrito que pode ocorrer no envio do código. O Docker permite que seu código seja testado e implantado na produção o mais rápido possível.
Originalmente essa aplicação não foi desenvolvida para docker, porém sua criação é simples e rápido. 

## Dockerfile
No Dockerfile encontra-se todas as informações para a criação da imagem, para esse projeto foi utilizado como base a imagem `hebersonaguiar/nodebase:1.0`, mais abaixo é copiado código da aplicação, e iniciado o react utilizando `npm start`.

* Importante: no decorrer da criação de uma imagem para essa aplicação utilizando Dockerfile foi notado que a instalação dos pacotes nodes necessários ocorria alguns problemas, que ao verificar os pacotes muitos estavam faltando e com isso impactando no correto funcionamento da aplicação. Devido isso foi realizado a criação de uma imagem manual, ou seja sem utilizar o Dockerfile, segue abaixo os comandos utilizados:

```bash
docker run -dti --name nodebase -h nodebase centos:7 
docker exec -dti nodebase /bin/bash
	# yum -y update
	# yum -y install gcc c++ make curl bind-utils
	# curl -sL https://rpm.nodesource.com/setup_10.x |  bash -
	# yum -y install nodejs
	# npm install react@16.8.1 react-chat-elements@10.2.0 react-dom@16.8.1 react-router-dom@4.3.1 typescript react-scripts@2.1.5
	# npm audit fix
	# npm audit fix --force
docker commit <id_do_container> hebersonaguiar/nodebase:1.0
docker push hebersonaguiar/nodebase:1.0
```

## Entrypoint
No Docekerfile é copiado um arquivo chamado docker-entrypoint.sh no qual é um ShellScript que recebe um parâmentro necessário para execução da aplicação:
- `REACT_APP_BACKEND_WS_URL`: resposável por enviar as mensagens para o backend. Ex: `localhost`

A variável substitui duas variáveis do projeto inicial, que são `REACT_APP_BACKEND_WS` e `REACT_APP_BACKEND_URL` que apontam para o mesmo bcakend, mudando apenas o tipo de comunicação onde um utiliza WS e o outro HTTP. 

O docker-entrypoint.sh realiza uma checagem verificando se o valor informado foi passado corretamente, se sim as variáveis são alteradas no arquivo `src/Chat.js`, se não o contêiner não inicializa informando um log de como inicializar o contêiner.

## Build da imagem
```bash
git clone https://github.com/hebersonaguiar/ditochafrontend.git
docker build -t hebersonaguiar/ditochafrontend ./ditochafrontend
```
## Push da imagem
```bash
docker push hebersonaguiar/ditochafrontend:latest
```

## Uso da imagem
```bash
docker run docker run -dti -e REACT_APP_BACKEND_WS_URL='backend.ditochallenge.com' \
	   hebersonaguiar/ditochafrontend
```
* Importante: para o pleno funcionamento da aplicação é necessário o apontamento do serviço do backend.

## Google Cloud Plataform
Google Cloud Platform é uma suíte de cloud oferecida pelo Google, funcionando na mesma infraestrutura que a empresa usa para seus produtos dirigidos aos usuários, dentre eles o Buscador Google e o Youtube.

Para essa aplicação foram utilizados os seguintes produtos, Cloud DNS, utilizado para o apontamento DNS do domínio `ditochallenge.com` para o serviço do kubernetes e também foi utilizado o Kubernetes Engine, no qual foi criado um cluster kubernetes. Todas as informações de como criar o cluster e acessar utilizando o gcloud e kubectl estão no repositório [Dito Desafio Docs](https://github.com/hebersonaguiar/ditodesafiodocs.git)

## Jenkins X
O Jenkins X possui os conceitos de Aplicativos e Ambientes. Você não instala o Jenkins diretamente para usar o Jenkins X, pois o Jenkins é incorporado como um mecanismo de pipeline como parte da instalação.

Após a criação do cluster kubernetes na GCP utilizando o Jenkins X como informado no repositório [Dito Desafio Docs](https://github.com/hebersonaguiar/ditodesafiodocs.git) é necessário importar esse repositório para isso foi utilizado o comando abaixo:

```bash
jx import --url https://github.com/hebersonaguiar/ditochatfrontend.git
```
Ao importar esse repositório o Jenkins X se encarrega de criar os artefatos como Jenkinsfile, chart e o skaffold. Após a importação as alterações de vairávies desejadas podem ser realizadas. Lembrando que após o commit das alterações o deploy é iniciado.

Caso não queria que o Jenkins X não crie os artefatos basta executar o comando abaixo:

```bash
jx import --no-draft --url https://github.com/hebersonaguiar/ditochatfrontend.git
```

## Kubernetes
Kubernetes ou como é conhecido também K8s é um produto Open Source utilizado para automatizar a implantação, o dimensionamento e o gerenciamento de aplicativos em contêiner no qual agrupa contêineres que compõem uma aplicação em unidades lógicas para facilitar o gerenciamento e a descoberta de serviço.

Para essa aplicação foi utilizado o kubernetes na versão `v1.13.7-gke.24`, na Google Cloud Plataform - GCP utilizando o Google Kubernetes Engine, ou seja, a criação do cluster é realizado pela próprio GCP, nesse caso utilizamos também o Jenkins X para a criação do cluster e integração entre Jnekins X e Kubernetes. Dados de criação do cluster e acessos estão no repositório [Dito Desafio Docs](https://github.com/hebersonaguiar/ditodesafiodocs.git)

Para essa aplicação foi utilizado o ConfigMap do kubernetes, que de forma simples é um conjunto de pares de chave-valor pra armazenamento de configurações, que fica armazenado dentro de arquivos que podem ser consumidos através de pods ou controllers, o configmap criado foi:


```bash
kubectl create namespace chatdito

kubectl create configmap chat-frontend-values \
		--from-literal REACT_APP_BACKEND_WS_URL='backend.ditochallenge.com' \
		--namespace chatdito
```

* Importante: Para esse repositório foi criado um namespace específco, caso já exista algum a criação do mesmo não é necessária, atente-se apenas em criar o configmap no namespace correto. O valor da variável `REACT_APP_BACKEND_WS_URL`  é um DNS válido do domínio `ditochallenge.com` e para o pleno funcionamento da aplicação é necessário o apontamento do serviço do backend na porta.

## Helm Chart
O Helm é um gerenciador de aplicações Kubernetes cria, versiona, compartilha e publica os artefatos. Com ele é possível desenvolver templates dos arquivos YAML e durante a instalaçao de cada aplicação personalizar os parâmentros com facilidade.
Para esse repositório o Helm Chart esta dentro da pasta chart na raiz do projeto e dentro contém os arquivos do Chart. Após implantação do projeto descrito no tópico [Jenkins X](https://github.com/hebersonaguiar/ditochatfrontend#jenkins-x) o arquivo `values.yaml` deve ser alterado alguns parâmentros como, quantidade de replicas, portas de serviço, resources e outros dados necessários para implantação no kuberntes.

Parametros alterados para essa aplicação em `chart/values.yaml`:
```yaml
...
service:
  name: frontend
  type: LoadBalancer
  externalPort: 3000
  internalPort: 3000
...
```
* Importante:
No arquivo `chart/template/deployment.yaml` possui a variável `REACT_APP_BACKEND_WS_URL`  que foi informadas no tópico [Entrypoint](https://github.com/hebersonaguiar/ditochatbackend#entrypoint). Para que ela seja informada para o contêiner no cluster kubernetes foi criado um [configmap](https://github.com/hebersonaguiar/ditochatfrontend#kubernetes) no Kubernetes com o nome `chat-frontend-values`, sua execução foi informada anteriormente no tópico [Kubernetes](https://github.com/hebersonaguiar/ditochatfrontend#kubernetes).


## Jenkinsfile
O Jenkisfile é um arquivo de configuração utilizado para criação de papeline no Jenkins, ele suporta três formatos diferentes: Scripted, Declarative e Groovy. 
Para esse repositório ele foi criado na instlação do Jenkins X no cluster Kubernetes descrito no repositório [Dito Desafio Docs](https://github.com/hebersonaguiar/ditodesafiodocs.git), nele possuem alguns estágios 
* Build e Push da imagem
* Alteração do Chart e push para o Chart Museum
* Promoção para o ambiente de produção Kubernetes
O acionamento do deploy é executado após a execução de um commit, uma vez acionado o Jenkins X executa o Jenkinsfile e o deploy da aplicação é realizada.

## Skaffold
Skaffold é uma ferramenta de linha de comando que facilita o desenvolvimento contínuo de aplicações no Kubernetes. O Skaffold lida com o fluxo de trabalho para implantar a aplicação.
No arquivo skaffold.yaml possuem as variáveis como a do registry, imagem, tag, helm chart, não é necessário nehnhuma alteração, elas são realizadas pelo Jenkins X