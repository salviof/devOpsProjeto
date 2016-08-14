

echo "Deletando pastas Targets do diretorio"
find . -name target -type d -exec rm -rf {} \;
echo "Baixando atualizações com git Pull"
git pull
echo "Adicionando laterações no Commit com add --all"
git add --all
echo "Adicionando laterações no Commit (Utilizando /home/superBits/$USER/tarefa.info para mensagem)"
git commit -m "Atualização atendendendo: $TRABALHO_ATUAL "
echo "Enviando atualizações para o servidor com push"
git push



