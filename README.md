# ArtworkNFT

ArtworkNFT is a decentralized platform built on the Stacks blockchain that enables artists to mint, sell, and trade digital artwork as non-fungible tokens (NFTs).

## Features

- **Digital Artwork Tokenization**: Convert digital artwork into unique NFTs on the blockchain
- **Direct Artist Sales**: Artists can set prices and sell directly to collectors
- **Ownership Verification**: Transparent and immutable proof of ownership
- **Metadata Storage**: Comprehensive artwork details stored on-chain

## Smart Contract Functions

### NFT Management
- `mint`: Create a new artwork NFT with metadata and pricing
- `purchase`: Buy an artwork NFT from its current owner
- `get-token-metadata`: View details about a specific artwork
- `get-token-owner`: Check who currently owns an artwork
- `is-token-owned-by`: Verify if a specific address owns an artwork

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet) for local development
3. Run `clarinet check` to verify the contract
4. Deploy using Clarinet or the Stacks CLI

## For Artists

Artists can mint their digital artwork by providing:
- Name of the artwork
- Description of the piece
- URI to the digital image
- Price in STX tokens

## For Collectors

Collectors can purchase artwork directly through the smart contract, with funds automatically transferred to the artist.
