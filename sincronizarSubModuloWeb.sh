echo "executando init dos submodulos (caso ainda não tenha sido excutados)"
git checkout master  && git pull --ff origin master
git submodule sync
git submodule init
git submodule update
git submodule foreach "(git checkout master && git pull --ff origin master && git push origin master) || true"

