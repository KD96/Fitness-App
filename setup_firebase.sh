#!/bin/bash

echo "============================================================="
echo "Configurando Firebase para FitnessApp"
echo "============================================================="

# Limpieza completa
echo "Limpiando proyecto..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf Pods
rm -f Podfile.lock
rm -rf FitnessApp.xcworkspace

# Copiar el bridging header a la ubicación correcta
echo "Copiando bridging header..."
cp FitnessApp/FitnessApp/FitnessApp-Bridging-Header.h FitnessApp/

# Instalar los pods
echo "Instalando dependencias con CocoaPods..."
pod install --repo-update --clean-install

echo "============================================================="
echo "Configuración completada. Ahora:"
echo "1. Abre FitnessApp.xcworkspace"
echo "2. Selecciona tu target FitnessApp → Build Settings"
echo "3. Busca 'Objective-C Bridging Header' y configúralo a:"
echo "   FitnessApp/FitnessApp-Bridging-Header.h"
echo "4. Busca 'Header Search Paths' y añade:"
echo "   $(inherited)"
echo "   \${PODS_ROOT}/Headers/Public"
echo "   \${PODS_ROOT}/FirebaseCore/FirebaseCore/Sources"
echo "5. Limpia y compila el proyecto"
echo "=============================================================" 