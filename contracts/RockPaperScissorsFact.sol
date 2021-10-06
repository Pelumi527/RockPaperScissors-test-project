//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./RockPaperScissors.sol";
import "hardhat/console.sol";

contract RockPaperScissorFact {
    
    event GameStarted(address game, uint skaking);
    
    function startGame(
        address _tokenAddress,
        uint256 amountToStake,
        address payable playerone, 
        address payable playertwo) public payable returns(address) {
        RockPaperScissors rockPaperScissor = new RockPaperScissors(_tokenAddress, amountToStake, playerone ,playertwo);
        
        emit GameStarted(address(rockPaperScissor), amountToStake);
        return address(rockPaperScissor);
    }

}