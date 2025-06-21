# Kinky Swap 🔐

## Getting Started

```bash
git clone --recurse-submodules https://github.com/GianfrancoBazzani/zkHack-Berlin-Kinky-Swap
```

## Architecture

## Swap Phases
1. The maker generates a secret hash and posts the their intent to make a cross-chain swap. At the same time locks the input amount in the source escrow contract. The tokens will be locked until a deadline time t1.

2. The taker takes the intent. At the same time locks the output amount in the destination escrow contract. The tokens will be locked until a deadline time t2 (t2 < t1).

3. If the maker is ok it will withdraw the output amount from the escrow contract in the destination chain effectively revealing the secret.

4. The taker will have a time t1-t2 to withdraw the input amount on the origin chain safely.



### Aleo Escrow Program

```rust
// Program
kinky_swap_escrow_v0.aleo

//  Maker Functions
transition escrow_from_public
transition escrow_from_private

// Taker Functions
transition withdraw_to_public
transition withdraw_to_private
```

## Notes

### 1INCH FUSION+
#### Links 
[1INCH FUSION+ | INTENT-BASED ATOMIC CROSS-CHAIN SWAPS](https://1inch.io/assets/1inch-fusion-plus.pdf)

### Aleo

#### Links
[Testnet faucet](https://discord.com/channels/913160862670397510/1202322326230937640)
[Leo docs](https://docs.leo-lang.org/leo)
[Leo naming conventions](https://developer.aleo.org/guides/leo/leo_best_practices)
[Aleo Standard programs](https://github.com/demox-labs/aleo-standard-programs/tree/main)
[https://zlearn.gitbook.io/zlearn](https://zlearn.gitbook.io/zlearn)
[Leo Core Functions](https://zlearn.gitbook.io/zlearn/introduction-to-leo/3.7-operators#core-functions)
[Leo Wallet SDK](https://docs.leo.app/aleo-wallet-adapter)
[Check Transactions](https://docs.explorer.provable.com/docs/api-reference/28l42jqxvwhs7-get-confirmation-status-of-transaction)

#### Commands
To test Leo programs locally without network, simply run command `leo run <FUNCTION_ID> <FUNCTION_ARGUMENTS>` 
To execute a transaction on the network `leo execute <program>/<function> <arguments>  --broadcast`
To fetch records: `snarkos developer scan --endpoint http://localhost:3030 --private-key <PRIVATE_KEY> --start 0 --network 1`

To install an external programs to your program as dependency:  `leo add --path ../token_registry/ --network testnet`
