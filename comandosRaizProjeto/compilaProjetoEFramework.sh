DIRETORIO_PROJETO=`pwd` # significa: print working directory ;)
NOME_SCRIPT=${0##*/} 
echo "# my name ------------------>  "
echo "Executando $NOME_SCRIPT Projeto em: $DIRETORIO_PROJETO"
./devOpsProjeto/$NOME_SCRIPT $DIRETORIO_PROJETO
