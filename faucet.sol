// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Our first contract is a faucet contract Faucet {
contract Faucet {
    // Our first contract is a faucet contract Faucet {
    address owner;
    constructor() {
    owner = msg.sender;
    }
    modifier only_owner() {
        require(msg.sender == owner, "Not the owner!");
        _;
    }

    // Give out ether to anyone who asks
    function withdraw(uint256 withdraw_amount) public only_owner {
        // Limit withdrawal amount
        require(withdraw_amount <= 1 ether);
        // Send the amount to the address that request it
        payable(msg.sender).transfer(withdraw_amount);  
    }
    function transfer(address payable _to, uint256 _amount) public only_owner {
        _to.transfer(_amount);
    }

    receive() external payable {}
}