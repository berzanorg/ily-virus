// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IlyVirus} from "../src/IlyVirus.sol";

contract IlyVirusTest is Test {
    IlyVirus public ilyVirus;
    address public berzan;
    address public medusa;
    address public kenobi;
    address public zayn;

    function setUp() public {
        berzan = makeAddr("berzan");
        medusa = makeAddr("medusa");
        kenobi = makeAddr("kenobi");
        zayn = makeAddr("zayn");
        ilyVirus = new IlyVirus(berzan);
    }

    function test_Constructor() public view {
        assertEq(ilyVirus.name(), "ily");
        assertEq(ilyVirus.symbol(), "ily");
        assertEq(
            ilyVirus.tokenURI(0),
            "ipfs://bafybeibqqpfuj5fchcjelgshooz6riafigjtuvgqm77gwwaq2jywwyqpim/ily.json"
        );
        assertEq(
            ilyVirus.tokenURI(999),
            "ipfs://bafybeibqqpfuj5fchcjelgshooz6riafigjtuvgqm77gwwaq2jywwyqpim/ily.json"
        );
        assertEq(ilyVirus.totalSupply(), 1);
        assertEq(ilyVirus.balanceOf(berzan), 1);
        assertEq(ilyVirus.ownerOf(0), berzan);
    }

    function test_Infections() public {
        vm.startPrank(berzan);

        vm.expectEmit(true, true, true, true);
        emit IlyVirus.Transfer(berzan, medusa, 1);

        vm.expectEmit(true, true, true, true);
        emit IlyVirus.Transfer(medusa, berzan, 2);

        ilyVirus.transferFrom(berzan, medusa, 0);

        assertEq(ilyVirus.totalSupply(), 3);
        assertEq(ilyVirus.balanceOf(berzan), 2);
        assertEq(ilyVirus.balanceOf(medusa), 1);
        assertEq(ilyVirus.ownerOf(0), berzan);
        assertEq(ilyVirus.ownerOf(1), medusa);
        assertEq(ilyVirus.ownerOf(2), berzan);

        vm.startPrank(medusa);

        vm.expectEmit(true, true, true, true);
        emit IlyVirus.Transfer(medusa, kenobi, 3);

        vm.expectEmit(true, true, true, true);
        emit IlyVirus.Transfer(kenobi, berzan, 4);

        vm.expectEmit(true, true, true, true);
        emit IlyVirus.Transfer(kenobi, medusa, 5);

        ilyVirus.transferFrom(medusa, kenobi, 1);

        assertEq(ilyVirus.totalSupply(), 6);
        assertEq(ilyVirus.balanceOf(berzan), 3);
        assertEq(ilyVirus.balanceOf(medusa), 2);
        assertEq(ilyVirus.balanceOf(kenobi), 1);
        assertEq(ilyVirus.ownerOf(0), berzan);
        assertEq(ilyVirus.ownerOf(1), medusa);
        assertEq(ilyVirus.ownerOf(2), berzan);
        assertEq(ilyVirus.ownerOf(3), kenobi);
        assertEq(ilyVirus.ownerOf(4), berzan);
        assertEq(ilyVirus.ownerOf(5), medusa);

        vm.startPrank(berzan);

        vm.expectEmit(true, true, true, true);
        emit IlyVirus.Transfer(berzan, zayn, 6);

        vm.expectEmit(true, true, true, true);
        emit IlyVirus.Transfer(zayn, berzan, 7);

        ilyVirus.transferFrom(berzan, zayn, 0);

        assertEq(ilyVirus.totalSupply(), 8);
        assertEq(ilyVirus.balanceOf(berzan), 4);
        assertEq(ilyVirus.balanceOf(medusa), 2);
        assertEq(ilyVirus.balanceOf(kenobi), 1);
        assertEq(ilyVirus.balanceOf(zayn), 1);
        assertEq(ilyVirus.ownerOf(0), berzan);
        assertEq(ilyVirus.ownerOf(1), medusa);
        assertEq(ilyVirus.ownerOf(2), berzan);
        assertEq(ilyVirus.ownerOf(3), kenobi);
        assertEq(ilyVirus.ownerOf(4), berzan);
        assertEq(ilyVirus.ownerOf(5), medusa);
        assertEq(ilyVirus.ownerOf(6), zayn);
        assertEq(ilyVirus.ownerOf(7), berzan);
    }

    function test_CannotInfectWhenNotInfected() public {
        vm.startPrank(medusa);

        vm.recordLogs();

        ilyVirus.transferFrom(medusa, kenobi, 0);

        assertEq(vm.getRecordedLogs().length, 0);
    }

    function test_CannotSelfInfect() public {
        vm.startPrank(berzan);

        vm.recordLogs();

        ilyVirus.transferFrom(berzan, berzan, 0);

        assertEq(vm.getRecordedLogs().length, 0);
        assertEq(ilyVirus.totalSupply(), 1);
        assertEq(ilyVirus.balanceOf(berzan), 1);
        assertEq(ilyVirus.ownerOf(0), berzan);
    }

    function test_CannotReinfect() public {
        vm.startPrank(berzan);

        ilyVirus.transferFrom(berzan, medusa, 0);

        vm.recordLogs();

        ilyVirus.transferFrom(berzan, medusa, 0);

        assertEq(vm.getRecordedLogs().length, 0);
        assertEq(ilyVirus.totalSupply(), 3);
        assertEq(ilyVirus.balanceOf(berzan), 2);
        assertEq(ilyVirus.balanceOf(medusa), 1);
        assertEq(ilyVirus.ownerOf(0), berzan);
        assertEq(ilyVirus.ownerOf(1), medusa);
        assertEq(ilyVirus.ownerOf(2), berzan);
        assertEq(ilyVirus.ownerOf(3), address(0));
        assertEq(ilyVirus.ownerOf(4), address(0));

        vm.startPrank(medusa);

        ilyVirus.transferFrom(medusa, kenobi, 1);

        assertEq(ilyVirus.totalSupply(), 6);
        assertEq(ilyVirus.balanceOf(kenobi), 1);
        assertEq(ilyVirus.balanceOf(berzan), 3);
        assertEq(ilyVirus.balanceOf(medusa), 2);
        assertEq(ilyVirus.ownerOf(3), kenobi);
        assertEq(ilyVirus.ownerOf(4), berzan);
        assertEq(ilyVirus.ownerOf(5), medusa);
        assertEq(ilyVirus.ownerOf(6), address(0));
        assertEq(ilyVirus.ownerOf(7), address(0));

        vm.recordLogs();

        ilyVirus.transferFrom(medusa, kenobi, 1);
        assertEq(ilyVirus.totalSupply(), 6);
        assertEq(ilyVirus.balanceOf(kenobi), 1);
        assertEq(ilyVirus.balanceOf(berzan), 3);
        assertEq(ilyVirus.balanceOf(medusa), 2);
        assertEq(ilyVirus.ownerOf(3), kenobi);
        assertEq(ilyVirus.ownerOf(4), berzan);
        assertEq(ilyVirus.ownerOf(5), medusa);
        assertEq(ilyVirus.ownerOf(6), address(0));
        assertEq(ilyVirus.ownerOf(7), address(0));

        assertEq(vm.getRecordedLogs().length, 0);
    }
}
