find . -name target -type d -exec rm -rf {} \;

cd /home/superBits/projetos/vip/source/superkompras/model_regras/

mvn clean install  -Dmaven.test.skip=true

cd /home/superBits/projetos/vip/source/superkompras/webApp/
mvn clean install  -Dmaven.test.skip=true


