#!/bin/bash

# Colocar el archivo de bridging header en la ruta correcta
cp FitnessApp/FitnessApp/FitnessApp-Bridging-Header.h FitnessApp/

# Limpiar la carpeta DerivedData 
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Ejecutar pod install para asegurar que todas las dependencias están correctamente configuradas
pod install

echo "======================="
echo "Ahora puedes abrir el proyecto con:"
echo "open FitnessApp.xcworkspace"
echo "======================="
echo "Pasos manuales necesarios:"
echo "1. En Xcode, ve a tu target 'FitnessApp' → Build Settings"
echo "2. Busca 'Objective-C Bridging Header' y configúralo a 'FitnessApp/FitnessApp-Bridging-Header.h'"
echo "3. Busca 'Header Search Paths' y añade \${PODS_ROOT}/Headers/Public y \${PODS_ROOT}/FirebaseCore/FirebaseCore/Sources"
echo "4. Limpia y compila el proyecto (Cmd+Shift+K, luego Cmd+B)" 