#!/bin/bash
# Video Processing Wrapper Script
# Processes all downloaded videos into soft sub, hard sub, and dub versions

set -e

INPUT_DIR="${1:-downloads}"
OUTPUT_DIR="${2:-processed}"

echo "=========================================="
echo "  Video Processing Pipeline"
echo "  Input: $INPUT_DIR"
echo "  Output: $OUTPUT_DIR"
echo "=========================================="

# Create output directories
mkdir -p "$OUTPUT_DIR/softsub"
mkdir -p "$OUTPUT_DIR/hardsub"
mkdir -p "$OUTPUT_DIR/dub"
mkdir -p "$OUTPUT_DIR/_subtitles"
mkdir -p "$OUTPUT_DIR/_audio"

# Count input video files
VIDEO_COUNT=$(find "$INPUT_DIR" -type f \( -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" -o -name "*.webm" \) 2>/dev/null | wc -l)

if [ "$VIDEO_COUNT" -eq 0 ]; then
    echo "WARNING: No video files found in $INPUT_DIR"
    echo "Skipping video processing step."
    # Create empty results file so downstream steps don't break
    echo '{"softsub":[],"hardsub":[],"dub":[]}' > "$OUTPUT_DIR/process_results.json"
    exit 0
fi

echo "Found $VIDEO_COUNT video file(s) to process"

# Run the Python processing script
python3 scripts/process_video.py "$INPUT_DIR" "$OUTPUT_DIR"

echo ""
echo "Processing complete!"
echo "  Soft sub files: $(find "$OUTPUT_DIR/softsub/" -type f 2>/dev/null | wc -l)"
echo "  Hard sub files: $(find "$OUTPUT_DIR/hardsub/" -type f 2>/dev/null | wc -l)"
echo "  Dub files: $(find "$OUTPUT_DIR/dub/" -type f 2>/dev/null | wc -l)"
