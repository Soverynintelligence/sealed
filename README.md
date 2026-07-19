# Sealed

**Proof of what you agreed — onchain.**

A contractor seals a quote onchain; the customer accepts it from their own wallet. Both actions are timestamped and immutable, so neither side can later rewrite the number or the date. Only a *hash* of the quote goes onchain, so the line items stay private while the agreement stays provable.

Built for the Monad **Spark / BuildAnything** hackathon.

## The problem

I run a pond-building business. I hand out quotes constantly, and there's no durable record of what was actually agreed — the amount, the scope, the date. A verbal "yeah that works" isn't proof, and a customer can later claim the number was different. Screenshots and emails get lost or edited.

## The solution

Sealed puts the agreement itself on a public chain:

1. **Seal** — I enter the customer, scope, and total. The app hashes the details (`keccak256`) and writes the hash + amount + my wallet + a timestamp to the `QuoteSeal` contract on Monad. It hands me a link.
2. **Send** — the link carries the quote details (base64) plus points at the onchain record.
3. **Accept** — my customer opens the link, sees the quote verified against the chain, connects their wallet, and taps **Accept**. Their acceptance (wallet + timestamp) is written onchain. The contract refuses to let *me* self-accept — acceptance has to come from a different wallet, which is what makes it real proof.
4. **Verify** — anyone with the link can read the live onchain status. If the amount in the link doesn't match what was sealed, the app flags it as altered and blocks acceptance.

Nothing is faked: the status you see is read straight from Monad, the accept button sends a real transaction, and tampering with the link is caught by re-deriving the hash.

## Onchain component

- **Contract:** [`contracts/QuoteSeal.sol`](contracts/QuoteSeal.sol) — `sealQuote`, `acceptQuote`, `getQuote`.
- **Network:** Monad Testnet (chain ID `10143`).
- **Address:** [`0x25146c67C0b550306D880a8e00Ec4D7eFDDCF7Cf`](https://testnet.monadexplorer.com/address/0x25146c67C0b550306D880a8e00Ec4D7eFDDCF7Cf)

## Run it

The web app is a single static file — no build step.

```bash
cd docs && python3 -m http.server 8000
# open http://localhost:8000
```

Or just use the hosted version (see below) — no setup.

You need [MetaMask](https://metamask.io) with the Monad testnet added and a little testnet MON from [faucet.monad.xyz](https://faucet.monad.xyz).

## Deploy the contract (Remix — no keys leave your wallet)

1. Open [remix.ethereum.org](https://remix.ethereum.org), paste `contracts/QuoteSeal.sol`, compile (Solidity 0.8.24+).
2. Deploy tab → Environment: **Injected Provider - MetaMask**, on Monad Testnet.
3. Deploy, confirm in MetaMask, copy the deployed address.
4. Paste the address into `CONTRACT_ADDRESS` in `web/index.html`.

## Making it real

The one gap for everyday use is the customer's wallet — today they need MetaMask and testnet MON to accept, which my pond customers won't do. That's a solved problem: an **embedded / smart wallet** (Coinbase Smart Wallet, Privy, Web3Auth) with **sponsored gas** turns the customer flow into *open the link → sign in with email or Face ID → tap Accept* — no seed phrase, no tokens. Same onchain proof, none of the friction. That's the single change between this demo and a shippable product.

## Stack

Solidity · Monad Testnet · [ethers v6](https://docs.ethers.org) · vanilla JS, single-file frontend, no framework.
