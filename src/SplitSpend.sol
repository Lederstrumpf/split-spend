// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SplitSpend {

    address public alice;
    address public bob;
    address public predefinedDestination;

    constructor(address _alice, address _bob, address _predefinedDestination) {
        alice = _alice;
        bob = _bob;
        predefinedDestination = _predefinedDestination;
    }

    // Alice can transfer the contract balance to the predefined destination address.
    function spendToPredefinedDestination() external {
        require(msg.sender == alice, "Only Alice can call this function.");
        payable(predefinedDestination).transfer(address(this).balance);
    }

    // Bob can transfer the contract balance to any address he chooses.
    function spendFreely(address payable _to) external {
        require(msg.sender == bob, "Only Bob can call this function.");
        _to.transfer(address(this).balance);
    }

    // Fallback function to receive ether.
    receive() external payable {}

    // Fallback function for any other calls.
    fallback() external payable {}
}
