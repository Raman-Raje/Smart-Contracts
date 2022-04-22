// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 <0.9.0; 
 
contract MultiSigWallet{

    // state variables
    mapping (address=>bool) public isowner;

    constructor(address[] memory _owners){
        for(uint i;i<_owners.length;i++){
            
            address owner = _owners[i];
            require(!isowner[owner],"Owner is not Unique..");
            require(owner != address(0),"Invalid Owner");

        }
    }

}