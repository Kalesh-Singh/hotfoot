#! /bin/bash

flutter run --no-hot --pid-file pid.txt &> output.txt &
sleep 600
kill "$(< pid.txt)"

call_stack=$( grep "call stack" output.txt)
error=$( grep "error" output.txt )

if [ -n "$call_stack" ] || [ -n "$error" ]; then
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