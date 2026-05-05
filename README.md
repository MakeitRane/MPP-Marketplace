# Address Book Plugin for Claude Code

A Claude Code plugin that lets you send crypto to contacts by name. Say "send $2 to shreyaas" instead of copy-pasting wallet addresses.

## Prerequisites

- [Claude Code](https://claude.ai/code) CLI
- [Tempo](https://tempo.xyz) CLI installed and logged in (`tempo wallet login`)
- `jq` installed (`brew install jq` on macOS)

## Setup

```bash
git clone https://github.com/MakeitRane/MPP-Marketplace.git
cd MPP-Marketplace
chmod +x setup.sh scripts/contacts.sh
./setup.sh
```

The setup script will:
- Copy `data/contacts.example.json` → `data/contacts.json` (your local address book, gitignored)
- Verify `jq` and Tempo CLI are installed
- Check your Tempo wallet login status

## Install

**Option A — Local plugin (development):**

```bash
claude --plugin-dir /path/to/MPP-Marketplace
```

**Option B — Via marketplace:**

In Claude Code:

```
/plugin marketplace add MakeitRane/MPP-Marketplace
/plugin install address-book@address-book
```

## Usage

### Add a contact

```
/address-book add shreyaas 0x5fBCD6AF4Af2c54b546152a5d1FFde5980760c9a
```

With ENS and network:

```
/address-book add shreyaas 0x5fBCD6AF4Af2c54b546152a5d1FFde5980760c9a shreyaasxoxo.cb.id base
```

Network defaults to `tempo` if omitted.

### List contacts

```
/address-book list
```

### Remove a contact

```
/address-book remove shreyaas
```

### Send to a contact

Just say it naturally:

```
send $2 to shreyaas
```

Claude will look up the address, confirm with you, and execute the transfer.

### Auto-save

When Claude resolves a new wallet address (via ENS, cb.id, or you paste one), it will offer to save it as a contact.

## How it works

- **contacts.json** — Source of truth, stored in the plugin's `data/` directory (gitignored, stays local)
- **contacts.example.json** — Template with dummy data for first-time setup
- **Claude memory** — Contacts are synced to Claude's memory system so they're available in every conversation, even without the skill being invoked
- **Tempo** — Transfers execute via `tempo wallet transfer` on the Tempo network

## Schema

```json
{
  "name": {
    "address": "0x...",
    "ens": "name.cb.id",
    "network": "tempo"
  }
}
```

## License

MIT
