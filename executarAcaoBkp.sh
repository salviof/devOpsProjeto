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
#Carregando variaveis de ambiente
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $diretorioChamada $nomeScript

# executa comandos de acordo com o script
case "$nomeScript" in
 publicar*)	
  	source /home/superBits/superBitsDevOps/devOpsProjeto/$nomeScript   $diretorioChamada $nomeScript
 ;;
 *) 
echo "default"

  for proj in "${CAMINHOS_EXECUCAO[@]}"
  do
  echo "Executando $SCRIPT_COM_ACOES comandos em $proj "  
  cd $proj	
	for pScript in "${SCRIPTS_COM_ACOES[@]}"
	do
	 echo "executando $pScript"
 	 source /home/superBits/superBitsDevOps/devOpsProjeto/$pScript
	done
  done


 ;;	
esac



echo "Comando executado com sucesso"



