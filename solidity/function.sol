// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 

contract Func{
    uint public pin = 413512;
    uint age;

    // public variable has default getter methods
    // function getpin() public view returns(uint){
    //     return pin;
    // }

    function setage(uint newage) public{
        age = newage;
    }

    function getage() public view returns(uint){
        return age;
    }

}