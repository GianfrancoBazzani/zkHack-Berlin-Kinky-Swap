# Kinky Token Manager

### Comands

Deploy:
```bash
snarkos developer deploy kinky_token.aleo --private-key $PK --query "https://api.explorer.provable.com/v1" --path "./build/" --broadcast "https://api.explorer.provable.com/v1/testnet/transaction/broadcast" --priority-fee 0 
```
or use the frontend [https://www.provable.tools/develop](https://www.provable.tools/develop)

Register The Token (only once):
```bash
leo execute kinky_token.aleo/register --broadcast
```

Mint Tokens Private:
```bash
leo execute kinky_token.aleo/mint_private aleo13hfqsv2v3ygzmflsd5jj8p3m84lvrz70anh0v36p849r78udjcrqcjw7t9 100u128  --broadcast
```

Mint Tokens Public:
```bash
leo execute kinky_token.aleo/mint_public aleo13hfqsv2v3ygzmflsd5jj8p3m84lvrz70anh0v36p849r78udjcrqcjw7t9 100u128  --broadcast
```

