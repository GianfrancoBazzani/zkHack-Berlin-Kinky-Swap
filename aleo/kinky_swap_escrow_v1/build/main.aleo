import credits.aleo;
import token_registry.aleo;
program kinky_swap_escrow_v1.aleo;

struct TokenMetadata:
    token_id as field;
    name as u128;
    symbol as u128;
    decimals as u8;
    supply as u128;
    max_supply as u128;
    admin as address;
    external_authorization_required as boolean;
    external_authorization_party as address;

struct TokenOwner:
    account as address;
    token_id as field;

struct Escrow:
    token_id as field;
    amount as u128;
    withdraw_block as u32;
    taker as address;

mapping self_address_map:
    key as field.public;
    value as address.public;

mapping escrow_ids:
    key as field.public;
    value as Escrow.public;

function set_self_address:
    input r0 as address.private;
    assert.eq self.caller aleo1zwmh60286u8fhcagjwvvtr2es73j4ws372jarzvn644pycljaygqszla6u;
    async set_self_address r0 into r1;
    output r1 as kinky_swap_escrow_v1.aleo/set_self_address.future;

finalize set_self_address:
    input r0 as address.public;
    set r0 into self_address_map[0field];

function escrow_from_public:
    input r0 as field.private;
    input r1 as field.private;
    input r2 as u128.private;
    input r3 as u32.private;
    input r4 as address.private;
    input r5 as address.private;
    hash.psd2 r0 into r6 as field;
    call token_registry.aleo/transfer_from_public r1 self.caller r5 r2 into r7;
    async escrow_from_public r6 r1 r2 r3 r4 r7 r5 into r8;
    output r8 as kinky_swap_escrow_v1.aleo/escrow_from_public.future;

finalize escrow_from_public:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as u128.public;
    input r3 as u32.public;
    input r4 as address.public;
    input r5 as token_registry.aleo/transfer_from_public.future;
    input r6 as address.public;
    await r5;
    get self_address_map[0field] into r7;
    assert.eq r7 r6;
    contains escrow_ids[r0] into r8;
    not r8 into r9;
    assert.eq r9 true;
    lt block.height r3 into r10;
    assert.eq r10 true;
    cast r1 r2 r3 r4 into r11 as Escrow;
    set r11 into escrow_ids[r0];

function escrow_from_private:
    input r0 as field.private;
    input r1 as token_registry.aleo/Token.record;
    input r2 as field.private;
    input r3 as u128.private;
    input r4 as u32.private;
    input r5 as address.private;
    input r6 as address.private;
    hash.psd2 r0 into r7 as field;
    call token_registry.aleo/transfer_private_to_public r6 r3 r1 into r8 r9;
    async escrow_from_private r7 r2 r3 r4 r5 r9 r6 into r10;
    output r8 as token_registry.aleo/Token.record;
    output r10 as kinky_swap_escrow_v1.aleo/escrow_from_private.future;

finalize escrow_from_private:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as u128.public;
    input r3 as u32.public;
    input r4 as address.public;
    input r5 as token_registry.aleo/transfer_private_to_public.future;
    input r6 as address.public;
    await r5;
    get self_address_map[0field] into r7;
    assert.eq r7 r6;
    contains escrow_ids[r0] into r8;
    not r8 into r9;
    assert.eq r9 true;
    lt block.height r3 into r10;
    assert.eq r10 true;
    cast r1 r2 r3 r4 into r11 as Escrow;
    set r11 into escrow_ids[r0];

function withdraw_to_public:
    input r0 as field.private;
    input r1 as field.private;
    input r2 as address.private;
    input r3 as u128.private;
    hash.psd2 r0 into r4 as field;
    call token_registry.aleo/transfer_public r1 r2 r3 into r5;
    async withdraw_to_public r4 r1 r2 r3 r5 into r6;
    output r6 as kinky_swap_escrow_v1.aleo/withdraw_to_public.future;

finalize withdraw_to_public:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as address.public;
    input r3 as u128.public;
    input r4 as token_registry.aleo/transfer_public.future;
    contains escrow_ids[r0] into r5;
    assert.eq r5 true;
    get escrow_ids[r0] into r6;
    is.eq r6.token_id r1 into r7;
    assert.eq r7 true;
    is.eq r6.amount r3 into r8;
    assert.eq r8 true;
    lt block.height r6.withdraw_block into r9;
    branch.eq r9 false to end_then_0_0;
    is.eq r6.taker r2 into r10;
    assert.eq r10 true;
    branch.eq true true to end_otherwise_0_1;
    position end_then_0_0;
    position end_otherwise_0_1;
    remove escrow_ids[r0];
    await r4;

function withdraw_to_private:
    input r0 as field.private;
    input r1 as field.private;
    input r2 as u128.private;
    input r3 as address.private;
    hash.psd2 r0 into r4 as field;
    call token_registry.aleo/transfer_public_to_private r1 r3 r2 false into r5 r6;
    async withdraw_to_private r4 r1 self.caller r2 r6 into r7;
    output r5 as token_registry.aleo/Token.record;
    output r7 as kinky_swap_escrow_v1.aleo/withdraw_to_private.future;

finalize withdraw_to_private:
    input r0 as field.public;
    input r1 as field.public;
    input r2 as address.public;
    input r3 as u128.public;
    input r4 as token_registry.aleo/transfer_public_to_private.future;
    contains escrow_ids[r0] into r5;
    assert.eq r5 true;
    get escrow_ids[r0] into r6;
    is.eq r6.token_id r1 into r7;
    assert.eq r7 true;
    is.eq r6.amount r3 into r8;
    assert.eq r8 true;
    lt block.height r6.withdraw_block into r9;
    branch.eq r9 false to end_then_0_2;
    is.eq r6.taker r2 into r10;
    assert.eq r10 true;
    branch.eq true true to end_otherwise_0_3;
    position end_then_0_2;
    position end_otherwise_0_3;
    remove escrow_ids[r0];
    await r4;
