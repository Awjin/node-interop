#!/bin/bash

set -e

cd "$1"

echo "> entered package $1"
echo '> pub get ================================================================'
pub get

if [ -f "package.json" ]; then
    echo '> npm install ============================================================'
    npm install
fi

if [ "$2" == "node" ]; then
    echo "> pub run build_runner test (dartdevc) ============================="
    pub run build_runner test --output=build/ -- -r expanded

    rm -rf .dart_tool/build/
    rm -rf build/

    echo "> pub run build_runner test (dart2js) ============================="
    pub run build_runner test --define="build_node_compilers|entrypoint=compiler=dart2js" --output=build/ -- -r expanded
else
    echo "> pub run test -r expanded ==============================================="
    pub run test -r expanded
fi


echo "> dartfmt -n --set-exit-if-changed . ====================================="
dartfmt -n --set-exit-if-changed .

echo "> dartanalyzer --fatal-infos --fatal-warnings . =========================="
dartanalyzer --fatal-infos --fatal-warnings .
