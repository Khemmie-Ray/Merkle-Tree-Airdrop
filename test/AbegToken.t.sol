// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2, stdJson} from "forge-std/Test.sol";

import {Merkle} from "../src/AbegToken.sol";

contract AbegTest is Test {
    using stdJson for string;
    Merkle public merkle;
    struct Result {
        bytes32 leaf;
        bytes32[] proof;
    }

    struct User {
        address user;
        uint tokenid;
        uint amount;
    }
    Result public result;
    User public user;
    bytes32 root =
        0xc8bcdf73367ab0f0f3d21a050b2e0aab2fb48ac51c94630923886863e9c773e6;
    address user1 = 0x33eBBBF31bFbFdD116daEfDC69a26EB97955Bf7C;

    function setUp() public {
        merkle = new Merkle(root);
        string memory _root = vm.projectRoot();
        string memory path = string.concat(_root, "/merkle_tree.json");

        string memory json = vm.readFile(path);
        string memory data = string.concat(_root, "/address_data.json");

        string memory dataJson = vm.readFile(data);

        bytes memory encodedResult = json.parseRaw(
            string.concat(".", vm.toString(user1))
        );
        user.user = vm.parseJsonAddress(
            dataJson,
            string.concat(".", vm.toString(user1), ".address")
        );
        user.tokenid = vm.parseJsonUint(
            dataJson,
            string.concat(".", vm.toString(user1), ".tokenid")
        );
        user.amount = vm.parseJsonUint(
            dataJson,
            string.concat(".", vm.toString(user1), ".amount")
        );
        result = abi.decode(encodedResult, (Result));
        console2.logBytes32(result.leaf);
    }

    function testClaimed() public {
        bool success = merkle.claim(user.user, user.tokenid, user.amount, result.proof);
        assertTrue(success);
    }

    function testAlreadyClaimed() public {
        merkle.claim(user.user, user.tokenid, user.amount, result.proof);
        vm.expectRevert("already claimed");
        merkle.claim(user.user, user.tokenid, user.amount, result.proof);
    }

    function testIncorrectProof() public {
        bytes32[] memory fakeProofleaveitleaveit;

        vm.expectRevert("not whitelisted");
        merkle.claim(user.user, user.amount, user.tokenid, fakeProofleaveitleaveit);
    }
}
