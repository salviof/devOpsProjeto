#!/bin/bash
ARGUMENTOS_ESPERADOS=2
diretorioChamada=$1
nomeScript=$2
# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
	alerta "Especifique o nome do cliente, e do projeto $0 ;) "
	exit $E_BADARGS
fi
source $CAMINHO_RELEASE/cliente.info
alerta "Verificando informações de implantação"
#TIPOS_REGISTRO_DOCKER=("LOCAL" "AMAZON" "DOCKERHUB")
#if [ -n "$HOST_RESPOSITORIO_DOCKER" ]; then
#  echo "You supplied the first parameter!"
#fi
#REGISTRO_DOCKER="LOCAL"
#if echo ${TIPOS_REGISTRO_DOCKER[@]} | grep -q -w "$REGISTRO_DOCKER"; then 
#    echo "o tipo de publicação da imagem docker é $REGISTRO_DOCKER"
#else 
#    echo "os valores aceitaveis para variavel  REGISTRO_DOCKER são: "
#    echo ${TIPOS_REGISTRO_DOCKER[@]} 
#    exit $E_BADARGS
#fi
#if [ -z "$HOST_DOCKER_COMPOSER" ] then
# echo "A variavel host docker composer"
# exit $E_BADARGS
#fi
alerta "
***************************ATENÇÃO********************************************* 

Este script irá atualizar o projeto javaee: $NOME_PROJETO   \n

Você pode:
pressionar ctr+c para cancelar enter para subir o arquivo de implantação \n

*Este script apenas compila, e atualiza as imagens docker, para o servidor de implantação ! \n
-> a implantação deve ser acionada pelo Jenkins ( aquele seu mordomo sagaz open-source, que faz o trabalho pesado para você)
"
pause
alerta "Deseja implantar a exibição de requisitos em tempo real do projeto (Disponível apenas para membros do coletivoJava.com.br)"
alerta "-> Escreva SIM caso queira atualizar também os requisitos do projeto"
read respAtualizarRequisito
ATUALIZAR_REQUISITO=false
if [[ $respAtualizarRequisito == *"SIM"* ]]
then
	ATUALIZAR_REQUISITO=true
fi
if $ATUALIZAR_REQUISITO ; then
	alerta "ATENÇÃO ----> O requisito será atualizado"
else
	respAtualizarRequisito="NAO"
	alerta "O requisito NÃÃOOO será atualizado (o sim deve ser Maiusculo)" 
fi
alerta "Definindo variaveis de ambiente"
CAMINHO_WEBAPP_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/webApp
CAMINHO_WEBAPP_REQUISITO_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/webAppRequisitos
CAMINHO_MODEL_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/modelRegras

CAMINHO_WEBAPP_TARGET=$CAMINHO_WEBAPP_PROJETO/target
CAMINHO_MODEL_TARGET=$CAMINHO_MODEL_PROJETO/target
CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET=$CAMINHO_WEBAPP_REQUISITO_PROJETO/target
CAMINHO_SOURCE_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO

cd $CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO
BRANCH_ATUAL=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ -z "$BRANCH_ATUAL" ]; then
alerta "A branch não foi encontrada ! $BRANCH_ATUAL ;) "
	exit $E_BADARGS
fi
alerta "A Branch Atual é $BRANCH_ATUAL"
alerta "Iniciando compilação de: $CAMINHO_CLIENTE_SOURCE"

alerta "Compilando model em: $CAMINHO_MODEL_PROJETO"
cd $CAMINHO_MODEL_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh
alerta "Compilando webApp em: $CAMINHO_WEBAPP_PROJETO"
cd $CAMINHO_WEBAPP_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh
if $ATUALIZAR_REQUISITO ; then
	alerta "Compilando requisitos em: $CAMINHO_WEBAPP_REQUISITO_PROJETO"
	cd $CAMINHO_WEBAPP_REQUISITO_PROJETO
	source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh

fi
alerta "Definindo variáveis de Diretóros das pastas Targets"
listagemWebApp=$CAMINHO_WEBAPP_TARGET/*.war
listagemWebAppRequisito=$CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/*.war
alerta "Verificando existencia do War para WebApp"
if ! ls $listagemWebApp >/dev/null
then alerta "O arquivo war não foi encontrado em $listagemWebApp  "
	exit $E_BADARGS
fi
if $ATUALIZAR_REQUISITO ; then
	alerta "Verificando existencia do War para requisitos"
	if ! ls $listagemWebAppRequisito >/dev/null
	then
		alerta "O arquivo war não foi encontrado em $listagemWebApp  "
		exit $E_BADARGS
	fi
fi
alerta "Verificando existencia do Jar de modelagem"
listagemModel=$CAMINHO_MODEL_TARGET/*.jar
if ! ls $listagemModel >/dev/null
then
	alerta "o arquivo model não foi encontrado $listagemModel  "
	exit $E_BADARGS
fi


cd $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO

alerta "Atualizando repositório para evitar Merge  (git pull)"
git pull


alerta "Listando e armazenando nomes de arquivos do projeto encontrado"
cd $CAMINHO_WEBAPP_TARGET
i=0
while read line
do
	webappfile[ $i ]="$line"        
	(( i++ ))
done < <(ls *.war )

ARQUIVO_WEBAAP="${webappfile[0]}"
alerta "Encontrado arquivo: $ARQUIVO_WEBAAP"

if $ATUALIZAR_REQUISITO ; then
	cd $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET
	i=0
	while read line
	do
		webappfile[ $i ]="$line"        
		(( i++ ))
	done < <(ls *.war )
	alerta ${webappfile[0]}

	ARQUIVO_WEBAAP_REQUISITO="${webappfile[0]}"
	alerta "Encontrado arquivo: $ARQUIVO_WEBAAP_REQUISITO"
fi

# LISTANDO ARQUIVOS JAR NA PASTA TARGET E ARMAZENANDO EM VARIAVEL
cd $CAMINHO_MODEL_TARGET
y=0
while read arqlistado
do
	modelfile[ $y ]="$arqlistado"        
	(( y++ ))
done < <(ls *.jar )
ARQUIVO_MODEL=${modelfile[0]}
alerta "Encontrado arquivo: $ARQUIVO_MODEL"


# TODO EM VARIAVEIS GIT ALTERAR NOM_PROJETO PARA NOME GRUPO PROJETO
NOME_GRUPO_PROJETO=$NOME_PROJETO
if $ATUALIZAR_REQUISITO ; then

	alerta "Lendo $CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop (Para cópia de script de homologacao) "

	if [ ! -f "$CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop" ]
	then
		echo "O Arquivo req_SBProjeto.prop não foi encontrada na pasta raiz do projeto, execute um teste do projeto WebApp para que o arquivo seja criado automaticamente.  "
		exit $E_BADARGS
	fi
	alerta  "importando variaveis do projeto Requisitos"
	source $CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop
	cp  $CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop  $CAMINHO_RELEASE/$NOME_PROJETO/ -f
	alerta  "copiando arquivos de banco de dados do requisito"
	cp $CAMINHO_SOURCE_PROJETO/$NOME_BANCO.Homologacao.sql $CAMINHO_RELEASE/$NOME_PROJETO/javaee_app -f
fi
if [ ! -e "$CAMINHO_SOURCE_PROJETO/SBProjeto.prop" ]
then
	alerta "O Arquivo SBProjeto.prop não foi encontrada na pasta raiz do projeto, execute um teste do projeto WebApp para que o arquivo seja criado automaticamente.  "
	exit $E_BADARGS
fi

alerta  "importando variaveis do projeto em $CAMINHO_SOURCE_PROJETO/SBProjeto.prop"
source $CAMINHO_SOURCE_PROJETO/SBProjeto.prop
alerta "Copiando arquivo de variaveis do projeot para repositorio"
cp  $CAMINHO_SOURCE_PROJETO/SBProjeto.prop  $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/ -f

echo "criando subdiretorios na pasta release"
mkdir $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/javaee_app -p
mkdir  $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/javaee_requisitoweb -p

alerta "copiando arquivos de banco de dados"
cp $CAMINHO_SOURCE_PROJETO/$NOME_BANCO.Homologacao.sql $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/javaee_app -f

#COPIANDO PARA PASTA DE IMPLANTAÇÃO
alerta "copiando war WebApp "
alerta " de: $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP"
alerta "para $CAMINHO_RELEASE/$NOME_PROJETO/javaee_app/$NOME_GRUPO_PROJETO.war"

cp $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/javaee_app/$NOME_GRUPO_PROJETO.war -f

alerta "copiando jar model "
alerta " de  $CAMINHO_MODEL_TARGET/$ARQUIVO_MODEL "
alerta "para $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_GRUPO_PROJETO.war"
cp $CAMINHO_MODEL_TARGET/$ARQUIVO_MODEL  $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/$NOME_GRUPO_PROJETO.jar -f
alerta "copiando informações do cliente para repositório"
alerta "de   $CAMINHO_CLIENTE_RELEASE/cliente.info"
alerta "para $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO"
cp $CAMINHO_CLIENTE_RELEASE/cliente.info  $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO
if $ATUALIZAR_REQUISITO ; then
	alerta "copiando de "
	alerta " de: $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/$ARQUIVO_WEBAAP_REQUISITO"
	alerta "para $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/javaee_requisitoweb/$NOME_GRUPO_PROJETO.req.war"
	cp $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/$ARQUIVO_WEBAAP_REQUISITO $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/javaee_requisitoweb/$NOME_GRUPO_PROJETO.req.war -f
fi
alerta "preparando para enviar o repositório para o servidor em $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO"
publicarCIColetivojava=true
if [ -d "$CAMINHO_WEBAPP_PROJETO/src/main/resources/deploy" ] 
then
    alerta "Arquivos de personalização de implantação foram encontrados, executando sequencia para publicação" 
    cp $CAMINHO_WEBAPP_PROJETO/src/main/resources/deploy/* $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/deploy/$BRANCH_ATUAL -f -R
    #Arquivo war recem compílado
    cp $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/javaee_app/* $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/deploy/$BRANCH_ATUAL -f	

#    cp $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/deploy/Dockerfile $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/deploy/$BRANCH_ATUAL -f
    cd $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/deploy/$BRANCH_ATUAL
    echo "compilando imagem em $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/deploy/$BRANCH_ATUAL"
    if test -f $CAMINHO_WEBAPP_PROJETO/src/main/resources/deploy/publicar.sh; then
     alerta "Publicando aplicativo com chamada personalizada via "
     $publicarCIColetivojava=false
    source $CAMINHO_WEBAPP_PROJETO/src/main/resources/deploy/publicar.sh $BRANCH_ATUAL

    else
        echo "enviando arquivos DockerFile para publicação no serividor"
        rsync -avzh --exclude='*/.git'  -e "ssh -p 667" $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/deploy/$BRANCH_ATUAL/* root@casanovadigital.com.br:/opt/traefik/configServidor/jenkins/workspace/javee_files/$NOME_GRUPO_PROJETO/javaee_app

    fi
    
else 
	
cd $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO

alerta "O sistema irá enviar o DockerFile para o servidor de distribuição"
echo "enviando arquivos DockerFile para publicação no serividor"
rsync -avzh --exclude='*/.git'  -e "ssh -p 667" $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/*   root@casanovadigital.com.br:/opt/traefik/configServidor/jenkins/workspace/javee_files/$NOME_GRUPO_PROJETO/

fi

alerta "***************************ATENÇÃO ********************************
  A imagem foi publicada
 ***************************ATENÇÃO ********************************"






