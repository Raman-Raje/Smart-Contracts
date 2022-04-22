// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 
import "./simpleStorage.sol";

contract StorageFactory{
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public{
        SimpleStorage stf = new SimpleStorage();
        simpleStorageArray.push(stf);
    }

    function sfstore(uint _index,uint _favoriteNumber) public{
        require(_index < simpleStorageArray.length,"Invalid Index");

        SimpleStorage st_obj = simpleStorageArray[_index];
        st_obj.store(_favoriteNumber);
    }

    function sfGet(uint _index) public view returns(uint){
        
        require(_index < simpleStorageArray.length,"Invalid Index");
        SimpleStorage st_obj = simpleStorageArray[_index];
        return st_obj.retrieve();
    } 
}