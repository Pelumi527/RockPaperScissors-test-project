pragma solidity ^0.8.1;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract RockPaperScissors{

IERC20 Ierc20;
uint amountTostake;

enum Move{
    Null,
    Rock,
    Paper,
    Scissors
}

mapping(address => Move) move;
mapping(address => bool) haveStaked;
address payable alice;
address payable bob;

event GameWinner(address winner, uint amountWon);
constructor(address _tokenAddress, uint _amountTostake, address payable _alice, address payable _bob){
    Ierc20 = IERC20(_tokenAddress);
    amountTostake = _amountTostake;
    alice = _alice;
    bob = _bob;
}

function stake(uint _amt) public {
    require(amountTostake == _amt, "_amt deposited not up to the amount be staked");
    Ierc20.transferFrom(msg.sender, address(this), _amt);
    haveStaked[msg.sender] = true;
}


function player1Move(uint _move) public {
    require(haveStaked[alice] == true,"You need to stake first");
    require(msg.sender == alice, "player1 move");
    require(move[alice] == Move(0),"already played");
    require(_move > 0, "invalid choice");
    move[alice] = Move(_move);
}

function player2Move(uint _move) public {
    require(msg.sender == bob," Player 2");
    require(haveStaked[bob] == true,"you need to stake first");
    require(move[bob] == Move(0), "already played");
    require(_move > 0, "invalid choice");
    move[bob] = Move(_move);
}


function checkWinner() public{
    address winner;
    winner = _getwinner();
    uint reward = Ierc20.balanceOf(address(this));
    Ierc20.transfer(winner, reward);

    emit GameWinner(winner, reward);
}

function _getwinner() internal returns(address){
    address winner;
    if(move[bob] == move[alice]){
        move[bob] = Move(0);
        move[alice] = Move(0);
        //console.log(Draw. play again);
        }else if(move[bob] == Move(1)){
            if(move[alice] == Move(2)){
                winner = alice;
            }else{
              winner = bob;
            }
        } else if( move[bob] == Move(2)){
            if(move[alice] == Move(3)){
                 winner = alice;
            }else{
            winner = bob;
            }
        } else if(move[bob] == Move(3)){
            if(move[alice] == Move(1)){
                 winner = alice;
            }else{
                winner = bob;
            }
        }
    return winner;
    
    }
}