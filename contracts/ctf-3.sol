// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * The user has to drain all of at least one of the two tokens - token1 and token2 from the contract.
 * The Dex starts with 100 token 1 and token 2, the player starts with 10 token 1 and token 2
 * The Dex must be drained of all token 1 or token 2 - meaning his token 1 balance should be exactly 0
 * See test/ctf-3.sol for solution
 */
contract Dex {
    using SafeMath for uint;
    address public token1;
    address public token2;

    constructor(address _token1, address _token2) {
        token1 = _token1;
        token2 = _token2;
    }

    function swap(address from, address to, uint amount) public {
        require(
            (from == token1 && to == token2) ||
                (from == token2 && to == token1),
            "Invalid tokens"
        );
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );
        uint swap_amount = get_swap_price(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swap_amount);
        IERC20(to).transferFrom(address(this), msg.sender, swap_amount);
    }

    function add_liquidity(address token_address, uint amount) public {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function get_swap_price(
        address from,
        address to,
        uint amount
    ) public view returns (uint) {
        return
            (amount * IERC20(to).balanceOf(address(this))) /
            IERC20(from).balanceOf(address(this));
    }

    function approve(address spender, uint amount) public {
        SwappableToken(token1).approve(spender, amount);
        SwappableToken(token2).approve(spender, amount);
    }

    function balanceOf(
        address token,
        address account
    ) public view returns (uint) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 110 ether);
    }
}
