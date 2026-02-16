// FAI_ALPHA_FTC_PLACEMENT.move
module frost_authority::ftc_liquidity {
    use iota::coin::{Self, TreasuryCap};
    use iota::transfer;
    use iota::tx_context::{Self, TxContext};

    /// The ♍ Engine Logic Gate for $1M Round
    struct FTC has drop {}

    fun init(witness: FTC, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness, 
            9, 
            b"FTC", 
            b"Frost Token Currency", 
            b"Unix-backed ecosystem liquidity", 
            option::none(), 
            ctx
        );
        transfer::public_freeze_object(metadata);
        
        // Minting the $1M Liquidity Placement
        coin::mint_and_transfer(&mut treasury, 1000000000000000, tx_context::sender(ctx), ctx);
        transfer::public_share_object(treasury);
    }
}
