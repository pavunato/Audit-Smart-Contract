// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import './Token.sol';

contract dApp {
    
    TokenHeo private money;
    
    mapping (address => uint) public depositing;
    mapping (address => bool) public deposited;
    mapping (address => uint) public depositDate;
    mapping (address => uint) public interesting;
    
    //add all events below
    
    event depositEvent(address indexed depAcc, uint depAmount, uint blocktime);
    event withdrawEvent(address indexed witAcc, uint depAmount, uint tokenOut);
    
    constructor(TokenHeo _money) payable {
        money = _money;
    }
    
    function unclaimedInterest(address account) public view  returns (uint unclaimedInteresting) {
        unclaimedInteresting = ( block.timestamp - depositDate[account] ) * depositing[account] / 100;
    }
    
    function deposit() payable public {
        if (deposited[msg.sender]) {
            interesting[msg.sender] += unclaimedInterest(msg.sender);
        }
        depositing[msg.sender] += msg.value;
        depositDate[msg.sender] = block.timestamp;
        deposited[msg.sender] = true;
        emit depositEvent(msg.sender, depositing[msg.sender], depositDate[msg.sender]);
    }
    
    function withdraw() public {
        //check is that deposited or not!!!
        require(deposited[msg.sender], "Sorry, you didn't deposit any amount!");
        
        //calculate interest
        uint payout = interesting[msg.sender] + unclaimedInterest(msg.sender);
        
        //cashout for users
        money.mint(msg.sender, payout);
        payable(msg.sender).transfer(depositing[msg.sender]);
        
        //send event
        emit withdrawEvent(msg.sender, depositing[msg.sender], payout);
        
        //reset user's counter
        depositing[msg.sender] = 0;
        deposited[msg.sender] = false;
        depositDate[msg.sender] = 0;
    }
}

