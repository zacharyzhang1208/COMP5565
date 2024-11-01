// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Our first contract is a faucet contract Faucet {
contract Faucet {
    address owner;
    uint256[] addresses;
    event Log(string message);

    constructor() {
        owner = msg.sender;
    }

    // Give out ether to anyone who asks
    function withdraw(uint256 withdraw_amount) public {
        // Limit withdrawal amount
        require(withdraw_amount <= 1 ether);
        // Send the amount to the address that request it
        payable(msg.sender).transfer(withdraw_amount);  
        emit Log("withdraw happens");
        addresses.push(withdraw_amount);
    }

    function transfer(address payable _to, uint256 _amount) public {
        _to.transfer(_amount);
    }

    //storage: The state variables in the contract are all storage by default, stored on the chain.
    //memory: Parameters and temporary variables in functions are generally stored in memory, not on the chain. Especially if the return data type is variable length, the memory modifier must be added, such as: string, bytes, array and custom structure.
    //calldata: Similar to memory, stored in memory, not on the chain. The difference from memory is that calldata variables cannot be modified (immutable)
    function getAllAddresses() public view returns (address[] memory){
        
    }

    receive() external payable {

    }
}