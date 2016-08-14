source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS.sh
source $ARQUIVO_TRABALHO_USUARIO
echo "Deletando pastas Targets do diretorio"
find . -name target -type d -exec rm -rf {} \;
echo "Baixando atualizações com git Pull"
git pull
echo "Adicionando laterações no Commit com add --all"
git add --all
echo "Adicionando laterações no Commit (Utilizando informações em $ARQUIVO_TRABALHO_USUARIO para mensagem)"
git commit -m "Atualização atendendendo: $TRABALHO_ATUAL "
echo "Enviando atualizações para o servidor com push"
git push
echo "Para garantir a sincronização, execute este comando até que não haja nada para ser sincronizado"



