# Game Mechanics IP Registry

A comprehensive smart contract solution for registering and protecting video game mechanics and gameplay innovations on the Stacks blockchain. This contract enables game developers to establish proof of creation, manage intellectual property rights, and protect their unique gameplay innovations.

## Features

- **Mechanic Registration**: Register unique game mechanics with detailed descriptions and categorization
- **Proof of Creation**: Immutable timestamp recording using blockchain block height
- **IP Protection**: Establish ownership and creation rights for gameplay innovations
- **Mechanic Management**: Update and deactivate registered mechanics by original creators
- **Creator Tracking**: Monitor the number of mechanics registered by each developer
- **Category Organization**: Organize mechanics by game genre or mechanic type
- **Ownership Verification**: Verify mechanic ownership and creation rights

## Technical Specifications

- **Blockchain**: Stacks
- **Language**: Clarity
- **Version**: 1.0.0
- **Clarity Version**: 2
- **Epoch**: 2.5

### Data Structures

- **Mechanic Records**: Title (100 chars), Description (500 chars), Category (50 chars)
- **Ownership Tracking**: Creator-to-mechanic mapping with ownership status
- **Creator Statistics**: Count of mechanics registered per creator
- **Unique Identifiers**: Auto-incrementing mechanic IDs starting from 1

## Installation

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks smart contract development tool
- [Node.js](https://nodejs.org/) (v16 or higher)
- [Git](https://git-scm.com/)

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd game-mechanics
```

2. Navigate to the contract directory:
```bash
cd game-mechanics_contract
```

3. Install dependencies:
```bash
npm install
```

4. Verify installation:
```bash
clarinet check
```

## Usage Examples

### Register a New Game Mechanic

```clarity
(contract-call? .game-mechanics register-mechanic
  "Wall-Jump Momentum System"
  "A mechanic where players gain additional momentum when wall-jumping consecutively, allowing for complex platforming sequences with increasing speed and height."
  "Platformer")
```

### Update an Existing Mechanic

```clarity
(contract-call? .game-mechanics update-mechanic
  u1
  "Enhanced Wall-Jump System"
  "An improved wall-jumping mechanic with momentum conservation and directional control for advanced platforming gameplay."
  "Action-Platformer")
```

### Retrieve Mechanic Information

```clarity
(contract-call? .game-mechanics get-mechanic u1)
```

### Check Mechanic Ownership

```clarity
(contract-call? .game-mechanics is-mechanic-owner 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM u1)
```

## Contract Functions Documentation

### Public Functions

#### `register-mechanic`
Registers a new game mechanic with the contract.

**Parameters:**
- `title` (string-ascii 100): The name of the game mechanic
- `description` (string-ascii 500): Detailed description of how the mechanic works
- `category` (string-ascii 50): Game genre or mechanic category

**Returns:** `(response uint uint)` - The assigned mechanic ID on success

**Error Codes:**
- `u104`: Invalid input (empty strings not allowed)

#### `update-mechanic`
Updates an existing mechanic (creator only).

**Parameters:**
- `mechanic-id` (uint): The ID of the mechanic to update
- `title` (string-ascii 100): New title for the mechanic
- `description` (string-ascii 500): New description
- `category` (string-ascii 50): New category

**Returns:** `(response bool uint)` - `true` on successful update

**Error Codes:**
- `u101`: Mechanic not found
- `u103`: Unauthorized (not the creator)
- `u104`: Invalid input

#### `deactivate-mechanic`
Deactivates a mechanic (creator only).

**Parameters:**
- `mechanic-id` (uint): The ID of the mechanic to deactivate

**Returns:** `(response bool uint)` - `true` on successful deactivation

### Read-Only Functions

#### `get-mechanic`
Retrieves complete information about a specific mechanic.

**Parameters:**
- `mechanic-id` (uint): The mechanic ID to query

**Returns:** `(optional {...})` - Mechanic details or none if not found

#### `is-mechanic-owner`
Checks if a principal owns a specific mechanic.

**Parameters:**
- `creator` (principal): The address to check
- `mechanic-id` (uint): The mechanic ID

**Returns:** `bool` - `true` if the principal owns the mechanic

#### `get-creator-mechanic-count`
Returns the total number of mechanics registered by a creator.

**Parameters:**
- `creator` (principal): The creator's address

**Returns:** `uint` - Number of registered mechanics

#### `get-next-mechanic-id`
Returns the next mechanic ID that will be assigned.

**Returns:** `uint` - The next available mechanic ID

#### `get-contract-owner`
Returns the contract owner's address.

**Returns:** `principal` - The contract owner's address

## Deployment Guide

### Local Development

1. Start Clarinet console:
```bash
clarinet console
```

2. Deploy the contract:
```clarity
::deploy_contract game-mechanics contracts/game-mechanics.clar
```

### Testnet Deployment

1. Configure your testnet settings in `settings/Testnet.toml`

2. Deploy to testnet:
```bash
clarinet deployments generate --testnet
clarinet deployments apply --testnet
```

### Mainnet Deployment

1. Configure mainnet settings in `settings/Mainnet.toml`

2. Deploy to mainnet:
```bash
clarinet deployments generate --mainnet
clarinet deployments apply --mainnet
```

## Testing

Run the complete test suite:

```bash
npm test
```

Run tests with coverage and cost analysis:

```bash
npm run test:report
```

Watch mode for development:

```bash
npm run test:watch
```

## Security Notes

### Access Controls
- Only mechanic creators can update or deactivate their registered mechanics
- Contract deployment establishes an immutable owner address
- All mechanic registrations include creator verification

### Data Validation
- Input validation prevents empty strings for all required fields
- String length limits prevent potential overflow attacks
- Block height timestamps provide immutable creation proof

### Best Practices
- Always verify mechanic ownership before performing updates
- Use the read-only functions to check mechanic status before transactions
- Consider gas costs when registering mechanics with maximum field lengths
- Store sensitive mechanic details off-chain and reference them in descriptions

### Known Limitations
- Mechanics cannot be permanently deleted, only deactivated
- No built-in dispute resolution mechanism
- Creator addresses cannot be transferred or updated
- Maximum field lengths are fixed and cannot be extended

## Error Codes Reference

| Code | Constant | Description |
|------|----------|-------------|
| 100 | err-owner-only | Action restricted to contract owner |
| 101 | err-not-found | Mechanic ID does not exist |
| 102 | err-already-exists | Resource already exists |
| 103 | err-unauthorized | Insufficient permissions |
| 104 | err-invalid-input | Invalid or empty input parameters |

## License

This project is licensed under the ISC License.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes and add tests
4. Ensure all tests pass
5. Submit a pull request

For major changes, please open an issue first to discuss the proposed modifications.