
ARGUMENTOS_ESPERADOS=1
# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  echo "O script precisa saber o diretorio do projeto $0 ;) "
echo "Este script utiliza caminho relativo a base do projeto, você precisa chama-lo atravez da base.. $0 ;) "
  exit $E_BADARGS
fi

DIRETORIO_PROJETO=$1

cd $DIRETORIO_PROJETO

git submodule update --init --recursive
git submodule foreach git pull origin master
git submodule push --init --recursive

