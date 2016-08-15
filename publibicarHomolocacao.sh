ARGUMENTOS_ESPERADOS=2
targetMavenWebapp=$1
targetMavenModel=$2
# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  echo "Especifique o nome do cliente, e do projeto $0 ;) "
  exit $E_BADARGS
fi


# LISTANDO ARQUIVOS WAR NA PASTA TARGET E ARMAZENANDO EM VARIAVEL
cd $targetMavenWebapp
i=0
while read line
do
    webappfile[ $i ]="$line"        
    (( i++ ))
done < <(ls *.war )
echo ${webappfile[0]}
ARQUIVO_WEBAAP="${webappfile[0]}"

if [! -f "$ARQUIVO_WEBAAP" ]
then
  echo "o Arquivo Webb App não foi gerado em "
  exit $E_BADARGS
fi


# LISTANDO ARQUIVOS JAR NA PASTA TARGET E ARMAZENANDO EM VARIAVEL
cd $targetMavenModel
y=0
while read arqlistado
do
    modelfile[ $y ]="$arqlistado"        
    (( y++ ))
done < <(ls *.jar )
ARQUIVO_MODEL=${modelfile[0]}


if [! -f "$ARQUIVO_WEBAAP" ]
then
  echo "o Arquivo Webb App não foi gerado em $targetMavenModel $ARQUIVO_MODEL"
  exit $E_BADARGS
fi



#COPIANDO PARA PASTA DE IMPLANTAÇÃO
ssh git@homologacao.superkompras.com.br 'bash -s' < /home/superBits/superBitsDevOps/devOpsProjeto/scriptHomologacaoServer.sh

