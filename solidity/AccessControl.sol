// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0; 

contract AccessControl{

    //roles => address => bool
    mapping(bytes32=>mapping(address=>bool)) public roles;
    
    // roles in bytes to represent compact  and save some gas
    bytes32 private constant ADMIN=keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER=keccak256(abi.encodePacked("USER"));

    event GrantRole(bytes32 indexed role,address indexed account);
    event RevoketRole(bytes32 indexed role,address indexed account);

    modifier onlyRole(bytes32 _role){
         require(roles[_role][msg.sender],"not Authorized");
         _;
    }

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    function _grantRole(bytes32 _role,address _account) internal{
        roles[_role][_account]=true;
        emit GrantRole(_role, _account);
    }

    function grantRole(bytes32 _role,address _account) external onlyRole(ADMIN) {
        _grantRole(_role,_account);
    }

    function revokeRole(bytes32 _role,address _account) external onlyRole(ADMIN){
        roles[_role][_account]=false;
        emit RevoketRole(_role, _account);

    }
}