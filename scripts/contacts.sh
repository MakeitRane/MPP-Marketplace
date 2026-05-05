#!/bin/bash
# contacts.sh — CRUD operations for the address book
# Usage:
#   contacts.sh add <name> <address> [ens] [network]
#   contacts.sh remove <name>
#   contacts.sh get <name>
#   contacts.sh list

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTACTS_FILE="$SCRIPT_DIR/../data/contacts.json"

if [ ! -f "$CONTACTS_FILE" ]; then
  echo "{}" > "$CONTACTS_FILE"
fi

case "${1:-}" in
  add)
    NAME="${2:?Usage: contacts.sh add <name> <address> [ens] [network]}"
    ADDRESS="${3:?Usage: contacts.sh add <name> <address> [ens] [network]}"
    ENS="${4:-}"
    NETWORK="${5:-tempo}"

    jq --arg name "$NAME" \
       --arg address "$ADDRESS" \
       --arg ens "$ENS" \
       --arg network "$NETWORK" \
       '.[$name] = {address: $address, ens: $ens, network: $network}' \
       "$CONTACTS_FILE" > "$CONTACTS_FILE.tmp" && mv "$CONTACTS_FILE.tmp" "$CONTACTS_FILE"

    echo "Added $NAME ($ADDRESS) on $NETWORK"
    ;;

  remove)
    NAME="${2:?Usage: contacts.sh remove <name>}"

    jq --arg name "$NAME" 'del(.[$name])' \
       "$CONTACTS_FILE" > "$CONTACTS_FILE.tmp" && mv "$CONTACTS_FILE.tmp" "$CONTACTS_FILE"

    echo "Removed $NAME"
    ;;

  get)
    NAME="${2:?Usage: contacts.sh get <name>}"

    RESULT=$(jq --arg name "$NAME" '.[$name] // empty' "$CONTACTS_FILE")
    if [ -z "$RESULT" ]; then
      echo "Contact not found: $NAME"
      exit 1
    fi
    echo "$RESULT"
    ;;

  list)
    jq -r 'to_entries[] | "\(.key): \(.value.address) (\(.value.network))\(if .value.ens != "" then " — " + .value.ens else "" end)"' "$CONTACTS_FILE"
    ;;

  *)
    echo "Usage: contacts.sh {add|remove|get|list}"
    echo ""
    echo "  add <name> <address> [ens] [network]   Add a contact (network defaults to tempo)"
    echo "  remove <name>                           Remove a contact"
    echo "  get <name>                              Get a contact's details"
    echo "  list                                    List all contacts"
    exit 1
    ;;
esac
