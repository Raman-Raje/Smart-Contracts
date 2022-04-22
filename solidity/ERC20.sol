// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 <0.9.0; 

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


contract ERC20 is IERC20{

    uint public totalSupply;  // total supply of the tokens
    mapping(address=>uint) public balanceOf; 
    mapping(address=>mapping(address=>uint)) public allowance;

    constructor(uint _totalsupply){
       totalSupply = _totalsupply; 
    }

    function transfer(address _recipient,uint _amount) external returns(bool) {
        require(_recipient != address(0),"Invalid Recipient..");
        require(balanceOf[msg.sender] >= _amount,"Insufficients Funds.. :)");

        balanceOf[msg.sender] -= _amount;
        balanceOf[_recipient] += _amount;

        emit Transfer(msg.sender,_recipient,_amount);
        return true;
    }

    function transferFrom(address _sender,address _recipient,uint _amount) external returns(bool) {

        require(allowance[_sender][msg.sender] >= _amount,"Transfer Limit exeeceded.... :)");
        require(balanceOf[_sender] >= _amount,"Insufficients Funds.. :)");
        balanceOf[_sender] -= _amount;
        balanceOf[_recipient] += _amount;

        emit Transfer(_sender,_recipient,_amount);
        return true;
    }
    
    function approve(address _spender, uint _amount) external returns (bool){

        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender,_spender, _amount);
        return true;
    }

    function mint(uint _amount) external {
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;

        emit Transfer(address(0),msg.sender,_amount);
    }

    function burn(uint _amount) external {
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit Transfer(msg.sender,address(0),_amount);
    }
}
