// SPDX-License-Identifier: MIT
pragma solidity ^0.4.21;

import "../contracts/ctf-1.sol";

/**
 * @dev this challenge has a classic underflow bug
 * @dev the contract transfers from `msg.sender` instead of `from` - in transferFrom
 * @dev this leads to underflow if bal(msg.sender) > value
 *
 * @dev run with echidna test/ctf-1.sol --contract TestWhale
 */
contract TestWhale is TokenWhaleChallenge {
    function TestWhale() public TokenWhaleChallenge(msg.sender) {}

    // isComplete = true -> means that the msg.sender has received > 1M tokens
    function echidna_test_1M_tokens() public returns (bool) {
        return !isComplete();
    }
}
