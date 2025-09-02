// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // The import for our default functions
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol"; // The import for our maximum supply
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol"; // The import for the burnable function


contract HabeshaToken is ERC20Capped, ERC20Burnable{

    // initial supply for the owner = 70,000,00 is done 
    // max supply in totoal for both owner and reward will be the CAP = 100,000,000
    //We are going to make the token burnable
    // burning token is used after the deploy may be we decide to reduce the total supply so we will burn it
    // create a new block to destribute a reward for the miners


    address payable public owner;
    uint public blockReward;


    constructor(uint cap , uint reward) ERC20 ("HabeshaToken", "HTC") ERC20Capped(cap * (10 ** decimals()) ) { // passing our maximum supply and naming out Token
        owner = payable( msg.sender);
        _mint(owner, 70000000 * (10 ** decimals())); // Sending the 70% of the Token to the owner of the Token

        blockReward = reward * (10 ** decimals()); // Setting the reward amount
    }

    function _mintMinorReward() internal { // Mint the reward for the miner in the block (validator)
        _mint(block.coinbase, blockReward);
    }


    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Capped) {
        super._update(from, to, value);
    }



    modifier onlyOwner{ // middlware to validate the owner only
        require(msg.sender == owner, "Sorry you must be an owner to access this one");
        _;
    }

    function setBlockReward(uint reward) public onlyOwner{ // This function is wanted if the owner wants to change the block reward after deployment
        blockReward = reward * (10 ** decimals()); 
    }
}