// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "lib/solmate/src/tokens/ERC20.sol";

contract FrostToken is ERC20("Frost Protocol Token", "FRST", 18) {
    address public architect;
    uint256 public constant PI = 3.14159265 * 10**18;

    constructor() {
        architect = msg.sender;
        _mint(msg.sender, 33000000 * 10**18);
    }

    function airdropPi(address recipient) external {
        require(msg.sender == architect, "NOT_ARCHITECT");
        _transfer(architect, recipient, PI);
    }
}
