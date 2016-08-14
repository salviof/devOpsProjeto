#Cabeçalho Scripts Maven Git (deve constar em todos)
##############################################################################################################
ARGUMENTOS_ESPERADOS=1
# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  echo "O script precisa saber o diretorio do projeto $0 ;) "
echo "Este script utiliza caminho relativo a base do projeto, você precisa chama-lo atravez da base.. $0 ;) "
  exit $E_BADARGS
fi
DIRETORIO_PROJETO=$1
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS.sh
source $ARQUIVO_TRABALHO_USUARIO
source $/home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $DIRETORIO_PROJETO
###############################################################################################################
cd $DIRETORIO_PROJETO

mvn install
