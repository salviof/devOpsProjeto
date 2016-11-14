ARGUMENTOS_ESPERADOS=2
diretorioChamada=$1
nomeScript=$2

# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  echo "Especifique o nome do cliente, e do projeto $0 ;) "
  exit $E_BADARGS
fi


Carregando variaveis de ambiente
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $diretorioChamada $nomeScript
CAMINHO_WEBAPP_TARGET=$CAMINHO_CLIENTE_SOURCE/webApp/target
CAMINHO_MODEL_TARGET=$CAMINHO_CLIENTE_SOURCE/modeRegras/target
cd $CAMINHO_CLIENTE_SOURCE/modelRegras 
#source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh
cd $CAMINHO_CLIENTE_SOURCE/webApp
#source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh


echo "Como vc pode ver as variaveis estão acessiveis!!! $CLIENTE"

# LISTANDO ARQUIVOS WAR NA PASTA TARGET E ARMAZENANDO EM VARIAVEL
cd $CAMINHO_WEBAPP_TARGET
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
cd $CAMINHO_MODEL_TARGET
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
echo "copiando de $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP"
echo "para $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.war"
cp $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.war
cp $CAMINHO_MODEL_TARGET/$ARQUIVO_MODEL  $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.jar

ssh git@homologacao.superkompras.com.br 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/atualizaProjeto.sh $NOME_PROJETO

