use dep::aztec::{
    macros::{
        functions::{initializer, private, public},
        storage::storage,
        aztec
    },
};
use dep::aztec::prelude::{AztecAddress, Map};
use easy_private_state::EasyPrivateUint;
use value_note::value_note::ValueNote;
use value_note::balance_utils;

#[storage]
struct Storage<Context> {
    locked: Map<AztecAddress, ValueNote<Context>, Context>,
    hashlocks: Map<AztecAddress, EasyPrivateUint<Context>, Context>,
    deadlines: Map<AztecAddress, EasyPrivateUint<Context>, Context>,
}

#[aztec]
pub contract KinkyAztecHTLC {
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

    #[private]
    fn claim(user: AztecAddress, secret: u64, now: u64, sender: AztecAddress) {
        let hash = hash_secret(secret);
        let stored_hash = balance_utils::get_balance(storage.hashlocks.at(user).set);
        let stored_deadline = balance_utils::get_balance(storage.deadlines.at(user).set);

        assert(hash == stored_hash, "Hash mismatch");
        assert(now <= stored_deadline, "Too late to claim");

        storage.locked.at(user).remove(0, user, sender); // burn or transfer
    }

    #[utility]
    unconstrained fn hash_secret(secret: u64) -> u64 {
        secret * 1337 // Placeholder hash fn (replace with Poseidon/Pedersen later)
    }
}
