pragma solidity ^0.4.21;

import "../contracts/ctf-2.sol";

/**
 * @dev run with echidna test/ctf-2.sol --contract TestTokenSale --config echidna-config/ctf-2.yml
 * @dev exploitable scenario:
 * @dev buyTokens > (MAX_INT / PRICE_PER_TOKEN) -> value overflows and results in a smaller number
 * @dev msg.value = buyTokens * PRICE_PER_TOKEN
 */
contract TestTokenSale is TokenSaleChallenge {

    uint256 MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    event Debug(uint val);

    constructor () public payable TokenSaleChallenge() {
    }

    function echidna_test() public view returns (bool) {
        return !isComplete();
    }

    // to test out the buy function, we need to call buy
    // with an amount that passes the
    // `require(msg.value == numTokens * PRICE_PER_TOKEN);` statement
    // so we add a function which calls buy with a special numTokens value, 
    // which always passes the require statement -
    // effectively fuzzing numTokens through msg.value
    function buyFixed() public payable {
        buy(msg.value / PRICE_PER_TOKEN);
    }
}