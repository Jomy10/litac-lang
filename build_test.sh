#!/bin/bash

BUILD_CMD="gcc %input% -o %output% -D_CRT_SECURE_NO_WARNINGS -I../include -L../lib -lm -lrt -lpthread %options% -ldl"
#set BUILD_CMD="tcc.exe %%input%% -o %%output%%  -D_CRT_SECURE_NO_WARNINGS -I../include -L../lib -llibtcc"


error_compiling() {
    echo ""
    echo "=========================================="
    echo "ERROR: Compiling litac compiler           "
    echo "=========================================="
    echo ""
    exit 1
}

error_tests() {
    echo ""
    echo "=========================================="
    echo "Test failures!"
    echo "=========================================="
    echo ""
    exit 4
}

run_tests() {
    echo "Compiling litaC tests..."

    cd ./bin
    ./litac_linux -verbose -strict -buildCmd "${BUILD_CMD}" -cFormat -profile -srcDir "../src" -outputDir "./" -output "litac_tests" "../test/test_suite.lita" -types "none" -debug -maxMemory 1GiB
    result=$?
    if [ $result -gt 0 ]; then
        error_compiling
    fi

    echo "Running litaC tests..."
    ./litac_tests
    result=$?

    echo "Result: " $result
    if [ $result -gt 0 ]; then
        error_tests
    fi

    echo Completed.
}
echo "Environment variable: ${LITAC_HOME}"
if [ -z "${LITAC_HOME}" ]; then
    echo ""
    echo "=========================================="
    echo "ERROR: It appears you do not have the 'LITAC_HOME' system variable defined.  Please make sure this is set to the home directory of litac"
    echo "=========================================="
    echo ""
    exit 2
else
    run_tests
fi
