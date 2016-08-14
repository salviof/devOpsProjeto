
source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS.sh
source $ARQUIVO_TRABALHO_USUARIO
echo "Deletando pastas Targets do diretorio"
find . -name target -type d -exec rm -rf {} \;
echo "Baixando atualizações com git Pull"
git pull

