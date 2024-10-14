// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SimpleStorage {
    uint256 public storedData;
    address public owner;

    event Set(string message);

    constructor() {
        storedData = 10;
        owner = msg.sender;
    }

    modifier only_owner() {
        require(msg.sender == owner,"You are not the owner");
        _;
    }

    function set(uint256 x) public only_owner{
    storedData = x;
    emit Set("New value set.");
    }

    function get() public view returns (uint256) {
    return storedData;
    }

    receive() external payable only_owner{ }
}