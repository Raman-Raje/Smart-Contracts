// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 
 
contract MultiSigWallet{

    // define the events
    event Deposit(address indexed sender,uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner,uint indexed txId);
    event Revoke(address indexed owner,uint indexed txId);
    event Execute(uint indexed txId);

    // state variables
    address[] public owners;
    mapping (address=>bool) public isowner;
    uint public required;

    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    Transaction[] public transactions;
    mapping (uint=>mapping(address=>bool)) public approved;

    // Modifiers
    modifier onlyOwner(){
        require(isowner[msg.sender],"Not authorized for transaction...");
        _;
    }

    modifier txExist(uint _txId) {
        require(_txId < transactions.length,"Invalied Transaction ID");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender],"Transaction already Approved...");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed,"Transaction already Executed...");
        _;
    }

    constructor(address[] memory _owners,uint _required){
        
        require(_owners.length>0,"Owners Required...");
        require(0 <_required && _required<= _owners.length,"Invalid Number of Authenticators...");

        for(uint i;i<_owners.length;i++){
            
            address owner = _owners[i];
            require(!isowner[owner],"Owner is not Unique..");
            require(owner != address(0),"Invalid Owner");

            isowner[owner] = true;
            owners.push(owner);

        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender,msg.value);
    }

    function submit(address _to,uint _value,bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to:_to,
            value:_value,
            data:_data,
            executed:false
        }));

        emit Submit(transactions.length -1);
    }

    function approve(uint _txId) external onlyOwner txExist(_txId) notApproved(_txId) notExecuted(_txId){
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender,_txId);

    }

    function _getApprovalCount(uint _txId) private view returns(uint){
        uint count;
        for (uint i;i < owners.length;i++){
            if (approved[_txId][owners[i]]){
                count += 1;
            }
        }
        return count;
    }

    function execute(uint _txId) external onlyOwner txExist(_txId) notExecuted(_txId){
        
        require(_getApprovalCount(_txId) <= required,"approvals < required " );
        Transaction storage transaction = transactions[_txId];

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);

        require(success,"transaction failed...");

        emit Execute(_txId);
    }

    function revoke(uint _txId) external onlyOwner txExist(_txId){
        require(approved[_txId][msg.sender],"Transaction not Approved");
        approved[_txId][msg.sender] = false;

        emit Revoke(msg.sender, _txId);

    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }


}