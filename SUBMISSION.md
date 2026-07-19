# Sealed — hackathon submission

Copy-paste answers for the Spark / BuildAnything submission form.

| Field | Value |
|---|---|
| **Name** | Sealed |
| **Project URL** | https://soverynintelligence.github.io/sealed/ |
| **Github repo** | https://github.com/Soverynintelligence/sealed |
| **Category** | Monad Testnet |
| **Contract address** | `0x25146c67C0b550306D880a8e00Ec4D7eFDDCF7Cf` |
| **Demo video** | _(paste after recording)_ |
| **Post URL** | _(paste if you post about it — for the "most viral" prize)_ |

**Description** (a few words)
> Seal a job quote onchain; your customer accepts it from their own wallet. Both are locked and timestamped, so neither side can rewrite what was agreed.

**Problem**
> I run a pond-building business and hand out quotes constantly. There's no durable record of what was actually agreed — the amount, the scope, the date. A verbal "yeah that works" isn't proof, and a customer can later claim the number was different. Emails and screenshots get lost or edited.

**Solution**
> Sealed puts the agreement itself on Monad. I seal a quote — only a keccak256 hash of the details plus the amount goes onchain, so the line items stay private but the deal stays provable. I send the customer a link; they open it, the app verifies it against the chain, and they accept from their own wallet. The contract refuses to let me self-accept, so acceptance is real proof it came from the customer. Anyone with the link can read the live onchain status, and if the amount in the link doesn't match what was sealed, the app flags it as altered and blocks accepting. Nothing is faked: every status is read straight from Monad and every button sends a real transaction.

---

## Demo video shot list (target ~2:30, hard cap 3:00)

Record in a desktop browser with MetaMask. Have **two MetaMask accounts** ready, both with a little testnet MON (Account 1 = you/contractor, Account 2 = the customer).

1. **The problem (0:00–0:20).** On camera or voiceover: "I build ponds. I hand out quotes all day and there's no real proof of what we agreed on — the price, the date. Sealed fixes that."
2. **Seal it (0:20–1:05).** Open the app. Fill a real quote — customer "Pat", scope "Pond rebuild 24×18×3, all-boulder", total **26,564**. Hit **Seal quote onchain** → MetaMask → Confirm. Show the "Sealed ✦ onchain" screen, then click **View transaction** to show it succeeded on the Monad explorer. *(This is the proof it's real.)*
3. **Send + verify (1:05–1:45).** Hit **Copy customer link**. Open it in a new tab (as the customer). Point out it read the quote **live from the chain** — sealed-by wallet, amount, timestamp. Optional 5-sec tamper demo: edit the amount in the URL → the app shows **⚠ link altered** and won't let you accept.
4. **Accept it (1:45–2:20).** Switch MetaMask to **Account 2**. Hit **Accept this quote** → MetaMask → Confirm. It flips to **✓ accepted** and now shows both wallets and both timestamps — read from the chain.
5. **Close (2:20–2:40).** "Now neither of us can rewrite it. The quote, the amount, the date, and the customer's acceptance are all locked on Monad." Click **View onchain** to end on the explorer.

## Notes for the judges' "no slop / not vaporware" check
- The Accept button sends a **real** `acceptQuote` transaction; the status shown is read from Monad via a public RPC, not a hardcoded string.
- The contract **blocks self-accept** — you cannot fake a customer's acceptance from the sealing wallet.
- Tampering with the shared link is caught by re-deriving the keccak256 hash client-side and comparing amounts against the onchain record.
