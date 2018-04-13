DIRETORIO_PROJETO=`pwd` # significa: print working directory ;)
NOME_SCRIPT=${0##*/} 
ARQUIVO=$1
echo "Executando $NOME_SCRIPT Projeto em: $DIRETORIO_PROJETO"
/home/superBits/superBitsDevOps/devOpsProjeto/criarServicoJar.sh $DIRETORIO_PROJETO $1
