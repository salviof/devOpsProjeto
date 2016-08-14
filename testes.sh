source /home/superBits/superBitsDevOps/VARIAVEIS/SB_VARIAVEIS_MAVEN_GIT.sh $1
for proj in "${CAMINHOS_EXECUCAO[@]}"
do
  echo "Executando comando git em $proj "  
  cd $proj	
  source /home/superBits/superBitsDevOps/devOpsProjeto/$SCRIPT_COM_ACOES
done
echo $CAMINHOS_FRAMEWORK
echo "fim teste"
