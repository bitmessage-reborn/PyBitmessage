mkdir -p AppDir
echo '#!/bin/bash' > AppDir/AppRun
echo 'PYTHONPATH="$APPDIR/usr/lib/python2.7/site-packages/" LIBRARY_PATH="$APPDIR/usr/lib:$APPDIR/opt/qt-4.8.7/lib" LD_LIBRARY_PATH="$APPDIR/usr/lib" $APPDIR/usr/bin/python2.7 $APPDIR/usr/bin/pybitmessage' >> AppDir/AppRun
[ -f openssl-1.1.1n.tar.gz ] || wget https://www.openssl.org/source/openssl-1.1.1n.tar.gz
[ -f Python-2.7.18.tgz ] || wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
[ -f PyQt4_gpl_x11-4.12.3.tar.gz ] || wget https://www.riverbankcomputing.com/static/Downloads/PyQt4/4.12.3/PyQt4_gpl_x11-4.12.3.tar.gz
[ -f opensource-src-4.8.7.zip ] || wget https://download.qt.io/archive/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.zip
[ -f sip-4.19.25.tar.gz ] || wget https://www.riverbankcomputing.com/static/Downloads/sip/4.19.25/sip-4.19.25.tar.gz
[ -f six-1.16.0.tar.gz ] || wget https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz
[ -f setuptools-44.1.1.zip ] || wget https://files.pythonhosted.org/packages/b2/40/4e00501c204b457f10fe410da0c97537214b2265247bc9a5bc6edd55b9e4/setuptools-44.1.1.zip

tar xvzf openssl-1.1.1n.tar.gz
tar xvzf Python-2.7.18.tgz
tar xvzf PyQt4_gpl_x11-4.12.3.tar.gz
tar xvzf six-1.16.0.tar.gz
tar xvzf sip-4.19.25.tar.gz
unzip setuptools-44.1.1.zip
unzip -a qt-everywhere-opensource-src-4.8.7.zip

cd Python-2.7.18

./configure --prefix=$(pwd)/../AppDir/usr --enable-optimizations  --without-test

make $MAKEOPTS build_all
make altinstall

cd ../
rm -rf Python-2.7.18

cd openssl-1.1.1n

./config --prefix=$(pwd)/../AppDir/usr
make $MAKEOPTS
make install_sw

cd ../
rm -rf openssl-1.1.1n

cd setuptools-44.1.1

PYTHONPATH="${PYTHONPATH}:$(pwd)/../AppDir/usr/lib/python2.7/site-packages/" ../AppDir/usr/bin/python2.7 setup.py install --prefix=../AppDir/usr

cd ../
rm -rf setuptools-44.1.1

cd six-1.16.0

PYTHONPATH="${PYTHONPATH}:$(pwd)/../AppDir/usr/lib/python2.7/site-packages/" ../AppDir/usr/bin/python2.7 setup.py install --prefix=../AppDir/usr

cd ../
rm -rf six-1.16.0

cd sip-4.19.25

../AppDir/usr/bin/python2.7 configure.py --sip-module PyQt4.sip
make $MAKEOPTS
make install

cd ../
rm -rf sip-4.19.25

cd qt-everywhere-opensource-src-4.8.7

patch -p 1 -ruN < ../qt4-openssl-1.1.patch
patch -p 1 -ruN < ../disable-sslv3.patch
patch -p 1 -ruN < ../gcc9-qforeach.patch
patch -p 1 -ruN < ../cxx11.patch

OPENSSL_LIBS="-L$(pwd)/../AppDir/usr/lib/ -lssl -lcrypto" ./configure -prefix ../AppDir/opt/qt-4.8.7 -confirm-license -opensource -release -nomake demos -nomake examples -no-webkit -openssl-linked
gmake $MAKEOPTS
gmake install

cd ../
rm -rf qt-everywhere-opensource-src-4.8.7

cd PyQt4_gpl_x11-4.12.3

sed -i -e "/'PyQt4\.sip', '-f', sip_flags/s/'-f', //" configure-ng.py
../AppDir/usr/bin/python2.7 configure-ng.py --sip ../AppDir/usr/bin/sip --qmake ../AppDir/opt/qt-4.8.7/bin/qmake --confirm-license --no-sip-files --no-qsci-api --no-designer-plugin --no-python-dbus --verbose
make $MAKEOPTS
make install

cd ../

rm -rf PyQt4_gpl_x11-4.12.3

