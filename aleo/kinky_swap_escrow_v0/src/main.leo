import token_registry.aleo;

// The 'kinky_swap_escrow_v0' program.
program kinky_swap_escrow_v0.aleo {
   const KINKY_SWAP_ESCROW_ADDRES: address = aleo19qtdssr2d45lfwxsy9928qn7veaw9mupntu9kg6z9h888ztvucrqg7tr5z;

    mapping escrow_ids: field => Escrow;

    struct Escrow {
        token_id: field, // The token ID of the escrowed token
        amount: u128,  // The amount of the escrowed token
        withdraw_block: u32, // The max block number until the escrow is locked
        taker: address // The address of the taker
    }

    // Escrow from Public
    async transition escrow_from_public(
            private secret: field,
            token_id: field,
            amount:u128,
            withdraw_block: u32,
            taker: address
        ) -> Future {
        let hashlock: field = Poseidon2::hash_to_field(secret);

        let transfer_future: Future = token_registry.aleo/transfer_from_public(
            token_id, 
            self.caller, 
            KINKY_SWAP_ESCROW_ADDRES, 
            amount
        );
        return finalize_escrow(
            hashlock,
            token_id,
            amount,
            withdraw_block,
            taker,
            transfer_future
        );
    } 

    // Escrow from Private
    async transition escrow_from_private(
            private secret: field,
            private token: token_registry.aleo/Token,
            token_id: field,
            amount:u128,
            withdraw_block: u32,
            taker: address
        ) -> (token_registry.aleo/Token, Future) {
        let hashlock: field = Poseidon2::hash_to_field(secret);
        
        let (change_token, transfer_future): (token_registry.aleo/Token, Future) =
            token_registry.aleo/transfer_private_to_public(
                KINKY_SWAP_ESCROW_ADDRES, 
                amount,
                token,
            );

        return 
            (
                change_token, 
                finalize_escrow(
                    hashlock,
                    token_id,
                    amount,
                    withdraw_block,
                    taker,
                    transfer_future
                )
            );
    } 

    async function finalize_escrow(
            hashlock: field, 
            token_id: field,
            amount: u128,
            withdraw_block: u32,
            taker: address,
            transfer_future: Future
        ) {
        transfer_future.await();

        let exists: bool = escrow_ids.contains(hashlock);
        assert(!exists);
        assert(block.height < withdraw_block);

        let escrow: Escrow = Escrow {
            token_id: token_id,
            amount: amount,
            withdraw_block: withdraw_block,
            taker: taker
        };
        escrow_ids.set(hashlock, escrow);
    }

    // Withdraw  to Public
    async transition withdraw_to_public(
        private secret: field,
        token_id: field,
        taker: address,
        amount: u128,
    ) -> Future {
        let hashlock: field = Poseidon2::hash_to_field(secret);

        let transfer_future: Future = token_registry.aleo/transfer_public(
            token_id, 
            taker,
            amount
        );

        return finalize_withdraw(hashlock, token_id, taker, amount, transfer_future);
    }

    // Withdraw to Private
    async transition withdraw_to_private(
        private secret: field,
        token_id: field,
        amount: u128,
        private recipient: address,
    ) -> (token_registry.aleo/Token, Future) {
        let hashlock: field = Poseidon2::hash_to_field(secret);

        let (
            token,
            transfer_future,
        ): (
            token_registry.aleo/Token, 
            Future
        ) = token_registry.aleo/transfer_public_to_private(
            token_id,
            recipient,
            amount,
            false
        );

        return (token, finalize_withdraw(hashlock, token_id, self.caller, amount, transfer_future));
        
    }
    
    async function finalize_withdraw(
        hashlock: field,
        token_id: field,
        taker: address,
        amount: u128,
        transfer_future: Future
    ) {
        let exists: bool = escrow_ids.contains(hashlock);
        assert(exists);

        let escrow: Escrow = escrow_ids.get(hashlock);
        assert(escrow.token_id == token_id);
        assert(escrow.amount == amount);

        if (block.height < escrow.withdraw_block) {
            assert(escrow.taker == taker);
        }

        escrow_ids.remove(hashlock);

        transfer_future.await();
    }
}
