import token_registry.aleo;

// The 'kinky_token' program.
program kinky_token.aleo {
    const ADMIN: address = aleo1zwmh60286u8fhcagjwvvtr2es73j4ws372jarzvn644pycljaygqszla6u;
    const TOKEN_ID: field = 3443843282313283355337459085696902919850365217539366784739393210722344986field;

    // Register Token
    async transition register() -> Future {
        assert_eq(self.caller, ADMIN); 
       let register_token_future: Future = token_registry.aleo/register_token(
        TOKEN_ID,
        91167321837903190160008558u128, // "Kinky Token"
        4935243u128, // "KNK"
        6u8,
        1000000000u128,
        false,
       ADMIN 
       );
       return finalize_register(register_token_future);
    }
   async function finalize_register(register_token_future: Future) {
        register_token_future.await();
   }

    // Mint Private
    async transition mint_private(private recipient: address, amount: u128) -> (token_registry.aleo/Token, Future) {
        assert_eq(self.caller, ADMIN);
        let(token, mint_private_future): (token_registry.aleo/Token, Future) = token_registry.aleo/mint_private(
            TOKEN_ID,
            recipient,
            amount,
            false,
            4294967295u32
        );
        return (token, finalize_mint_private(mint_private_future));
    }
    async function finalize_mint_private(mint_private_future: Future) {
        mint_private_future.await();
    }

    // Mint Public
    async transition mint_public(recipient: address, amount: u128) -> Future{
        assert_eq(self.caller, ADMIN);
        let mint_public_future: Future = token_registry.aleo/mint_public(
            TOKEN_ID,
            recipient,
            amount,
            4294967295u32
        );
        return finalize_mint_public(mint_public_future);
    }
    async function finalize_mint_public(mint_public_future: Future) {
        mint_public_future.await();
    }
}
