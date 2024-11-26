#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Check if the required predict.zip file exists
if [ ! -f "predict.zip" ]; then
    echo "Error: predict.zip not found in /app. Please mount it to /app/predict.zip."
    exit 1
fi

# Unzip the predict.zip
echo "Unzipping predict.zip..."
unzip -o predict.zip

# Check if the predict script exists and is executable
if [ ! -x "./predict" ]; then
    echo "Error: predict script not found or not executable in predict.zip."
    exit 1
fi

# Handle subcommands
case "$1" in
    predict)
        # Shift the first argument and pass the rest to the predict script
        shift
        ./predict "$@"
        ;;
    test)
        # Run a series of tests on the predict script
        echo "Running tests on the predict script..."

        # Test 2: Run the script with valid intervals and check output format
        intervals=(1 24 72)
        fips_codes=("06001" "08013" "12001" "18105" "25017" "26161" "37063" "41039" "42027" "55025")


        for interval in "${intervals[@]}"; do
            echo "Testing interval: $interval"

            # Measure execution time
            start_time=$(date +%s)
            output=$(./predict "$interval")
            end_time=$(date +%s)
            elapsed_time=$((end_time - start_time))

            # Ensure execution time is within the limit
            if [[ "$elapsed_time" -gt 60 ]]; then
                echo "Error: Execution time exceeded 60 seconds for interval $interval."
                exit 1
            else
                echo "Execution time: $elapsed_time seconds"
            fi

            # Ensure the output has the correct CSV header
            header=$(echo "$output" | head -n 1)
            if [[ "$header" != "fips,pred" ]]; then
                echo "Error: Output must have a header 'fips,pred'."
                exit 1
            fi

            # Count the number of rows in the CSV
            row_count=$(echo "$output" | tail -n +2 | wc -l)
            if [[ "$row_count" -ne 10 ]]; then
                echo "Error: Output must have 10 rows of predictions (excluding the header)."
                exit 1
            fi

            # Validate FIPS codes in the output
            actual_fips=$(echo "$output" | tail -n +2 | cut -d',' -f1 | sort)
            expected_fips=$(printf "%s\n" "${fips_codes[@]}" | sort)
            if [[ "$actual_fips" != "$expected_fips" ]]; then
                echo "Error: Output FIPS codes do not match the expected list."
                exit 1
            fi
        done

        echo "All tests passed!"
        ;;
    *)
        echo "Usage: $0 {predict <interval>|test}"
        exit 1
        ;;
esac
