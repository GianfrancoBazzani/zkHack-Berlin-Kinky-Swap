use aztec::macros::{functions::{initializer, private}, storage::storage};
use aztec::prelude::{AztecAddress, Map};
use value_note::{value_note::ValueNote, balance_utils};
use easy_private_state::EasyPrivateUint;

#[storage]
struct Storage<Context> {
    // Mapping from user to locked amount
    locked: Map<AztecAddress, ValueNote<Context>, Context>,
    // Mapping from user to hashlock
    hashlocks: Map<AztecAddress, EasyPrivateUint<Context>, Context>,
    // Mapping from user to deadline
    deadlines: Map<AztecAddress, EasyPrivateUint<Context>, Context>,
}

#[contract]
mod kinky_aztec_htlc {

    use super::*;

    /// Called by maker to lock tokens with hashlock and deadline
    #[private]
    fn lock_tokens(
        user: AztecAddress,
        amount: u64,
        hashlock: u64,
        deadline: u64,
        sender: AztecAddress
    ) {
        storage.locked.at(user).add(amount, user, sender);
        storage.hashlocks.at(user).add(hashlock, user, sender);
        storage.deadlines.at(user).add(deadline, user, sender);
    }

    /// Called by taker to claim with preimage if valid before deadline
    #[private]
    fn claim(user: AztecAddress, secret: u64, now: u64, sender: AztecAddress) {
        let hash = hash_secret(secret);
        let stored_hash = balance_utils::get_balance(storage.hashlocks.at(user).set);
        let stored_deadline = balance_utils::get_balance(storage.deadlines.at(user).set);

        assert(hash == stored_hash);
        assert(now <= stored_deadline);

        storage.locked.at(user).remove(0, user, sender); // Burn value
    }

    /// Pedersen hash mimic
    unconstrained fn hash_secret(secret: u64) -> u64 {
        secret * 1337 // placeholder hash
    }
}
