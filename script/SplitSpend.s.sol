// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.7 <0.9.0;

import "forge-std/Script.sol";
import "../src/SplitSpend.sol";

contract SplitSpendDeploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address alice = vm.envAddress("ALICE");
        address bob = vm.envAddress("BOB");
        address predefined_destination = vm.envAddress("PREDEFINED_DESTINATION");

        SplitSpend splitspend = new SplitSpend(alice, bob, predefined_destination);

        vm.stopBroadcast();
    }
}
