

#Para cada pasta do servidor de git, projetos 
while read linha
do
    projetos[ $idx ]="$linha"        
    (( idx++ ))
done < <(ls ~/projetos/)
cd /home
for proj in "${projetos[@]}"
do
   :
# Faz um Git clone do repositorio na pasta publicados
mkdir ~/publicados/ -p
cd ~/publicados
git clone ~/projetos/$proj
cd ~/projetos/$proj
git pull orign master

#Lê as informacoes do cliente (contendo o endereço do site que será homologado)
source ~/publicados/$proj/cliente.info

# Adiciona o contecto no Jetty	
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?> "> ~/servidor/jetty9/webapps/$proj.xml
echo " <Configure class=\"org.eclipse.jetty.webapp.WebAppContext\"> " >>  ~/servidor/jetty9/webapps/$proj.xml
echo "   <Set name=\"contextPath\">/</Set> " >>  ~/servidor/jetty9/webapps/$proj.xml
echo "   <Set name=\"war\">/home/git/publicados/$proj/$proj.war</Set> " >>  ~/servidor/jetty9/webapps/$proj.xml
echo "   <Set name=\"virtualHosts\">            " >>  ~/servidor/jetty9/webapps/$proj.xml
echo "     <Array type=\"java.lang.String\">    " >>  ~/servidor/jetty9/webapps/$proj.xml
echo "       <Item>$SERVIDOR_HOMOLOGACAO</Item>  " >>  ~/servidor/jetty9/webapps/$proj.xml
echo "     </Array>  " >>  ~/servidor/jetty9/webapps/$proj.xml
echo "   </Set> " >>  ~/servidor/jetty9/webapps/$proj.xml
echo " </Configure> " >>  ~/servidor/jetty9/webapps/$proj.xml

   echo $arq
done

# Dropa o banco superCompras (comando temporario)
mysqladmin processlist -u root superCompras | \
awk '$2 ~ /^[0-9]/ {print "KILL "$2";"}' | \
mysql -u root 
mysqladmin -u root   drop superCompras -f









