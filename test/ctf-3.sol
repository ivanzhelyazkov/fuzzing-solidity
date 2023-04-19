// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../contracts/ctf-3.sol";

/**
 * @dev run with echidna test/ctf-3.sol --contract TestDex --config echidna-config/ctf-3.yml
 * @dev exploitable scenario:
 * @dev perform a series of swaps of t0 for t1 and t1 for t0, each with
 */
contract TestDex {
    Dex private dex;
    SwappableToken private token0;
    SwappableToken private token1;

    constructor() {
        // deploy tokens and dex
        token0 = new SwappableToken("DAI", "DAI");
        token1 = new SwappableToken("wETH", "wETH");
        dex = new Dex(address(token0), address(token1));

        // transfer 100 token 0 and token 1 to dex
        token0.transfer(address(dex), 100 ether);
        token1.transfer(address(dex), 100 ether);

        // ensure the middleman contract has exactly 10 of t0 / t1
        assert(token0.balanceOf(address(this)) == 10 ether);
        assert(token1.balanceOf(address(this)) == 10 ether);

        // ensure the dex contract has exactly 100 of t0 / t1
        assert(token0.balanceOf(address(dex)) == 100 ether);
        assert(token1.balanceOf(address(dex)) == 100 ether);

        // approve tokens
        token0.approve(address(dex), type(uint256).max);
        token1.approve(address(dex), type(uint256).max);
        dex.approve(address(dex), type(uint256).max);
    }

    function swapt0Fort1(uint swapAmount) public {
        uint availableBal = token0.balanceOf(address(this));

        // cap swap amount up to the available balance using modulo arithmetic
        swapAmount %= availableBal;

        dex.swap(address(token0), address(token1), swapAmount);
    }

    function swapt1Fort0(uint swapAmount) public {
        uint availableBal = token1.balanceOf(address(this));

        // cap swap amount up to the available balance using modulo arithmetic
        swapAmount %= availableBal;

        dex.swap(address(token1), address(token0), swapAmount);
    }

    /**
     * @dev In the case this invariant is false, the dex has been depleted of all of its token 0
     * @dev User starts with 10 token 0 / 1 and continuously swaps t0 -> t1 and t1 -> t0
     * @dev Dex starts with 100 token 0 / 1 and if he reaches 0 token 0, we have depleted the reserves
     */
    function echidna_BalanceInvariant() public view returns (bool) {
        return token0.balanceOf(address(dex)) > 0;
    }
}
