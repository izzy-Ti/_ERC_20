// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HabeshaToken is ERC20{
    constructor( uint initialSupply) ERC20 ("HabeshaToken", "HTC"){
        _mint(msg.sender, initialSupply);
    }
}