// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title RewardToken
/// @notice ERC-20 token that can only be minted by the StakingVault.

contract RewardToken is ERC20 {
    address public vault;

    constructor(address _vault) ERC20("Reward Token", "RWD") {
        vault = _vault;
    }

    /// @notice Mint reward tokens. Only the vault can call this.
    /// @param to Address to receive tokens
    /// @param amount Amount to mint (18 decimals)
    function mint(address to, uint256 amount) external {
        // TODO: implement
    }
}
