DIRETORIO_PROJETO=`pwd`
DIRETORIO_WEBAPP_SERVLET=$DIRETORIO_PROJETO/src/main/webapp
DIRETORIO_RESOURCES=$DIRETORIO_PROJETO/src/main/webapp/resources
if [ ! -d $DIRETORIO_WEBAPP_SERVLET ]; then
  echo "Diretorio webApp não existe, certifique que este é um projeto web"
  exit 1
fi
if [ ! -d $DIRETORIO_WEBAPP_SERVLET ]; then
  echo "Diretorio resources não existe, certifique que este é um projeto web"
  exit 1
fi

cd /home/resources/SBComp
./sincronizar.sh
cd /home/resources/WEB-INF
./sincronizar.sh

rsync -Cravzp --exclude='*/.git' --exclude='*/target' /home/resources/SBComp  $DIRETORIO_WEBAPP_SERVLET
rsync -Cravzp --exclude='*/.git' --exclude='*/target' /home/resources/WEB-INF  $DIRETORIO_WEBAPP_SERVLET

#cd resources

