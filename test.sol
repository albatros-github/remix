// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

contract AllTest {
    string public myString = "hi!";
    bool public paused;
    uint public myUint;
    uint public balanceReceive;
    uint public balanceReceive2;
    uint public lockedUntil;
    address public owner;
    address public tmpaddr;
    mapping(uint => bool) public mappedUint;
    mapping(address => bool) public mappedAddress;

    constructor() {
        owner = msg.sender;
    }

    function setUint(uint _myUint) public {
        myUint = _myUint;
    }

    function decrementUint() public {
        //unchecked{                  
            myUint--;
        //}
    }

    function getBalanceSmarthContract() public view returns(uint) {
        return address(this).balance;
    }

    function getBalanceOf(address _address) public view returns(uint) {
        return _address.balance;
    } 

    function setMySring(string memory _string) public {
        myString = _string;
    }

    function setPause(bool _pause) public {
        require(owner == msg.sender, "you are not the smarth contract owner");
        paused = _pause;
    }

    function receiveMoney() public payable {
        balanceReceive += msg.value;
        lockedUntil = block.timestamp + 30 seconds;
    }

    function receiveMoney2() public payable {
        balanceReceive2 += msg.value;
        //lockedUntil = block.timestamp + 30 seconds;
    }

    function withdrawMoney(uint _amount, address payable _to) public {
        require(_amount <= balanceReceive,"Not enought liquidity");
        require(owner == msg.sender, "you are not the smarth contract owner");
        require(paused == false, "smarth contract paused");
        if(lockedUntil < block.timestamp){
            balanceReceive -= _amount;
            _to.transfer(_amount);
        }
    }

    function selfDestruct(address payable _address) public {
        require(owner == msg.sender, "you are not the smarth contract owner");
        //WILL BE DEPRECATED: change the state so the S.C. addrs will not have any code and you could not interact with the logic but possible to send to it losing your money
        //before being destroyed the _address will receive all the S.C. fonds
        selfdestruct(_address);
    }

    function setValueToTrue(uint _index) public {
        mappedUint[_index] = true;
    }

    function setAddressToTrue() public {
        mappedAddress[msg.sender] = true;
    }
}
