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



echo "Deletando pastas Targets do diretorio"
find . -name target -type d -exec rm -rf {} \;
echo "Baixando atualizações com git Pull"
git pull
echo "Adicionando laterações no Commit com add --all"
git add --all
echo "Adicionando laterações no Commit (Utilizando /home/superBits/$USER/tarefa.info para mensagem)"
git commit -m "Atualização atendendendo: $TRABALHO_ATUAL "
echo "Enviando atualizações para o servidor com push"
git push



