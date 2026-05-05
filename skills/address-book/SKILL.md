---
name: address-book
description: >
  Send crypto to contacts by name (e.g., "send $2 to shreyaas").
  Activates when sending tokens, transferring funds, looking up wallet
  addresses, resolving ENS/cb.id names, or managing saved contacts.
allowed-tools: Read Write Edit Bash Glob Grep
---

# Address Book

Wallet address book for blockchain transactions. Contacts are stored in `${CLAUDE_SKILL_DIR}/../../data/contacts.json` and synced to Claude memory for always-on availability.

## Current Contacts

!`cat ${CLAUDE_SKILL_DIR}/../../data/contacts.json 2>/dev/null || echo "{}"`

## Flows

### Flow 1 — Send/transfer with a contact name

When the user wants to send tokens to someone by name:

1. Check the current contacts above for a case-insensitive match
2. If found, confirm with the user before sending: "Send [amount] USDC.e to [name] ([address]) on [network]?"
3. Only after user confirms, execute via: `"$HOME/.tempo/bin/tempo" wallet -t transfer [amount] 0x20c000000000000000000000b9537d11c60e8b50 [address]`
4. Report the transaction hash

If no contact matches, tell the user the name wasn't found and suggest `/address-book add` or resolving an ENS/cb.id name first.

### Flow 2 — Save a new address as a contact

After resolving any new wallet address (via ENS lookup, cb.id resolution, or the user providing a raw 0x address), proactively ask:

> "Want to save [address] as a contact? What name should I use?"

If the user agrees:

1. Run the helper script to add to contacts.json:
   ```
   ${CLAUDE_SKILL_DIR}/../../scripts/contacts.sh add "<name>" "<address>" "<ens_or_empty>" "<network_or_tempo>"
   ```

2. Create a memory file at the user's active memory directory (`~/.claude/projects/<project>/memory/contact_<name>.md`):
   ```markdown
   ---
   name: contact-<name>
   description: Wallet address for <name> — use when sending crypto or tokens to <name>
   type: reference
   ---

   - **Address:** <address>
   - **ENS:** <ens or empty>
   - **Network:** <network, defaults to tempo>
   ```

3. Add an entry to the user's MEMORY.md index:
   ```
   - [<name>](contact_<name>.md) — wallet <address_short> on <network> (<ens>)
   ```

The network field defaults to "tempo" unless the user specifies otherwise.

### Flow 3 — Manual contact management

**`/address-book list`** — Show all contacts in a readable table.

**`/address-book add <name> <address>`** — Add a contact. Optionally accepts ENS and network as additional arguments. Defaults network to "tempo". Writes to both contacts.json and memory.

**`/address-book remove <name>`** — Remove a contact from contacts.json. Also delete the corresponding memory file (`contact_<name>.md`) and remove its line from MEMORY.md.

**`/address-book`** with no arguments — Same as list.

## Rules

- **Always confirm before sending funds.** Never execute a transfer without explicit user confirmation.
- **Network defaults to tempo.** Unless the user specifies a different network, assume tempo.
- **Case-insensitive matching.** "Shreyaas", "shreyaas", and "SHREYAAS" should all match the same contact.
- **Keep memory in sync.** Every add/remove must update both contacts.json AND the memory file + MEMORY.md index.
- **Use the helper script** at `${CLAUDE_SKILL_DIR}/../../scripts/contacts.sh` for JSON operations to ensure atomic writes.
