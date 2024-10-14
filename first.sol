// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SimpleStorage {
    uint256 public storedData;
    address public owner;

    constructor() {
        storedData = 10;
        owner = msg.sender;
    }

    modifier only_owner() {
        require(msg.sender == owner,"you are not the owner");
        _;
    }

    function set(uint256 x) public only_owner{
    storedData = x;
    }

    function get() public view returns (uint256) {
    return storedData;
    }
}