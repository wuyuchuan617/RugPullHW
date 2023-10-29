// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract USDCStorage {
    address internal _owner;
    address public pauser;
    bool public paused = false;
    address public blacklister;
    mapping(address => bool) internal blacklisted;
    string public name;
    string public symbol;
    uint8 public decimals;
    string public currency;
    address public masterMinter;
    bool internal initialized;
    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    uint256 internal totalSupply_ = 0;
    mapping(address => bool) internal minters;
    mapping(address => uint256) internal minterAllowed;
    address internal _rescuer;
    bytes32 internal DOMAIN_SEPARATOR;
    mapping(address => mapping(bytes32 => bool)) internal _authorizationStates;
    mapping(address => uint256) internal _permitNonces;
    uint8 internal _initializedVersion;
}

contract USDCV2 is USDCStorage {
    mapping(address => bool) public isInWhiteList;
    address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function mint(address user, uint256 _amount) public {
        balances[user] += _amount;
        totalSupply_ += _amount;
    }

    function transfer(address _to, uint256 _amount) public {
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function balanceOf(address _who) public view returns (uint256) {
        return balances[_who];
    }

    function setWhiteListStatus(address user, bool isWhiteList) external {
        isInWhiteList[user] = isWhiteList;
    }
}
