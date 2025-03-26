// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IlyVirus} from "../src/IlyVirus.sol";

contract IlyVirusScript is Script {
    IlyVirus public ilyVirus;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        ilyVirus = new IlyVirus(vm.envAddress("ILY_INFECTOR"));

        vm.stopBroadcast();
    }
}
