#!/bin/bash
ARGUMENTOS_ESPERADOS=2
diretorioChamada=$1
nomeScript=$2
# Verificando se o o Cliente e o Projeto foram enviados
echo "Executando $nomeScript em $diretorioChamada"
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  echo "Especifique o diretorio de chamada e o nome do Script $0 ;) "
  exit $E_BADARGS
fi

alerta "nome Script: $nomeScript"
alerta "diretorio: $diretorioChamada"
source /home/superBits/superBitsDevOps/core/coreSBBash.sh
#Carregando variaveis de ambiente
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $diretorioChamada $nomeScript

# executa comandos de acordo com o script

cd $diretorioChamada

source /home/superBits/superBitsDevOps/devOpsProjeto/$nomeScript


echo "Comando executado com sucesso"



