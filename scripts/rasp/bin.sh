git clone git://github.com/hivesolutions/builds.git
cd builds/bin/rasp

cp *.tar.gz $PREFIX
cd $PREFIX
for file in *.gz; do
    tar -zxvf $file
    rm -f $file
done
