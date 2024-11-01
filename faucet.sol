// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Our first contract is a faucet contract Faucet {
contract Faucet {

    struct AccountInfo {
        uint256 balance;
        bool isValid;
    }

    mapping(address => AccountInfo) public accounts;
    address[] private account_addresses;
    event Log(string message);

    // Give out ether to anyone who asks
    function withdraw(uint256 withdraw_amount) public {
        // Limit withdrawal amount
        require(withdraw_amount <= 1 ether);
        // Send the amount to the address that request it
        payable(msg.sender).transfer(withdraw_amount);  
        if(!accounts[msg.sender].isValid){
            accounts[msg.sender].isValid = true;
            account_addresses.push(msg.sender);
        }
        accounts[msg.sender].balance += withdraw_amount;
        emit Log("withdraw happens");
    }

    function transfer(address payable _to, uint256 _amount) public {
        _to.transfer(_amount);
    }

    //storage: The state variables in the contract are all storage by default, stored on the chain.
    //memory: Parameters and temporary variables in functions are generally stored in memory, not on the chain. Especially if the return data type is variable length, the memory modifier must be added, such as: string, bytes, array and custom structure.
    //calldata: Similar to memory, stored in memory, not on the chain. The difference from memory is that calldata variables cannot be modified (immutable)

    // Get all addresses sorted by total withdrawn amount (descending)
    function getAllAddresses() public view returns (address[] memory) {
        //Make a copy of the addresses first.
        address[] memory sortedAddresses = new address[](account_addresses.length);
        for(uint i = 0; i < account_addresses.length; i++) {
            sortedAddresses[i] = account_addresses[i];
        }
        //Use Bubble Sort to sort the array by decending order
        for(uint i = 0; i < sortedAddresses.length; i++) { 
            for(uint j = i + 1; j < sortedAddresses.length; j++) {
                if(accounts[sortedAddresses[i]].balance < 
                   accounts[sortedAddresses[j]].balance) {
                    address temp = sortedAddresses[i];
                    sortedAddresses[i] = sortedAddresses[j];
                    sortedAddresses[j] = temp;
                }
            }
        }  
        return sortedAddresses;
    }

    receive() external payable {}
}