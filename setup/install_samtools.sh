threads=8

cd $(dirname $0)
wget https://github.com/samtools/samtools/releases/download/1.18/samtools-1.18.tar.bz2
tar xvf samtools-1.18.tar.bz2
cd samtools-1.18
./configure --without-curses
make -j $threads
if [ $? -eq 0 ]; then
    ln -srf ./samtools ../../
fi
