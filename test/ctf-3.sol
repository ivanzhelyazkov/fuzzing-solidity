// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../contracts/ctf-3.sol";

/**
 * @dev run with echidna test/ctf-3.sol --contract TestDex --config echidna-config/ctf-3.yml
 * @dev exploitable scenario:
 */
contract TestDex {

    Dex private dex;
    SwappableToken private token0;
    SwappableToken private token1;

    constructor () {
        // deploy contracts
        token0 = new SwappableToken("DAI", "DAI");
        token1 = new SwappableToken("wETH", "wETH");
        dex = new Dex(address(token0), address(token1));

        // approve tokens
        token0.approve(address(dex), type(uint256).max);
        token1.approve(address(dex), type(uint256).max);
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

    // function addLiquidityToken0(uint amount) public {
    //     dex.add_liquidity(address(token0), amount);
    // }

    // function addLiquidityToken1(uint amount) public {
    //     dex.add_liquidity(address(token1), amount);
    // }
    

    function echidna_BalanceInvariant() public returns (bool) {
        return token0.balanceOf(address(dex)) < 90 ether;
    }
}