# Address Book Plugin for Claude Code

A Claude Code plugin that lets you send crypto to contacts by name. Say "send $2 to shreyaas" instead of copy-pasting wallet addresses.

## Install

In Claude Code, add the marketplace and install:

```
/plugin marketplace add <your-github-username>/address-book
/plugin install address-book@address-book
```

Or for local development:

```bash
claude --plugin-dir /path/to/address-book
```

## Prerequisites

- [Claude Code](https://claude.ai/code) CLI
- [Tempo](https://tempo.xyz) CLI installed and logged in (`tempo wallet login`)
- `jq` installed (`brew install jq` on macOS)

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

- **contacts.json** — Source of truth, stored in the plugin's `data/` directory
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
