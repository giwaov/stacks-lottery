# Stacks Lottery

[![Stacks](https://img.shields.io/badge/Stacks-Mainnet-5546FF)](https://stacks.co)
[![Clarity](https://img.shields.io/badge/Clarity-Smart%20Contract-orange)](https://clarity-lang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A decentralized lottery system on Stacks blockchain using `@stacks/connect` and `@stacks/transactions`.

## Features

- 🎰 Buy lottery tickets with STX (1 STX per ticket)
- 🎫 **Bulk purchase** - Buy up to 10 tickets in one transaction
- 🎲 Fair on-chain randomness using block height
- 🏆 Automatic prize distribution to winner
- 📊 Track lottery history and past winners
- 👤 View player ticket count

## Tech Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **Blockchain**: Stacks Mainnet
- **Smart Contract**: Clarity
- **Libraries**: @stacks/connect, @stacks/transactions, @stacks/network

## Contract Functions

### Write Functions
- `buy-ticket` - Purchase a single lottery ticket (1 STX)
- `buy-tickets (quantity)` - Purchase multiple tickets at once (max 10)
- `draw-winner` - Draw lottery winner (owner only)

### Read Functions
- `get-lottery-id` - Get current lottery round
- `get-current-pot` - Get total prize pool
- `get-ticket-count` - Get tickets sold
- `get-player-tickets (player)` - Get ticket count for a player
- `get-winner (lottery-id)` - Get winner of past lottery

## Getting Started

```bash
npm install
npm run dev
```

## Contract Address

Deployed on Stacks Mainnet: `SP3E0DQAHTXJHH5YT9TZCSBW013YXZB25QFDVXXWY.lottery`

## License

MIT
