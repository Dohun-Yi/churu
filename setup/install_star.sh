threads=8
architecture=$(uname -m)

cd $(dirname $0)
git clone https://github.com/alexdobin/STAR.git
cd ./STAR/source/
if [ "$architecture" == "x86_64" ]; then
    make STAR -j $threads
else
    make STAR CXXFLAGS_SIMD="-march=native -mtune=neoverse-n1 -O3" -j $threads
fi
if [ $? -eq 0 ]; then
    ln -srf STAR ../../../
fi
