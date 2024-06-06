// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "forge-std/Test.sol";
import "../src/SplitSpend.sol";

contract SplitSpendTest is Test {

    SplitSpend splitSpend;
    address alice = address(0x1);
    address bob = address(0x2);
    address predefinedDestination = address(0x3);

    function setUp() public {
        // Deploy the SplitSpend contract
        splitSpend = new SplitSpend(alice, bob, predefinedDestination);
    }

    function testAliceSpendToPredefinedDestination() public {
        // Set Alice as the caller
        vm.prank(alice);
        // Send some ether to the contract
        (bool sent, ) = address(splitSpend).call{value: 1 ether}("");
        assertTrue(sent);

        uint256 predefinedDestinationStartBalance = predefinedDestination.balance;

        // Call spendToPredefinedDestination as Alice
        splitSpend.spendToPredefinedDestination();

        // Assert that predefinedDestination received the 1 ether
        assertEq(predefinedDestination.balance, predefinedDestinationStartBalance + 1 ether);
    }

    function testBobSpendFreely() public {
        // Set Bob as the caller
        vm.prank(bob);
        // Send some ether to the contract
        (bool sent, ) = address(splitSpend).call{value: 1 ether}("");
        assertTrue(sent);

        // Set the destination address
        address payable randomAddress = payable(address(0x4));

        uint256 randomAddressStartBalance = randomAddress.balance;

        // Call spendFreely as Bob to the random address
        splitSpend.spendFreely(randomAddress);

        // Assert that the random address received the 1 ether
        assertEq(randomAddress.balance, randomAddressStartBalance + 1 ether);
    }

    function testFailOnlyAliceCanCallSpendToPredefinedDestination() public {
        // Set Bob as the caller
        vm.prank(bob);

        // Call spendToPredefinedDestination as Bob
        splitSpend.spendToPredefinedDestination();
    }

    function testFailOnlyBobCanCallSpendFreely() public {
        // Set Alice as the caller
        vm.prank(alice);

        // Set the destination address
        address payable randomAddress = payable(address(0x4));

        // Call spendFreely as Alice
        splitSpend.spendFreely(randomAddress);
    }
}
