#!/bin/bash
ARGUMENTOS_ESPERADOS=2
diretorioChamada=$1
nomeScript=$2

RESTORE='\033[0m'
function alerta() {
    mensagem="$1"
    echo -e -n "\033[1;36m$mensagem"   
    echo -en "${RESTORE}"
    echo " "
}






# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
  alerta "Especifique o nome do cliente, e do projeto $0 ;) "
  exit $E_BADARGS
fi

alerta "Carregando variaveis de ambiente"
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $diretorioChamada $nomeScript
source $CAMINHO_RELEASE/cliente.info

alerta "Verificando estrutura de diretorios"
CAMINHO_PASTA_CONFIG_GIT=$CAMINHO_RELEASE/$NOME_PROJETO/.git
if [ ! -d "$CAMINHO_PASTA_CONFIG_GIT" ]; then
  # PASTA DO CLIENTE NÃO EXISTE
echo "---"
alerta "A pasta do repositório reliase não contem o subdiretorio .git ou não existe"
alerta  "digite    -->SIM--< se deseja EXLUIR a pasta: [$CAMINHO_RELEASE/$NOME_PROJETO/]"
alerta "E CLONARr novamente via: $SERVIDOR_GIT_RELEASE"
read respostaUsuario


if [[ $respostaUsuario == "SIM" ]]
then
cd $CAMINHO_RELEASE
git clone $SERVIDOR_GIT_RELEASE
else
 alerta "Impossível subir sem um diretorio vinculado a um repositório git"
 exit $E_BADARGS
fi



fi





frase_chave="QUERO APAGAR TUDO"
alerta "

***************************ATENÇÃO*********************************************

Este script irá atualizar o projeto $NOME_PROJETO WebApp e os Requisitos 

Você pode:
pressionar ctr+c para cancelar
entar para subir
ou digitar $frase_chave para apagar tudo e instalar uma versão nova do banco de dados"
read respostaUsuario


if [[ $respostaUsuario == *"$frase_chave"* ]]
then 
alerta "
***************************ATENÇÃO - ULTIMO ALERTA ********************************

O BANCO DE DADOS DO SERVIDOR REMOTO SERÁ DESTRUIDO SEM BACKUP, 
em seguida o sistema vai subir o banco no estado inciial.

Para cancelar ctr+C

***************************PERIGO !*********************************************

"
else 
alerta "O banco de dados no servidor NÃÃOOO será destruído"
fi 



alerta "-> Escreva SIM caso queira atualizar também os requisitos do projeto
"
read respAtualizarRequisito
ATUALIZAR_REQUISITO=false
if [[ $respAtualizarRequisito == *"SIM"* ]]
then
ATUALIZAR_REQUISITO=true
fi

if $ATUALIZAR_REQUISITO ; then
  alerta "ATENÇÃO ----> O requisito será atualizado"
  else
  respAtualizarRequisito="NAO"
  alerta "O requisito NÃÃOOO será atualizado (o sim deve ser Maiusculo)" 
fi





alerta "Definindo variaveis de ambiente"
CAMINHO_WEBAPP_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/webApp
CAMINHO_WEBAPP_REQUISITO_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/webAppRequisitos
CAMINHO_MODEL_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO/modelRegras

CAMINHO_WEBAPP_TARGET=$CAMINHO_WEBAPP_PROJETO/target
CAMINHO_MODEL_TARGET=$CAMINHO_MODEL_PROJETO/target
CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET=$CAMINHO_WEBAPP_REQUISITO_PROJETO/target
CAMINHO_SOURCE_PROJETO=$CAMINHO_CLIENTE_SOURCE/$NOME_PROJETO

alerta "Iniciando compilação de: $CAMINHO_CLIENTE_SOURCE"

alerta "Compilando model em: $CAMINHO_MODEL_PROJETO"
cd $CAMINHO_MODEL_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh
alerta "Compilando webApp em: $CAMINHO_WEBAPP_PROJETO"
cd $CAMINHO_WEBAPP_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh

if $ATUALIZAR_REQUISITO ; then
alerta "Compilando requisitos em: $CAMINHO_WEBAPP_REQUISITO_PROJETO"
cd $CAMINHO_WEBAPP_REQUISITO_PROJETO
source /home/superBits/superBitsDevOps/devOpsProjeto/compilar.sh
fi


alerta "Definindo variáveis de Diretóros das pastas Targets"
listagemWebApp=$CAMINHO_WEBAPP_TARGET/*.war
listagemWebAppRequisito=$CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/*.war

alerta "Verificando existencia do War para WebApp"
if ! ls $listagemWebApp >/dev/null
        then alerta "O arquivo war não foi encontrado em $listagemWebApp  "
  exit $E_BADARGS
fi

if $ATUALIZAR_REQUISITO ; then
alerta "Verificando existencia do War para requisitos"
if ! ls $listagemWebAppRequisito >/dev/null
        then
 alerta "O arquivo war não foi encontrado em $listagemWebApp  "
  exit $E_BADARGS
fi
fi
alerta "Verificando existencia do Jar de modelagem"
listagemModel=$CAMINHO_MODEL_TARGET/*.jar
if ! ls $listagemModel >/dev/null
        then
  alerta "o arquivo model não foi encontrado $listagemModel  "
  exit $E_BADARGS
fi




alerta "Listando e armazenando nomes de arquivos do projeto encontrado"
cd $CAMINHO_WEBAPP_TARGET
i=0
while read line
do
    webappfile[ $i ]="$line"        
    (( i++ ))
done < <(ls *.war )

ARQUIVO_WEBAAP="${webappfile[0]}"
alerta "Encontrado arquivo: $ARQUIVO_WEBAAP"

if $ATUALIZAR_REQUISITO ; then
cd $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET
i=0
while read line
do
    webappfile[ $i ]="$line"        
    (( i++ ))
done < <(ls *.war )
alerta ${webappfile[0]}

ARQUIVO_WEBAAP_REQUISITO="${webappfile[0]}"
alerta "Encontrado arquivo: $ARQUIVO_WEBAAP_REQUISITO"
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
alerta "Encontrado arquivo: $ARQUIVO_MODEL"
#alerta "executando backup do servidor"
#ssh git@marketingparaweb.com.br 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/realizarBackup.sh $NOME_PROJETO $respAtualizarRequisito
#alerta "Fim Bakcup no servidor"
#alerta "Preparando repositorio para envio em $CAMINHO_RELEASE/$NOME_PROJETO"
#cd $CAMINHO_RELEASE/$NOME_PROJETO

# TODO EM VARIAVEIS GIT ALTERAR NOM_PROJETO PARA NOME GRUPO PROJETO
NOME_GRUPO_PROJETO=$NOME_PROJETO
if $ATUALIZAR_REQUISITO ; then

alerta "Lendo $CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop (Para cópia de script de homologacao) "

if [ ! -f "$CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop" ]
then
  echo "O Arquivo req_SBProjeto.prop não foi encontrada na pasta raiz do projeto, execute um teste do projeto WebApp para que o arquivo seja criado automaticamente.  "
  exit $E_BADARGS
fi
alerta  "importando variaveis do projeto Requisitos"
source $CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop
cp  $CAMINHO_SOURCE_PROJETO/req_SBProjeto.prop  $CAMINHO_RELEASE/$NOME_PROJETO/ -f
alerta  "copiando arquivos de banco de dados do requisito"
cp $CAMINHO_SOURCE_PROJETO/$NOME_BANCO.Homologacao.sql $CAMINHO_RELEASE/$NOME_PROJETO/ -f
fi

#git checkout -f
#git checkout --theirs -- .
#git checkout -f

#git pull origin master 



  
if [ ! -f "$CAMINHO_SOURCE_PROJETO/SBProjeto.prop" ]
then
  alerta "O Arquivo SBProjeto.prop não foi encontrada na pasta raiz do projeto, execute um teste do projeto WebApp para que o arquivo seja criado automaticamente.  "
  exit $E_BADARGS
fi

alerta  "importando variaveis do projeto em $CAMINHO_SOURCE_PROJETO/SBProjeto.prop"
source $CAMINHO_SOURCE_PROJETO/SBProjeto.prop
alerta "Copiando arquivo de variaveis do projeot para repositorio"
cp  $CAMINHO_SOURCE_PROJETO/SBProjeto.prop  $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/ -f

alerta "copiando arquivos de banco de dados"
cp $CAMINHO_SOURCE_PROJETO/$NOME_BANCO.Homologacao.sql $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/ -f

#COPIANDO PARA PASTA DE IMPLANTAÇÃO
alerta "copiando war WebApp "
alerta " de: $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP"
alerta "para $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_GRUPO_PROJETO.war"

cp $CAMINHO_WEBAPP_TARGET/$ARQUIVO_WEBAAP $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/$NOME_GRUPO_PROJETO.war -f

alerta "copiando jar model "
alerta " de  $CAMINHO_MODEL_TARGET/$ARQUIVO_MODEL "
alerta "para $CAMINHO_RELEASE/$NOME_PROJETO/$NOME_GRUPO_PROJETO.war"

cp $CAMINHO_MODEL_TARGET/$ARQUIVO_MODEL  $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/$NOME_GRUPO_PROJETO.jar -f


alerta "copiando informações do cliente para repositório"
alerta "de   $CAMINHO_CLIENTE_RELEASE/cliente.info"
alerta "para $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO"

cp $CAMINHO_CLIENTE_RELEASE/cliente.info  $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO

if $ATUALIZAR_REQUISITO ; then
alerta "copiando de "
alerta " de: $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/$ARQUIVO_WEBAAP_REQUISITO"
alerta "para $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/$NOME_GRUPO_PROJETO.req.war"
cp $CAMINHO_WEBAPP_REQUISITO_PROJETO_TARGET/$ARQUIVO_WEBAAP_REQUISITO $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO/$NOME_GRUPO_PROJETO.req.war -f
fi

alerta "preparando para enviar o repositório para o servidor em $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO"





cd $CAMINHO_RELEASE/$NOME_GRUPO_PROJETO



alerta "git add --all"
git add --all 
alerta "git commit"
git commit -m "Atualizavao versao $(date '+%d/%m/%Y %H:%M:%S')"
alerta "git push origin master"
git push origin master -f
alerta "git push origin master"
git push origin master 

alerta "Operações locais realizadas com sucesso, executando atualizações no servidor $NOME_GRUPO_PROJETO"

<<<<<<< HEAD

ssh git@marketingparaweb.com.br 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/atualizarProjeto.sh $NOME_GRUPO_PROJETO $respAtualizarRequisito

if [[ $respostaUsuario == *"$frase_chave"* ]]
then 
=======
ssh git@marketingparaweb.com.br 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/atualizarProjeto.sh $NOME_PROJETO $respAtualizarRequisito

if [[ $respostaUsuario == *"$frase_chave"* ]]
then 
ssh git@marketingparaweb.com.br 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/criarBancoDeDados.sh $NOME_PROJETO

fi 
>>>>>>> 313aa7cff9de085cdf1da560547929741bc43202

ssh git@marketingparaweb.com.br 'bash -s' < /home/superBits/superBitsDevOps/SCRIPTS_SERVIDOR/criarBancoDeDados.sh $NOME_GRUPO_PROJETO
fi
