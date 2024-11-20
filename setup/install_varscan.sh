threads=8
url=https://github.com/dkoboldt/varscan/releases/download/v2.4.6/VarScan.v2.4.6.jar

cd $(dirname $0)
wget $url
if [ $? -eq 0 ]; then
    ln -srf ./VarScan.v2.4.6.jar ../
fi
