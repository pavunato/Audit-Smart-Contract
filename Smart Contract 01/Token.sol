// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract TokenHeo is ERC20 {
    
    mapping (address => bool) public presidential;
    
    event PresidentialDelegated(address indexed thisPresident, address newPresident);
    
    constructor() payable ERC20("Help Every One", "HEO"){
        //assigning president into msg.sender
        presidential[msg.sender] = true;
    }
    
    function presidentialDelegate(address newPresident) public returns (bool){
        //check msg.sender is the currently president
        require(presidential[msg.sender], "Sorry! You don't have presidential to delegate!");
        presidential[newPresident] = true;
        
        emit PresidentialDelegated(msg.sender, newPresident);
        return true;
    }
    
    function mint(address account, uint256 amount) public {
        //check the msg.sender
        require(presidential[msg.sender], "Sorry! You don't have presidential to mint!");
        _mint(account, amount);
        //test minting and show on metamask "0x508EF863a13999ED28226E269aD3f7001bC2E48a", 200000000000000000000
    }
}
