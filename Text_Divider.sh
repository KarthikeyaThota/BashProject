#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [-h] [-s separator] input_file"
    echo "Options:"
    echo "  -h         Display this help message."
    echo "  -s         Specify a custom word separator (default is space)."
    echo "Input_file: Text file to process."
    exit 1
}

# Initialize default values
separator=" "  # Default word separator is space

# Parse command line options
while getopts "hs:" opt; do
    case $opt in
        h)
            usage
            ;;
        s)
            separator="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
    esac
done

# Remove processed options from the argument list
shift $((OPTIND-1))

# Check for missing or invalid arguments
if [ $# -eq 0 ]; then
    echo "Error: Missing input_file argument."
    usage
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: The specified input file does not exist."
    exit 1
fi

# Create a directory to store the output files
output_dir="output_files"
mkdir -p "$output_dir"

# Use a regular expression to split the input file into words and create separate files
awk -v separator="$separator" '{
    for (i = 1; i <= NF; i++) {
        filename = "output_files/word" i ".txt"
        print $i > filename
    }
}' "$input_file"

# Provide feedback to the user
echo "Input file '$input_file' has been divided into separate word files in the 'output_files' directory."

# Change file permissions of the output directory (optional)
chmod -R 755 "$output_dir"

# List directory contents (optional)
ls "$output_dir"

