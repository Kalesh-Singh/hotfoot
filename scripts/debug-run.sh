#! /bin/bash

flutter run --no-hot --pid-file pid.txt &> output.txt &
sleep 120
kill "$(< pid.txt)"
if grep -q "throw" output.txt; then
    echo "ERROR: "
    echo "$(< output.txt)"
    rm output.txt pid.txt
    exit 1
else
    echo "SUCCESS: "
    echo "$(<output.txt)"
    rm output.txt pid.txt
    exit 0
fi
