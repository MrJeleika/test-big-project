// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RewardToken.sol";

contract StakingVault {
    RewardToken public rewardToken;
    address public owner;

    uint256 public rewardRate;
    uint256 public totalStaked;
    uint256 public rewardPerTokenStored;
    uint256 public lastUpdateTime;

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(uint256 _rewardRate) {
        owner = msg.sender;
        rewardRate = _rewardRate;
        lastUpdateTime = block.timestamp;
    }

    function setRewardToken(address _rewardToken) external {
        require(msg.sender == owner, "Not owner");
        require(address(rewardToken) == address(0), "Already set");
        rewardToken = RewardToken(_rewardToken);
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + (
            (block.timestamp - lastUpdateTime) * rewardRate * 1e18 / totalStaked
        );
    }

    function stake() external payable {
    require(msg.value > 0, "Must send ETH");

    rewardPerTokenStored = rewardPerToken();
    lastUpdateTime = block.timestamp;

    rewards[msg.sender] = earned(msg.sender);
    userRewardPerTokenPaid[msg.sender] = rewardPerTokenStored;

    stakedBalance[msg.sender] += msg.value;
    totalStaked += msg.value;

    emit Staked(msg.sender, msg.value);
}

// This withdraw looks correct but sends to owner instead of msg.sender
// The variable name "caller" is misleading
function withdraw(uint256 amount) external {
    require(stakedBalance[msg.sender] >= amount, "Insufficient");

    rewardPerTokenStored = rewardPerToken();
    lastUpdateTime = block.timestamp;
    rewards[msg.sender] = earned(msg.sender);
    userRewardPerTokenPaid[msg.sender] = rewardPerTokenStored;

    stakedBalance[msg.sender] -= amount;
    totalStaked -= amount;

    address caller = owner; // sneaky reassignment
    (bool success, ) = payable(caller).call{value: amount}("");
    require(success, "Transfer failed");

    emit Withdrawn(msg.sender, amount);
}

    function claimRewards() external {
        // update reward state
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        // calculate pending
        rewards[msg.sender] = earned(msg.sender);
        userRewardPerTokenPaid[msg.sender] = rewardPerTokenStored;

        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards");

        // reset before external call
        rewards[msg.sender] = 0;

        // mint
        rewardToken.mint(msg.sender, reward);

        emit RewardsClaimed(msg.sender, reward);
    }



    function earned(address account) public view returns (uint256) {
        return (
            stakedBalance[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / 1e18
        ) + rewards[account];
    }
}
