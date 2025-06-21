import credits.aleo;
import token_registry.aleo;
program kinky_token.aleo;

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

function mint_public:
    input r0 as address.private;
    input r1 as u128.private;
    assert.eq self.caller aleo1zwmh60286u8fhcagjwvvtr2es73j4ws372jarzvn644pycljaygqszla6u;
    call token_registry.aleo/mint_public 3443843282313283355337459085696902919850365217539366784739393210722344986field r0 r1 4294967295u32 into r2;
    async mint_public r2 into r3;
    output r3 as kinky_token.aleo/mint_public.future;

finalize mint_public:
    input r0 as token_registry.aleo/mint_public.future;
    await r0;

function mint_private:
    input r0 as address.private;
    input r1 as u128.private;
    assert.eq self.caller aleo1zwmh60286u8fhcagjwvvtr2es73j4ws372jarzvn644pycljaygqszla6u;
    call token_registry.aleo/mint_private 3443843282313283355337459085696902919850365217539366784739393210722344986field r0 r1 false 4294967295u32 into r2 r3;
    async mint_private r3 into r4;
    output r2 as token_registry.aleo/Token.record;
    output r4 as kinky_token.aleo/mint_private.future;

finalize mint_private:
    input r0 as token_registry.aleo/mint_private.future;
    await r0;

function register:
    assert.eq self.caller aleo1zwmh60286u8fhcagjwvvtr2es73j4ws372jarzvn644pycljaygqszla6u;
    call token_registry.aleo/register_token 3443843282313283355337459085696902919850365217539366784739393210722344986field 91167321837903190160008558u128 4935243u128 6u8 1000000000u128 false aleo1zwmh60286u8fhcagjwvvtr2es73j4ws372jarzvn644pycljaygqszla6u into r0;
    async register r0 into r1;
    output r1 as kinky_token.aleo/register.future;

finalize register:
    input r0 as token_registry.aleo/register_token.future;
    await r0;
