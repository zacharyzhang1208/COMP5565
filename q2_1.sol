// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Paper-scissor-stone game contract
contract Faucet {
    // Ddefine player info
    struct Player{
        address player_EOA;
        uint8 choice;
        bool isValid;
    }
    Player public player_a;
    Player public player_b;

    string result;

    //initialte players' addresses
    constructor(address a, address b){
        player_a.player_EOA = a;
        player_b.player_EOA = b;
    }

    //judge if the EOA is one of the two players
    modifier only_player() {
        require(msg.sender == player_a.player_EOA || msg.sender == player_b.player_EOA,"You are not one of the players.");
        _;
    }

    function compareString(string memory str1,string memory str2) pure public returns(bool){
        return keccak256(abi.encodePacked(str1))==keccak256(abi.encodePacked(str2));
    }
    
    function translate(string calldata choice) pure public returns(uint8){
        if(compareString(choice, "paper")){
            return 0;
        }
        else if(compareString(choice, "scissor")){
            return 1;
        }
        else return 2;
    }

    function judge() internal view returns(string memory){
        if(player_a.choice == player_b.choice) return "equal";
	    else
	    {
	    	//判断特殊情况 是否存在 一个是2 另一个是0的情况
	    	if(player_a.choice == 2 && player_b.choice == 0) return "palyer_b wins.";
		    else if(player_a.choice == 0 && player_b.choice == 2) return "player_a wins.";
		    else//The greater one wins
		    {
				if(player_a.choice < player_b.choice) return "player_b wins";
				else return "player_a wins";
		    }
        }  
    }
        

    function play(string calldata choice) external only_player{
        if(msg.sender == player_a.player_EOA){
            player_a.choice = translate(choice);
            player_a.isValid = true;
        }
        else if(msg.sender == player_b.player_EOA){
            player_b.choice = translate(choice);
            player_b.isValid = true;
        }

        if(player_a.isValid && player_b.isValid)
        {
            result = judge();
        }
    }
}