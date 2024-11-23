#!/bin/bash

# Check if ANTHROPIC_API_KEY is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY environment variable is not set"
    echo "Please set it with: export ANTHROPIC_API_KEY='your-key-here'"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Please install it:"
    echo "  - On macOS: brew install jq"
    echo "  - On Ubuntu/Debian: sudo apt-get install jq"
    echo "  - On CentOS/RHEL: sudo yum install jq"
    exit 1
fi

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <swift-file-or-directory> [--skip-backup]"
    exit 1
fi

TARGET=$1
SKIP_BACKUP=0

# Check for optional flags
if [ "$2" = "--skip-backup" ]; then
    SKIP_BACKUP=1
fi

# Function to extract header (comments, imports, etc.)
extract_header() {
    local file="$1"
    local header
    # Capture file header (comments, imports, conditional compilation blocks)
    header=$(awk '
        BEGIN { in_comment=0; in_imports=1; printed=0 }
        /^\/\// { print; next }
        /^\/\*/ { in_comment=1; print; next }
        in_comment==1 { print; if ($0 ~ /\*\//) in_comment=0; next }
        /^import/ { if (in_imports) print; next }
        /^#if/ { print; next }
        /^#else/ { print; next }
        /^#endif/ { print; next }
        /^$/ { if (!printed) print; next }
        { if (in_imports) in_imports=0; if (!printed) printed=1; exit }
    ' "$file")
    echo "$header"
}

# Function to extract main code (excluding header)
extract_main_code() {
    local file="$1"
    local main_code
    main_code=$(awk '
        BEGIN { in_header=1; in_comment=0; buffer="" }
        in_header && /^\/\// { next }
        in_header && /^\/\*/ { in_comment=1; next }
        in_header && in_comment { if ($0 ~ /\*\//) in_comment=0; next }
        in_header && /^import/ { next }
        in_header && /^#if/ { next }
        in_header && /^#else/ { next }
        in_header && /^#endif/ { next }
        in_header && /^$/ { next }
        { in_header=0; print }
    ' "$file")
    echo "$main_code"
}

# Function to clean markdown code blocks
clean_markdown() {
    local content="$1"
    # Remove ```swift from the start and ``` from the end, if present
    content=$(echo "$content" | sed -E '1s/^```swift[[:space:]]*//')
    content=$(echo "$content" | sed -E '$s/```[[:space:]]*$//')
    echo "$content"
}

# Function to process a single Swift file
process_swift_file() {
    local SWIFT_FILE=$1
    echo "Processing: $SWIFT_FILE"

    # Create backup unless skipped
    if [ $SKIP_BACKUP -eq 0 ]; then
        cp "$SWIFT_FILE" "${SWIFT_FILE}.backup"
        echo "Created backup: ${SWIFT_FILE}.backup"
    fi

    # Extract header and main code separately
    local header
    header=$(extract_header "$SWIFT_FILE")
    
    local main_code
    main_code=$(extract_main_code "$SWIFT_FILE")

    # Read and escape the main code for JSON
    local SWIFT_CODE
    SWIFT_CODE=$(echo "$main_code" | jq -Rs .)

    # Create the JSON payload
    local JSON_PAYLOAD
    JSON_PAYLOAD=$(jq -n \
        --arg code "$SWIFT_CODE" \
        '{
            model: "claude-3-haiku-20240307",
            max_tokens: 2000,
            messages: [{
                role: "user",
                content: "Please add Swift documentation comments to the following code. Use /// style comments. Include parameter descriptions and return value documentation where applicable. Return only the documented code without any markdown formatting or explanation:\n\n\($code)"
            }]
        }')

    # Make the API call to Claude
    local response
    response=$(curl -s https://api.anthropic.com/v1/messages \
        -H "Content-Type: application/json" \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -d "$JSON_PAYLOAD")

    # Check if the API call was successful
    if [ $? -ne 0 ]; then
        echo "Error: API call failed for $SWIFT_FILE"
        return 1
    fi

    # Extract the content from the response using jq
    local documented_code
    documented_code=$(echo "$response" | jq -r '.content[0].text // empty')

    # Check if we got valid content back
    if [ -z "$documented_code" ]; then
        echo "Error: No valid response received for $SWIFT_FILE"
        echo "API Response: $response"
        return 1
    fi

    # Clean the markdown formatting from the response
    documented_code=$(clean_markdown "$documented_code")

    # Combine header and documented code
    {
        echo "$header"
        [ ! -z "$header" ] && echo "" # Add blank line if header exists
        echo "$documented_code"
    } > "$SWIFT_FILE"

    # Show diff if available and backup exists
    if [ $SKIP_BACKUP -eq 0 ] && command -v diff &> /dev/null; then
        echo -e "\nChanges made to $SWIFT_FILE:"
        diff "${SWIFT_FILE}.backup" "$SWIFT_FILE"
    fi

    echo "✓ Documentation added to $SWIFT_FILE"
    echo "----------------------------------------"
}

# Function to process directory
process_directory() {
    local DIR=$1
    local SWIFT_FILES=0
    local PROCESSED=0
    local FAILED=0

    # Count total Swift files
    SWIFT_FILES=$(find "$DIR" -name "*.swift" | wc -l)
    echo "Found $SWIFT_FILES Swift files in $DIR"
    echo "----------------------------------------"

    # Process each Swift file
    while IFS= read -r file; do
        if process_swift_file "$file"; then
            ((PROCESSED++))
        else
            ((FAILED++))
        fi
        # Add a small delay to avoid API rate limits
        sleep 1
    done < <(find "$DIR" -name "*.swift")

    echo "Summary:"
    echo "- Total Swift files found: $SWIFT_FILES"
    echo "- Successfully processed: $PROCESSED"
    echo "- Failed: $FAILED"
}

# Main logic
if [ -f "$TARGET" ]; then
    # Single file processing
    if [[ "$TARGET" == *.swift ]]; then
        process_swift_file "$TARGET"
    else
        echo "Error: File must have .swift extension"
        exit 1
    fi
elif [ -d "$TARGET" ]; then
    # Directory processing
    process_directory "$TARGET"
else
    echo "Error: $TARGET is neither a valid file nor directory"
    exit 1
fi