ARGUMENTOS_ESPERADOS=1
# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  echo "Especifique o modulo do projeto $0 ;) "
echo "Este script utiliza caminho relativo a base do projeto, você precisa chama-lo atravez da base.. $0 ;) "
  exit $E_BADARGS
fi

cp -rf /home/superBits/superBitsDevOps/devOpsProjeto/comandosRaizProjeto/* $1 

