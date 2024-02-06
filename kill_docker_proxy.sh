#!/bin/bash

# Run the ps command and filter the output for docker-proxy processes
process_ids=$(ps aux | grep "docker-proxy" | grep -v grep | awk '{print $2}')

# Check if any processes were found
if [ -z "$process_ids" ]; then
    echo "No docker-proxy processes running."
else
    echo "Killing docker-proxy processes..."
    # Iterate over each process id, print it, and then kill it
    for pid in $process_ids; do
        echo "Killing process with PID: $pid"
        sudo kill $pid
    done
    echo "Docker-proxy processes killed."
fi
