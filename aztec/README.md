aztec-nargo compile

aztec codegen -o src/artifacts target

aztec-wallet deploy \ 
    --node-url $NODE_URL \
    --from accounts:my-wallet \
    --payment method=fpc-sponsored,fpc=contracts:sponsoredfpc \
    --alias kinkySwapEscrow \
    target/kinky_swap_escrow-KinkySwapEscrow.json