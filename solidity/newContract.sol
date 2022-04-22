// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 

contract Communication{
    string public message;

    function setMessage(string memory _msg) public{
        message = _msg;
    }
}

contract Communicate{
    Communication obj;

    constructor() {
        obj = new Communication();
    }

    function setMsg(string memory _msg) public{
        obj.setMessage(_msg);
    }
}