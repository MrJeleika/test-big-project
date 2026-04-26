
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TipJar {
    uint256 public totalTips;

    event TipReceived(address sender, uint256 amount);
    event Withdra(address owner, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function tip() public payable {
        require(msg.value > 0, "Must send ETH");
        totalTips += msg.value;
        emit TipReceived(msg.sender, msg.value);

    }

    function withdraw() public {

        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");
        emit Withdra(owner, balance);


    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
