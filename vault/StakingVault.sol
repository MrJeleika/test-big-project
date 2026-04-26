
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RewardToken.sol";

/// @title StakingVault
/// @notice Stake ETH, earn RewardToken over time.

contract StakingVault {
    RewardToken public rewardToken;
    address public owner;

    uint256 public rewardRate;          // reward tokens per second (in wei, 18 decimals)
    uint256 public totalStaked;
    uint256 public rewardPerTokenStored;
    uint256 public lastUpdateTime;

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public userRewardPerTokenPaid; // snapshot per user
    mapping(address => uint256) public rewards;                // accumulated but unclaimed

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(uint256 _rewardRate) {
        owner = msg.sender;
        rewardRate = _rewardRate;
        lastUpdateTime = block.timestamp;
    }

    /// @notice Set the reward token address. Can only be called once by the owner.
    function setRewardToken(address _rewardToken) external {
        require(msg.sender == owner, "Not owner");
        require(address(rewardToken) == address(0), "Already set");
        rewardToken = RewardToken(_rewardToken);
    }

    // ============================================================
    //                    HELPER (given to you)
    // ============================================================

    /// @notice Calculate the current rewardPerToken value.
    /// @dev If totalStaked is 0, return the stored value (no new rewards accumulate).
    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + (
            (block.timestamp - lastUpdateTime) * rewardRate * 1e18 / totalStaked
        );
    }

    // ============================================================
    //                 YOUR TASK: implement these
    // ============================================================

    /// @notice Deposit ETH into the vault.
    /// Requirements:
    /// - Must send more than 0 ETH
    /// - Must update reward state before changing balances
    /// - Must update stakedBalance, totalStaked
    /// - Must emit Staked event
    function stake() external payable {
        // TODO: implement
    }

    /// @notice Withdraw staked ETH.
    /// @param amount Amount of ETH to withdraw (in wei)
    /// Requirements:
    /// - Must have enough staked balance
    /// - Must update reward state before changing balances
    /// - Must update stakedBalance, totalStaked
    /// - Must transfer ETH to caller
    /// - Must emit Withdrawn event
    function withdraw(uint256 amount) external {
        // TODO: implement
    }

    /// @notice Claim all pending reward tokens.
    /// Requirements:
    /// - Must update reward state
    /// - Must mint reward tokens to caller via rewardToken.mint()
    /// - Must reset caller's stored rewards to 0
    /// - Must emit RewardsClaimed event
    function claimRewards() external {
        // TODO: implement
    }

    /// @notice View function: how many reward tokens has this user earned but not claimed?
    /// @param account The user address
    /// @return Total unclaimed rewards (in wei, 18 decimals)
    function earned(address account) public view returns (uint256) {
        // TODO: implement
    }
}
