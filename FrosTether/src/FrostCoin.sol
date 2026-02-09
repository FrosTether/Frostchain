// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "lib/solmate/src/tokens/ERC20.sol";

contract FrostCoin is ERC20("Frostcoin", "FTC", 18) {
    address public architect;
    mapping(address => uint256) public powerUpCredits;

    constructor() {
        architect = msg.sender;
        _mint(msg.sender, 33000000 * 10**18);
    }

    function buyPowerUps(uint256 amount) external {
        _transfer(msg.sender, architect, amount);
        powerUpCredits[msg.sender] += amount / 10**18;
    }

    function joeyBones(uint256 bet) external {
        require(balanceOf(msg.sender) >= bet, "BROKE");
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        if (seed % 100 > 51) {
            _mint(msg.sender, bet); // Jackpot
        } else {
            _burn(msg.sender, bet); // Ripped by Joey Bones
        }
    }
}
