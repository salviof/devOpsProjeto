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

"
pause




