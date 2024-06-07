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

        // Send some ether to the contract
        (bool sent, ) = address(splitSpend).call{value: 1 ether}("");
        assertTrue(sent);
    }

    function testAliceSpendToPredefinedDestination() public {
        uint256 predefinedDestinationStartBalance = predefinedDestination.balance;

        // Set Alice as the caller
        vm.prank(alice);

        // Call spendToPredefinedDestination as Alice
        splitSpend.spendToPredefinedDestination();

        // Assert that predefinedDestination received the 1 ether
        assertEq(predefinedDestination.balance, predefinedDestinationStartBalance + 1 ether);
    }

    function testBobSpendFreely() public {
        // Set the destination address
        address payable arbitraryAddress = payable(address(0x4));

        uint256 arbitraryAddressStartBalance = arbitraryAddress.balance;

        // Set Bob as the caller
        vm.prank(bob);

        // Call spendFreely as Bob to the random address
        splitSpend.spendFreely(arbitraryAddress);

        // Assert that the random address received the 1 ether
        assertEq(arbitraryAddress.balance, arbitraryAddressStartBalance + 1 ether);
    }

    function testFailOnlyAliceCanCallSpendToPredefinedDestination() public {
        uint256 predefinedDestinationStartBalance = predefinedDestination.balance;

        // Set Bob as the caller
        vm.prank(bob);

        // Call spendToPredefinedDestination as Bob
        splitSpend.spendToPredefinedDestination();

        assertEq(predefinedDestination.balance, predefinedDestinationStartBalance);
    }

    function testFailOnlyBobCanCallSpendFreely() public {
        // Set the destination address
        address payable arbitraryAddress = payable(address(0x4));

        uint256 arbitraryAddressStartBalance = arbitraryAddress.balance;

        // Set Alice as the caller
        vm.prank(alice);

        // Call spendFreely as Alice
        splitSpend.spendFreely(arbitraryAddress);

        assertEq(arbitraryAddressStartBalance, arbitraryAddress.balance);
    }
}
