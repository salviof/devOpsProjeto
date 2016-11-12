#!/bin/bash
ARGUMENTOS_ESPERADOS=2
diretorioChamada=$1
nomeScript=$2

# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  echo "Especifique o nome do cliente, e do projeto $0 ;) "
  exit $E_BADARGS
fi


#Carregando variaveis de ambiente
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $diretorioChamada $nomeScript

CAMINHO_WEBAPP_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/webApp
CAMINHO_WEBAPP_REQUISITO_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/webAppRequisitos
CAMINHO_MODEL_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/modelRegras

CAMINHO_WEBAPP_TARGET=$CAMINHO_WEBAPP_PROJETO/target
CAMINHO_MODEL_TARGET=$CAMINHO_MODEL_PROJETO/target
CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET=$CAMINHO_WEBAPP_REQUISITO_PROJETO/target
CAMINHO_SOURCE_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO

echo "compilando $CAMINHO_CLIENTE_SOURCE"
cd $CAMINHO_MODEL_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh
cd $CAMINHO_WEBAPP_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh
cd $CAMINHO_WEBAPP_REQUISITO_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh


listagemWebApp=$CAMINHO_WEBAPP_TARGET/*.war
listagemWebAppRequisito=$CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/*.war


if ! ls $listagemWebApp >/dev/null
        then echo "O arquivo war não foi encontrado em $listagemWebApp  "
  exit $E_BADARGS
fi



if ! ls $listagemWebAppRequisito >/dev/null
        then
 echo "O arquivo war não foi encontrado em $listagemWebApp  "
  exit $E_BADARGS
fi

listagemModel=$CAMINHO_MODEL_TARGET/*.jar
if ! ls $listagemModel >/dev/null
        then
  echo "o arquivo model não foi encontrado $listagemModel  "
  exit $E_BADARGS
fi




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

cd $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET
i=0
while read line
do
    webappfile[ $i ]="$line"        
    (( i++ ))
done < <(ls *.war )
echo ${webappfile[0]}

ARQUIVO_WEBAAP_REQUISITO="${webappfile[0]}"


# LISTANDO ARQUIVOS JAR NA PASTA TARGET E ARMAZENANDO EM VARIAVEL
cd $CAMINHO_MODEL_TARGET
y=0
while read arqlistado
do
    modelfile[ $y ]="$arqlistado"        
    (( y++ ))
done < <(ls *.jar )
ARQUIVO_MODEL=${modelfile[0]}

echo "copiando arquivos de banco de dados"
cp $CAMINHO_SOURCE_PROJETO/bancoHomologacao.sql $CAMINHO_RELEASE/$NOME_PROJETO/ -f
cp  $CAMINHO_SOURCE_PROJETO/SBProjeto.prop  $CAMINHO_RELEASE/$NOME_PROJETO/ -f


#COPIANDO PARA PASTA DE IMPLANTAÇÃO
echo "copiando de $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP"
echo "para $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.war"

cp $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.war -f

echo "copiando de $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/$ARQUIVO_WEBAAP_REQUISITO"
echo "para $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.req.war"
cp $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/$ARQUIVO_WEBAAP_REQUISITO $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.req.war -f

cp $CAMINHO_MODEL_TARGET/$ARQUIVO_MODEL  $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_PROJETO.jar -f
cp $CAMINHO_CLIENTE_RELEASE/cliente.info  $CAMINHO_RELEASE/$NOME_PROJETO

cd $CAMINHO_RELEASE/$NOME_PROJETO
git pull
git add --all 
git commit -m "Atualizavao versao $(date '+%d/%m/%Y %H:%M:%S')"
git push
ssh git@homologacao.superkompras.com.br 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/atualizarProjetos.sh


