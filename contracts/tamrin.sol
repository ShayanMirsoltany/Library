// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./libFunc.sol";
contract tamrin{
    uint maxUserID = 0;
    mapping (address => uint) _usersPrices;
    mapping (address => bool) _checkUsers;
    address[] _users;
    address owner;
    bool status = true;
    constructor(){
        owner = msg.sender;
    }

    using libFunc for uint;
    function addUserPrice(uint price) public returns(string memory)
    {
        require(price >0,"price is zero");
        _usersPrices[msg.sender] = price;
        if (!_checkUsers[msg.sender])
        {
            _checkUsers[msg.sender] = true;
            _users.push(msg.sender);
        }
        return price.intToString();
    }

    function removePrice(address addr) public returns(string memory)
    {
        delete _usersPrices[addr];
        _checkUsers[msg.sender] = false;
        for (uint index = 0; index < _users.length; index++) 
        {
            if (_users[index] == addr)    
            {
                _users[index] = _users[_users.length-1];
                _users.pop();
                break ;
            }        
        }
        return "OK";
    }

    function getCurrentDate() public view returns(string memory)
    {
        return libFunc.dateToString(block.timestamp);
    }
    function getUsers()public view returns(address[] memory)
    {
        return _users;
    }

    function getName() view private  checkOwner checkContractStatus(status) returns(string memory)
    {
        return "OK";
    }

    modifier checkOwner(){
        require (msg.sender == owner, "You are not the Owner");
        _;
    }

    function expire() private checkOwner
    {
        status = false;
    }

    modifier checkContractStatus(bool currentStatus){
        require (currentStatus, "currentStatus is expired");
        _;
    }
}

