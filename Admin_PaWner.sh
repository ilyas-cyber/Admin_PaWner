#!/bin/bash

# Function to perform the curl request
scan_url() {
    local url="$1"
    local response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" -eq 200 ]; then
        echo "200 OK: $url"
    else
        echo "Not 200: $url - $response"
    fi
}

# Function to scan URLs with headers
scan_with_headers() {
    local url="$1"
    local header="$2"
    local response=$(curl -s -o /dev/null -w "%{http_code}" -H "$header" "$url")
    if [ "$response" -eq 200 ]; then
        echo "200 OK with header '$header': $url"
    else
        echo "Not 200 with header '$header': $url - $response"
    fi
}

# Main function to scan URLs
main() {
    # Base URL
    local base_url="$1"

    # Variations
    urls=(
        "$base_url"
        "$base_url/"
        "$base_url/."
        "$base_url/..;/"
        "$base_url/%2F"
        "$base_url/%2e%2e%2f"
        "$base_url/..%3b/"
        "$base_url/..%2f"
        "$base_url/%2e%2e/"
        "$base_url/%61dmin"
        "$base_url/%2Fadmin"
        "$base_url/.%2e"
        "$base_url/ "
        "$base_url/%20"
        "$base_url/%09"
        "$base_url/%0a"
        "https://192.168.1.1/admin"  # Replace with actual IP
        "http://$base_url/admin"
        "https://$base_url:8080/admin"
        "$base_url?test=1"
        "$base_url?"
        "$base_url#"
    )

    # HTTP headers variations
    headers=(
        "X-Original-URL: /admin"
        "X-Forwarded-For: 127.0.0.1"
        "X-Forwarded-Host: $base_url"
        "X-Host: $base_url"
    )

    # Loop through each URL variation
    for url in "${urls[@]}"; do
        scan_url "$url"
    done

    # Loop through each header variation
    for header in "${headers[@]}"; do
        scan_with_headers "$base_url" "$header"
    done
}

# Check if base URL is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: ./admin-url-scanner.sh <base_url>"
    exit 1
fi

# Run the main function
main "$1"
