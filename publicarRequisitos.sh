#!/bin/bash
ARGUMENTOS_ESPERADOS=2
diretorioChamada=$1
nomeScript=$2

source /home/superBits/superBitsDevOps/core/coreSBBash.sh


# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
	alerta "Especifique o nome do cliente, e do projeto $0 ;) "
	exit 0
fi

alerta "Carregando variaveis de ambiente"
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $diretorioChamada $nomeScript
source $CAMINHO_RELEASE/cliente.info



alerta "

***************************ATENÇÃO*********************************************

Este script irá atualizar o Requisito do projeto $NOME_PROJETO  


*******************************************************************************
"
pause

arqSairSePastaNaoExistir $CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/servidorRequisito/ "a pasta de servidorRequisito não foi encontrada"

cd $CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/servidorRequisito/

alerta "Compilando Requisitos"

source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh

arqSairSePastaNaoExistir  $CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/servidorRequisito/target "a pasta target não foi encontrada"

cd $CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/servidorRequisito/target

i=0
while read line
do
        pacoteServidores[ $i ]="$line"
        (( i++ ))
done < <(ls *one-jar.jar)



PACOTE_SERVIDOR="${pacoteServidores[0]}"

if [ "${#PACOTE_SERVIDOR}" -le 1 ]
then
   alerta "O pacote do servidor não foi encontrado, é provavel que tenha ocorrido um problema ao compilar o projeto"
   exit 0;
fi



alerta "arquivo encontrado: $PACOTE_SERVIDOR"

ARQUIVO_REQUISITO_ORIGEM=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/servidorRequisito/target/$PACOTE_SERVIDOR
ARQUIVO_REQUISITO_DESTINO=$CAMINHO_CLIENTE_RELEASE/$NOME_PROJETO/$NOME_PROJETO-srvRequisito.jar

alerta "copiando arquivo de $ARQUIVO_REQUISITO_ORIGEM $ARQUIVO_REQUISITO_DESTINO "
cp $ARQUIVO_REQUISITO_ORIGEM $ARQUIVO_REQUISITO_DESTINO

cd /usr/lib/systemd/system/

rsync -avz --exclude='*/.git'  -e "ssh -p 667" $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO-srvRequisito.jar git@casanovadigital.com.br:~/publicados/$NOME_GRUPO_PROJETO/

ssh git@casanovadigital.com.br -p 667 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/iniciaServidorRequisito.sh $NOME_PROJETO

