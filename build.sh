#!/bin/bash
set -e

echo "=========================================="
echo "  Andromeda v4.0 - Build Script"
echo "=========================================="
echo ""

if [ -z "$THEOS" ]; then
    echo "ERROR: THEOS environment variable not set."
    echo "Please install Theos first:"
    echo "  git clone --recursive https://github.com/theos/theos.git ~/theos"
    echo "  export THEOS=~/theos"
    exit 1
fi

echo "[1/4] Cleaning previous build..."
make clean 2>/dev/null || true

echo "[2/4] Building Andromeda framework..."
cd Andromeda.framework
make
cd ..

echo "[3/4] Building Andromeda dylib..."
cd Andromeda.dylib
make
cd ..

echo "[4/4] Building Settings bundle..."
cd AndromedaSettings.bundle
make
cd ..

echo ""
echo "=========================================="
echo "  Creating .deb package..."
echo "=========================================="

DEB_NAME="com.andromeda.bypass_4.0.0_iphoneos-arm.deb"
BUILD_DIR="build/deb"
DATA_DIR="$BUILD_DIR/data"
CONTROL_DIR="$BUILD_DIR/control"

rm -rf "$BUILD_DIR"
mkdir -p "$DATA_DIR/Library/Frameworks"
mkdir -p "$DATA_DIR/Library/MobileSubstrate/DynamicLibraries"
mkdir -p "$DATA_DIR/Library/PreferenceBundles"
mkdir -p "$DATA_DIR/Library/PreferenceLoader/Preferences"
mkdir -p "$CONTROL_DIR"

if [ -d "Andromeda.framework/obj" ]; then
    cp -r Andromeda.framework/obj/Andromeda.framework "$DATA_DIR/Library/Frameworks/" 2>/dev/null || true
fi

if [ -f "Andromeda.dylib/obj/Andromeda.dylib" ]; then
    cp Andromeda.dylib/obj/Andromeda.dylib "$DATA_DIR/Library/MobileSubstrate/DynamicLibraries/"
fi

if [ -f "Andromeda.dylib/Andromeda.plist" ]; then
    cp Andromeda.dylib/Andromeda.plist "$DATA_DIR/Library/MobileSubstrate/DynamicLibraries/"
fi

if [ -d "AndromedaSettings.bundle/obj/AndromedaSettings.bundle" ]; then
    cp -r AndromedaSettings.bundle/obj/AndromedaSettings.bundle "$DATA_DIR/Library/PreferenceBundles/"
fi

cat > "$DATA_DIR/Library/PreferenceLoader/Preferences/Andromeda.plist" << 'EOF'
{
    entry = {
        bundle = AndromedaSettings;
        cell = PSLinkCell;
        detail = AndromedaRootListController;
        icon = "/Library/PreferenceBundles/AndromedaSettings.bundle/Icons/icon.svg";
        isController = 1;
        label = Andromeda;
    };
}
EOF

cp layout/DEBIAN/control "$CONTROL_DIR/control"
cp layout/DEBIAN/postinst "$CONTROL_DIR/postinst" 2>/dev/null || true
cp layout/DEBIAN/postrm "$CONTROL_DIR/postrm" 2>/dev/null || true
chmod 755 "$CONTROL_DIR/postinst" 2>/dev/null || true
chmod 755 "$CONTROL_DIR/postrm" 2>/dev/null || true

cd "$BUILD_DIR"

echo "2.0" > debian-binary

tar -czf control.tar.gz -C control .
tar -czf data.tar.gz -C data .

ar rcs "$DEB_NAME" debian-binary control.tar.gz data.tar.gz

mv "$DEB_NAME" ../../

cd ../..

echo ""
echo "=========================================="
echo "  BUILD COMPLETE!"
echo "=========================================="
echo "  Package: $DEB_NAME"
echo "  Location: $(pwd)/$DEB_NAME"
echo "=========================================="
echo ""
echo "Install with:"
echo "  dpkg -i $DEB_NAME"
echo "  or"
echo "  apt install ./$DEB_NAME"
echo ""
