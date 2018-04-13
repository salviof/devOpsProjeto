#!/bin/bash
ARGUMENTOS_ESPERADOS=2

# Verificando se o o Cliente e o Projeto foram enviados
if [ $# -ne $ARGUMENTOS_ESPERADOS ]
then
	alerta "Especifique o nome do cliente, e do projeto $0 ;) "
	exit 0
fi

source /home/superBits/superBitsDevOps/core/coreSBBash.sh


DIRETORIO_EXECUCAO=$1
ARQUIVO_PROJETO=$2

FILENAME=${ARQUIVO_PROJETO%_##*/}
NOME_SERVICO=${FILENAME%%.*}  

arqSairSeArquivoNaoExistir "$DIRETORIO_EXECUCAO/$ARQUIVO_PROJETO" "O arquivo jar não foi encontrado em $DIRETORIO_EXECUCAO/$ARQUIVO_PROJETO"

alerta "O $NOME_SERVICO será instalado"

if arqArquivoExiste "/usr/lib/systemd/system/$NOME_SERVICO.service"; then 
alerta "Serivço já foi instalado"
fi

$ARQUIVO_CONFIG_SERVICO=/usr/lib/systemd/system/$NOME_SERVICO.service
if ! arqArquivoExiste "$ARQUIVO_CONFIG_SERVICO"; then
alerta "o serviço $NOME_SERVICO será instado"
echo "[Unit] " > $ARQUIVO_CONFIG_SERVICO
echo "Description=$NOME_SERVICO " >>  $ARQUIVO_CONFIG_SERVICO
echo "After=network.target  " >>  $ARQUIVO_CONFIG_SERVICO
echo "[Service]   " >>  $ARQUIVO_CONFIG_SERVICO
echo "Type=simple  " >>  $ARQUIVO_CONFIG_SERVICO
echo "WorkingDirectory=$DIRETORIO_EXECUCAO  " >>  $ARQUIVO_CONFIG_SERVICO
echo "ExecStart=/usr/java/latest/bin/java -jar $ARQUIVO_PROJETO  " >>  $ARQUIVO_CONFIG_SERVICO
fi
echo "Servico $NOME_SERVICO foi instalado"
service $NOME_SERVICO stop
service $NOME_SERVICO start



