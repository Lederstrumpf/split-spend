// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SplitSpend {

    address public alice;
    address public bob;
    address public predefinedDestination;
    address payable owner;

    // TODO: support ERC20 tokens
    constructor(address _alice, address _bob, address _predefinedDestination) {
        owner = payable(msg.sender);
        alice = _alice;
        bob = _bob;
        predefinedDestination = _predefinedDestination;
    }

    // Alice can transfer the contract balance to the predefined destination address.
    function spendToPredefinedDestination() external payable {
        require(msg.sender == alice, "Only Alice can call this function.");
        bool sent = payable(predefinedDestination).send(address(this).balance);
        require(sent, "Failed to send ETH");
    }

    // Bob can transfer the contract balance to any address he chooses.
    function spendFreely(address payable _to) external {
        require(msg.sender == bob, "Only Bob can call this function.");
        bool sent = _to.send(address(this).balance);
        require(sent, "Failed to send ETH");
    }

    // TODO: replace to handle ERC20 tokens
    function close() public {
        require(msg.sender == owner, "Only the contract owner can call this function");
        selfdestruct(owner);
    }

    // Fallback function to receive ether.
    receive() external payable {}

    // Fallback function for any other calls.
    fallback() external payable {}
}
