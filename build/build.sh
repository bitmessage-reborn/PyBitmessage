[ -f ./appimagetool ] || wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage -O appimagetool
chmod +x appimagetool

cd ../

build/AppDir/usr/bin/python2.7 setup.py install --prefix=build/AppDir/usr

cd build/AppDir

ln -sf usr/share/applications/pybitmessage.desktop pybitmessage.desktop
ln -sf usr/share/icons/hicolor/scalable/apps/pybitmessage.svg pybitmessage.svg

cd ../

./appimagetool AppDir/
