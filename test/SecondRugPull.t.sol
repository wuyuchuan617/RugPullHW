// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {USDCV2} from "../src/USDCV2.sol";

contract ForkTest is Test {
    uint256 mainnetFork;
    address user1;
    address user2;

    function setUp() public {
        user1 = makeAddr("Alice");
        user1 = makeAddr("Bob");
        deal(user1, 0);
        mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo");
    }

    function testFork() public {
        // Fork mainnet
        address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        mainnetFork = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo");
        vm.selectFork(mainnetFork);

        // prank admin and upgradeTo USDCV2
        bytes32 ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
        bytes32 admin = vm.load(address(USDC), ADMIN_SLOT);

        vm.startPrank(address(uint160(uint256(admin))));
        USDCV2 usdcV2 = new USDCV2();
        (bool success,) = address(USDC).call(abi.encodeWithSignature("upgradeTo(address)", address(usdcV2)));

        // user1 to white list
        address(usdcV2).call(abi.encodeWithSignature("setWhiteListStatus(address,bool)", user1, true));
        assertEq(usdcV2.isInWhiteList(user1), true);
        vm.stopPrank();

        // user1 mint
        vm.startPrank(user1);
        address(USDC).call(abi.encodeWithSignature("mint(address,uint256)", user1, 1));

        // check user1 balanceOf
        (bool successs, bytes memory data) = address(USDC).call(abi.encodeWithSignature("balanceOf(address)", user1));
        (uint256 user1Balance) = abi.decode(data, (uint256));
        assertEq(user1Balance, 1);

        vm.stopPrank();
    }
}

// 請假裝你是 USDC 的 Owner，嘗試升級 usdc，並完成以下功能
// 製作一個白名單
// 只有白名單內的地址可以轉帳
// 白名單內的地址可以無限 mint token
// 如果有其他想做的也可以隨時加入

// forge test --mp test/SecondRugPull.t.sol --fork-url https://eth-mainnet.g.alchemy.com/v2/S7FGzEEsfVR6BassdzCaK8PLJXl53ZTo -vvv
