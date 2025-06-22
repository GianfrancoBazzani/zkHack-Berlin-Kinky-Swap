# Kinky Swap 🔐

![Kinky Swap Banner](./img/github-banner.png)

## Getting Started

```bash
git clone --recurse-submodules https://github.com/GianfrancoBazzani/zkHack-Berlin-Kinky-Swap
```

## Architecture
![Architecture Schema](./img/kiky-swap-schema.png)

## Kinky Swap | Poor but sexy non-vanila cross-chain swaps for the tasteful and anonymous.

**Problem:**
Currently, there's no direct interoperability between Aleo and Aztec, two nascent blockchain networks focused on privacy. This lack of a cross-chain bridge or atomic cross-chain swap mechanism prevents users from seamlessly transferring assets or liquidity between these ecosystems.

**Solution**
Kiky Swap enables atomic, anonymous cross-chain bridges and swaps between Aleo and Aztec. Our platform allows users to trustlessly move any asset from Aleo to Aztec and vice-versa, enhancing comosablity within the nascent privacy-focused blockchain space.

### Trustless, Permissionless Cross-Chain Swaps
Users can swap tokens between Aleo and Aztec chain without depositing into a centralized bridge or relying on a custodian. All lock-and-release logic lives on-chain in hash timelock escrow contracts, so swaps either complete atomically or not at all.

### Leveraging ZK for Privacy
Kinky Swap leverages zero-knowledge proofs (ZKPs) inherent in both Aleo and Aztec to facilitate private transactions.

### Architecure
- **Backend:** A private backend allows makers to post orders with minimal information, enabling takers to consume them.
- **Frontend:** Allows users to interact with the application through wallet injection.
- **Aleo Escrow Program:** Symmetric [Leo program](https://github.com/GianfrancoBazzani/zkHack-Berlin-Kinky-Swap/blob/main/aleo/kinky_swap_escrow_v0/src/main.leo) deployed on Aleo [testnet](https://testnet.aleoscan.io/program?id=kinky_swap_escrow_v0.aleo) that allows sending/receiving tokens to/from the Aztec network.
- **Aztec Escrow Smart Contract:** Symmetric [Noir smart contract](https://github.com/GianfrancoBazzani/zkHack-Berlin-Kinky-Swap/blob/main/aztec/kinky_swap_escrow/src/main.nr) deployed on Aztec [testnet](https://aztecexplorer.xyz/address/0x1951a69527f1b83ee989c9620cc55b9b38d92f9d300995ff5e15a9bfe2912192#bytecode) that allows sending/receiving tokens to/from the Aleo testnet.

### Swap Phases 
1. The maker generates a secret and posts on Kinky Swap the intent to make a cross-chain swap with the hash of the secret.
2. The taker takes the intent; the maker is notified.
3. The maker locks the input amount in the source escrow contract. The tokens will be locked until deadline time t1.
4. The taker locks the output amount in the destination escrow contract. The tokens will be locked until deadline time t2 (t2 < t1).
5. If the maker is OK, it will withdraw the output amount from the escrow contract on the destination chain, effectively revealing the secret.
6. The taker will have time t1-t2 to withdraw the input amount on the source chain safely.

The idea is based on the on-chain logic described in the paper: [1INCH FUSION+ INTENT-BASED ATOMIC CROSS-CHAIN SWAPS](https://1inch.io/assets/1inch-fusion-plus.pdf)


## Deployments

### Aleo 

   - [kinky_token.aleo (KNK)](https://testnet.aleoscan.io/program?id=kinky_token.aleo)
   - [kinky_swap_escrow_v0.aleo](https://testnet.aleoscan.io/program?id=kinky_swap_escrow_v0.aleo)

### Aztec
   - [Kinky Token (KNK)](https://aztecexplorer.xyz/address/0x29fe8914d01c5360cb747d02e70a47f0039d0cfbd736b691d7de582bee2f7547)
   - [KinkySwapEscrow](https://aztecexplorer.xyz/address/0x1951a69527f1b83ee989c9620cc55b9b38d92f9d300995ff5e15a9bfe2912192#bytecode)

## Notes

### Links

[1INCH FUSION+ | INTENT-BASED ATOMIC CROSS-CHAIN SWAPS](https://1inch.io/assets/1inch-fusion-plus.pdf)

Aleo:
   - [Testnet faucet](https://discord.com/channels/913160862670397510/1202322326230937640)
   - [Leo docs](https://docs.leo-lang.org/leo)
   - [Leo naming conventions](https://developer.aleo.org/guides/leo/leo_best_practices)
   - [Aleo Standard programs](https://github.com/demox-labs/aleo-standard-programs/tree/main)
   - [https://zlearn.gitbook.io/zlearn](https://zlearn.gitbook.io/zlearn)
   - [Leo Core Functions](https://zlearn.gitbook.io/zlearn/introduction-to-leo/3.7-operators#core-functions)
   - [Leo Wallet SDK](https://docs.leo.app/aleo-wallet-adapter)
   - [Check Transactions](https://docs.explorer.provable.com/docs/api-reference/28l42jqxvwhs7-get-confirmation-status-of-transaction)

Noir:
   - [Aztec Testnet Info](https://docs.aztec.network/try_testnet)
   - [Aztec Playground](https://play.aztec.network/latest/)
   - [Token Tutorial](https://docs.aztec.network/developers/guides/getting_started_on_testnet)

### Commands

Aleo SDK:
   - To test Leo programs locally without network, simply run command `leo run <FUNCTION_ID> <FUNCTION_ARGUMENTS>` 
   - To execute a transaction on the network `leo execute <program>/<function> <arguments>  --broadcast`
   - To fetch records: `snarkos developer scan --endpoint http://localhost:3030 --private-key <PRIVATE_KEY> --start 0 --network 1`
  - To install an external programs to your program as dependency:  `leo add --path ../token_registry/ --network testnet`

Aztec SDK:
 - To display aztec-wallet aliases: `aztec-wallet get-alias`
 - To mint KinkyToken: `aztec-wallet send mint_to_private --node-url $NODE_URL --from accounts:my-wallet --payment method=fpc-sponsored,fpc=contracts:sponsoredfpc --contract-address kinky_token  --args accounts:my-wallet accounts:my-wallet 10`