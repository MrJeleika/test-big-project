// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    address public vault;

    constructor(address _vault) ERC20("Reward Token", "RWD") {
        vault = _vault;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == vault, "Only vault can mint");
        _mint(to, amount);
    }
}
