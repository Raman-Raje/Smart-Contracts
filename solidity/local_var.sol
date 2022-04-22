// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 

contract Demo{

    string name = "sol";

    function local() pure public returns(uint){
        string memory lang = "Raman";
        uint age = 10;  // local variable
        return age;
    }
} 