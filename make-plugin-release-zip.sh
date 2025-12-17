#!/usr/bin/env bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <path-to-plugin-folder>"
  exit 1
fi

# Resolve absolute paths
PLUGIN_DIR="$(realpath "$1")"
PLUGIN_NAME="$(basename "$PLUGIN_DIR")"

# Expect structure: koreader/plugins/<plugin>
PLUGINS_DIR="$(dirname "$PLUGIN_DIR")"
KOREADER_DIR="$(dirname "$PLUGINS_DIR")"

META_FILE="$PLUGIN_DIR/_meta.lua"

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Error: '$PLUGIN_DIR' is not a directory"
  exit 1
fi

if [ ! -f "$META_FILE" ]; then
  echo "Error: _meta.lua not found in plugin directory"
  exit 1
fi

# Extract version from _meta.lua
VERSION="$(grep -E 'version *= *"' "$META_FILE" | sed -E 's/.*"([^"]+)".*/\1/')"

if [ -z "$VERSION" ]; then
  echo "Error: Could not extract version from _meta.lua"
  exit 1
fi

OUTPUT_ZIP="${PLUGIN_NAME}-v${VERSION}.zip"
OUTPUT_PATH="$KOREADER_DIR/$OUTPUT_ZIP"

echo "Creating release zip:"
echo "  Plugin : $PLUGIN_NAME"
echo "  Version: $VERSION"
echo "  Output : $OUTPUT_PATH"

(
  cd "$PLUGINS_DIR"

  zip -r "$OUTPUT_PATH" "$PLUGIN_NAME" \
    -x "$PLUGIN_NAME/README*" \
    -x "$PLUGIN_NAME/LICENSE*" \
    -x "$PLUGIN_NAME/images/*"
)

echo "Done."
