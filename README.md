# Stacks Lottery

A decentralized lottery system on Stacks blockchain using `@stacks/connect` and `@stacks/transactions`.

## Features

- 🎰 Buy lottery tickets with STX
- 🎲 Fair on-chain randomness using block height
- 🏆 Automatic prize distribution
- 📊 Track lottery history

## Tech Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **Blockchain**: Stacks Mainnet
- **Smart Contract**: Clarity
- **Libraries**: @stacks/connect, @stacks/transactions, @stacks/network

## Contract Functions

- `buy-ticket` - Purchase a lottery ticket (1 STX)
- `draw-winner` - Draw lottery winner (owner only)
- `get-lottery-id` - Get current lottery round
- `get-current-pot` - Get total prize pool
- `get-ticket-count` - Get tickets sold

## Getting Started

```bash
npm install
npm run dev
```

## Contract Address

Deployed on Stacks Mainnet: `SP3E0DQAHTXJHH5YT9TZCSBW013YXZB25QFDVXXWY.lottery`

## License

MIT
