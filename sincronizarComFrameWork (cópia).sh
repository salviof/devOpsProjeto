find . -name target -type d -exec rm -rf {} \;

git pull
git add --all
git commit -m "Atualizacao automática"
git push


git checkout master  && git pull --ff origin master

git submodule sync
git submodule init
git submodule update
git submodule foreach "(git checkout master && git pull --ff origin master && git push origin master) || true"

for i in $(git submodule foreach --quiet 'echo ./')
do
  echo "Adding $i to root repo"
  git add "$i"
done

git commit -m "Updated master branch of deployment repo to point to latest head of submodules"
git push origin master



cd webApp/src/main/webapp/resources/SBComp/
./sincroniza.sh

