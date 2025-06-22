// The 'test_kinky_swap_escrow_v0' test program.
import kinky_swap_escrow_v0.aleo;
program test_kinky_swap_escrow_v0.aleo {
    @test
    script test_it() {
        let result: u32 = kinky_swap_escrow_v0.aleo/main(1u32, 2u32);
        assert_eq(result, 3u32);
    }

    @test
    @should_fail
    transition do_nothing() {
        let result: u32 = kinky_swap_escrow_v0.aleo/main(2u32, 3u32);
        assert_eq(result, 3u32);
    }
}
