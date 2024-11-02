// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// Paper-scissor-stone game contract
contract Faucet {
    // Ddefine player info
    struct Player{
        address player_EOA;
        uint256 balance;
        uint8 choice;
        bool isReady;
    }
    address deployer_address;
    Player public player_a;
    Player public player_b;
    string result;

    //initialte players' addresses
    constructor(address a, address b){
        player_a.player_EOA = a;
        player_b.player_EOA = b;
        deployer_address = msg.sender;
    }

    //To judge if the EOA is one of the two players.
    modifier only_player() {
        require(msg.sender == player_a.player_EOA || msg.sender == player_b.player_EOA,"You are not one of the players.");
        _;
    }
    //To make sure that both EOAs have already sent enough ETH to the contract.
    modifier enough_balance() {
        require(player_a.balance >= 0.1 ether && player_b.balance >= 0.1 ether, "one of the players hasn't sent enough ETH to the contract.");
        _;
    }

    function compareString(string memory str1,string memory str2) pure private returns(bool){
        return keccak256(abi.encodePacked(str1))==keccak256(abi.encodePacked(str2));
    }
    
    function translate(string calldata choice) pure private returns(uint8){
        if(compareString(choice, "paper")) return 0;
        else if(compareString(choice, "scissor")) return 1;
        else return 2;
    }

    function judge() internal view returns(string memory){
        if(player_a.choice == player_b.choice) return "equal";
	    else
	    {
	    	//The number 0 means paper, and the number 2 means stone.
	    	if(player_a.choice == 2 && player_b.choice == 0) return "palyer_b wins.";
		    else if(player_a.choice == 0 && player_b.choice == 2) return "player_a wins.";
		    else//The greater one wins.
		    {
				if(player_a.choice < player_b.choice) return "player_b wins.";
				else return "player_a wins.";
		    }
        }  
    }
        
    function play(string calldata choice) external only_player{
        require(compareString(choice, "paper")||compareString(choice, "scissor")||compareString(choice, "stone"),"Please input correct format.");
        if(msg.sender == player_a.player_EOA){
            player_a.choice = translate(choice);
            player_a.isReady = true;
        }
        else if(msg.sender == player_b.player_EOA){
            player_b.choice = translate(choice);
            player_b.isReady = true;
        }

        if(player_a.isReady && player_b.isReady){ //To make sure both EOAs have already called the function
            result = judge();
            if(compareString(result, "player_a wins.")){
                payable(player_a.player_EOA).transfer(0.2 ether);
            }
            else if(compareString(result, "player_b wins.")){
                payable(player_b.player_EOA).transfer(0.2 ether);
            }
            else{
                payable(player_a.player_EOA).transfer(0.08 ether);
                payable(player_b.player_EOA).transfer(0.08 ether);
            }
        }
        // selfdestruct(payable(deployer_address));
    }
    receive() external payable only_player{ //Only players can send ETH to the contract
        if(msg.sender == player_a.player_EOA) player_a.balance += msg.value;
        else if(msg.sender == player_b.player_EOA) player_b.balance += msg.value;
    }
}