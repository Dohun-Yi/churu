threads=8

cd $(dirname $0)
git clone https://github.com/lh3/bwa.git
cd bwa
make -j $threads
if [ $? -eq 0 ]; then
    ln -srf ./bwa ../../
fi
