# Kiky Swap 🔐

## Getting Started

```bash
git clone --recurse-submodules https://github.com/GianfrancoBazzani/zkHack-Berlin-Kinky-Swap
```

## Architecture



### Aleo Escrow
1. When an order is matched the aleo part deploys an escrow for the specific 


## Notes

### Aleo

#### Links
[Testnet faucet](https://discord.com/channels/913160862670397510/1202322326230937640)
[Leo docs](https://docs.leo-lang.org/leo)
[Leo naming conventions](https://developer.aleo.org/guides/leo/leo_best_practices)
[Aleo Standard programs](https://github.com/demox-labs/aleo-standard-programs/tree/main)
[https://zlearn.gitbook.io/zlearn](https://zlearn.gitbook.io/zlearn)
[Leo Core Functions](https://zlearn.gitbook.io/zlearn/introduction-to-leo/3.7-operators#core-functions)
[Leo Wallet SDK](https://docs.leo.app/aleo-wallet-adapter)

#### Commands
To test Leo programs locally without network, simply run command `leo run <FUNCTION_ID> <FUNCTION_ARGUMENTS>` 
To execute a transaction on the network `leo execute <program>/<function> <arguments>  --broadcast`
To fetch records: `snarkos developer scan --endpoint http://localhost:3030 --private-key <PRIVATE_KEY> --start 0 --network 1`


