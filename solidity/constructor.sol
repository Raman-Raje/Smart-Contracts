// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 

contract Cntr{

    uint public pin;
    string public city;

    constructor(uint new_pin,string memory newcity){
        pin = new_pin;
        city=newcity;

    }

}