echo "executando init dos submodulos (caso ainda não tenha sido excutados")
git submodule update --init --recursive
echo "Baixando versão atualizada com pull orign master"
git submodule foreach git pull origin master
echo "Executando push dos submodulos"
git submodule push --recursive

