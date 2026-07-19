// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title QuoteSeal — tamper-proof proof-of-agreement for job quotes.
/// @notice A contractor seals a quote (a hash of its details + the dollar
/// amount) onchain; the customer later accepts it from their own wallet. Both
/// actions are timestamped and immutable, so neither side can later dispute
/// what was agreed, for how much, or when. Only the HASH of the quote goes
/// onchain — the line items stay private but stay provable.
contract QuoteSeal {
    struct Quote {
        address contractor;   // who sealed it
        address customer;     // who accepted it (address(0) until accepted)
        uint256 amountCents;  // quoted total in US cents (integer — no floats onchain)
        uint64  sealedAt;     // block timestamp when sealed
        uint64  acceptedAt;   // block timestamp when accepted (0 until accepted)
        bool    exists;       // true once sealed
        bool    accepted;     // true once the customer accepts
    }

    // quoteHash => record. quoteHash is keccak256 of the quote's human details,
    // computed client-side, so identical details map to the same slot.
    mapping(bytes32 => Quote) private quotes;

    event QuoteSealed(bytes32 indexed quoteHash, address indexed contractor, uint256 amountCents, uint64 sealedAt);
    event QuoteAccepted(bytes32 indexed quoteHash, address indexed customer, uint64 acceptedAt);

    /// @notice Seal a new quote. Reverts if this exact quote was already sealed.
    /// @param quoteHash keccak256 of the quote details (customer, scope, total).
    /// @param amountCents the quoted total, in cents.
    function sealQuote(bytes32 quoteHash, uint256 amountCents) external {
        require(quoteHash != bytes32(0), "empty hash");
        require(!quotes[quoteHash].exists, "already sealed");
        quotes[quoteHash] = Quote({
            contractor: msg.sender,
            customer: address(0),
            amountCents: amountCents,
            sealedAt: uint64(block.timestamp),
            acceptedAt: 0,
            exists: true,
            accepted: false
        });
        emit QuoteSealed(quoteHash, msg.sender, amountCents, uint64(block.timestamp));
    }

    /// @notice Accept a sealed quote from the customer's own wallet. Records who
    /// accepted and when. The contractor cannot self-accept — acceptance must
    /// come from a different wallet, which is what makes it real proof.
    function acceptQuote(bytes32 quoteHash) external {
        Quote storage q = quotes[quoteHash];
        require(q.exists, "no such quote");
        require(!q.accepted, "already accepted");
        require(msg.sender != q.contractor, "contractor cannot self-accept");
        q.accepted = true;
        q.customer = msg.sender;
        q.acceptedAt = uint64(block.timestamp);
        emit QuoteAccepted(quoteHash, msg.sender, uint64(block.timestamp));
    }

    /// @notice Read a quote's full onchain record. `exists` is false if unknown.
    function getQuote(bytes32 quoteHash) external view returns (
        address contractor,
        address customer,
        uint256 amountCents,
        uint64  sealedAt,
        uint64  acceptedAt,
        bool    accepted,
        bool    exists
    ) {
        Quote memory q = quotes[quoteHash];
        return (q.contractor, q.customer, q.amountCents, q.sealedAt, q.acceptedAt, q.accepted, q.exists);
    }
}
