// docs:start:setup
use dep::aztec::macros::aztec;

#[aztec]
pub contract KinkySwapEscrow {
    // docs:end:setup
    // docs:start:imports
    use aztec::macros::{functions::{initializer, private, public, utility, view}, storage::storage};
    use aztec::prelude::{AztecAddress, Map, PublicMutable, PrivateMutable};
    use aztec::protocol_types::{
        abis::function_selector::FunctionSelector,
        traits::{FromField, ToField, Deserialize, Packable, Serialize},
        hash::poseidon2_hash
    };
    use value_note::{balance_utils, value_note::ValueNote};
    use std::hash;
    use token::Token;
    use std::meta::derive;
    // docs:end:imports

    #[derive(Serialize, Deserialize, Packable)]
    struct Escrow {
        token_address: AztecAddress, // The token ID of the escrowed token
        amount: u128, // The amount of the escrowed token
        withdraw_block: u32, // The max block number until the escrow is locked
        taker: AztecAddress, // The address of the taker

    }
    // Constructs the contract.
    #[private]
    #[initializer]
    fn constructor() {}

    // docs:start:storage_struct
    #[storage]
    struct Storage<Context> {
        escrow_ids: Map<Field, PublicMutable<Escrow, Context>, Context>,
    }
    // docs:end:storage_struct

    // docs:start:escrow
    #[public]
    fn escrow(
        hashlock: Field,
        token_address: AztecAddress,
        amount: u128,
        nonce: Field,
        withdraw_block: u32,
        taker: AztecAddress,
    ) {
        //let hashlock = poseidon2_hash([secret]);
        Token::at(token_address)
            .transfer_in_public(
                context.msg_sender(),
                context.this_address(),
                amount,
                nonce,
            )
            .call(&mut context);

        // check that does not exist
        let storedEscrow_loc = storage.escrow_ids.at(hashlock);
        let mut storedEscrow: Escrow = storedEscrow_loc.read();
        assert(storedEscrow.token_address == AztecAddress::zero(), "Escrow already exists");

        // Store new Escrow
        let escrow = Escrow {
            token_address: token_address,
            amount,
            withdraw_block,
            taker,
        };
        storedEscrow_loc.write(escrow);
    }
    // docs:end:escrow

    // docs:start:withdraw
    #[public]
    fn withdraw(
        secret: Field,
        recipient: AztecAddress
    ) {
        let hashlock = poseidon2_hash([secret]);

        // check that does not exist
        let storedEscrow_loc = storage.escrow_ids.at(hashlock);
        let mut storedEscrow: Escrow = storedEscrow_loc.read();
        assert(storedEscrow.token_address != AztecAddress::zero(), "Wrong token address");

        if (context.block_number() as u32 < storedEscrow.withdraw_block) {
            assert(storedEscrow.taker == recipient, "Only taker can withdraw");
        }


        Token::at(storedEscrow.token_address)
            .transfer_in_public(
                context.this_address(),
                recipient,
                storedEscrow.amount,
                0,
            )
            .call(&mut context);

        //  Clean escrow
        storedEscrow_loc.write(Escrow {
            token_address: AztecAddress::zero(),
            amount: 0,
            withdraw_block: 0,
            taker: AztecAddress::zero(),
        });
    }
    // docs:end:escrow

}
