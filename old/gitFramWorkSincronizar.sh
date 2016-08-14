

cd /home/superBits/projetos/vip/source/superkompras/
find . -name target -type d -exec rm -rf {} \;

cd /home/superBits/projetos/Super_Bits/source/SuperBits_FrameWork/
find . -name target -type d -exec rm -rf {} \;
./sincronizaGit.sh 

cd /home/superBits/projetos/vip/source/superkompras/
find . -name target -type d -exec rm -rf {} \;


./sincronizaGit.sh







