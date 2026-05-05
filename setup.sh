#!/bin/bash
# setup.sh — Initialize address book plugin after cloning
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTACTS_FILE="$SCRIPT_DIR/data/contacts.json"
EXAMPLE_FILE="$SCRIPT_DIR/data/contacts.example.json"

echo "Setting up address-book plugin..."
echo ""

# Initialize contacts.json
if [ ! -f "$CONTACTS_FILE" ]; then
  cp "$EXAMPLE_FILE" "$CONTACTS_FILE"
  echo "✓ Created data/contacts.json from template"
else
  echo "✓ data/contacts.json already exists"
fi

# Check jq
if ! command -v jq &>/dev/null; then
  echo "✗ jq not found — install with: brew install jq"
  exit 1
else
  echo "✓ jq installed"
fi

# Check tempo
if ! command -v tempo &>/dev/null; then
  echo "✗ Tempo CLI not found — install from https://tempo.xyz"
  echo "  curl -fsSL https://tempo.xyz/install | bash"
  exit 1
else
  echo "✓ Tempo CLI installed"
fi

# Check tempo login
if "$HOME/.tempo/bin/tempo" wallet whoami &>/dev/null 2>&1; then
  echo "✓ Tempo wallet logged in"
else
  echo "⚠ Tempo wallet not logged in — run: tempo wallet login"
fi

echo ""
echo "Done! Install the plugin in Claude Code with:"
echo "  claude --plugin-dir $SCRIPT_DIR"
echo ""
echo "Or add the marketplace:"
echo "  /plugin marketplace add MakeitRane/MPP-Marketplace"
echo "  /plugin install address-book@address-book"
