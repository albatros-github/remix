// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

// ----------- START Owned.sol file for import (add pragma ...) ------------
//import "./Owned.sol";

contract Owned {    
    address public owner;
    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "you are not the smarth contract owner");
        //paste upper line with content of modified function and then replace all copied code inside function again
        _;
    }

}
// -----------  END Owned.sol file for import ------------

contract AllTest is Owned {
    string public myString = "hi!";
    bool public paused;
    uint public myUint;
    uint public balanceReceive;
    uint public balanceReceive2;
    uint public lockedUntil;
    //inherited from Owned contract
    //address public owner;
    address public tmpaddr;
    mapping(uint => bool) public mappedUint;
    mapping(address => bool) public mappedAddress;
    mapping(address => uint8) tokens;
    mapping(address => Balance) public mappedAddressBalance;
    mapping(uint  => mapping(uint => bool)) uintUintBoolMapping;

    struct Payment {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payment;
    }

    constructor() {
        //inherited from Owned contract
        //owner = payable(msg.sender);
        tokens[owner] = 100;
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

    function setPause(bool _pause) public onlyOwner{
        //inherited from Owned contract
        //require(owner == msg.sender, "you are not the smarth contract owner");
        paused = _pause;
    }

    function receiveMoneyNotTracked() public payable {
        balanceReceive += msg.value;
        lockedUntil = block.timestamp + 30 seconds;
    }

    function receiveMoneyTracked() public payable {
        assert(mappedAddressBalance[msg.sender].totalBalance + msg.value >= mappedAddressBalance[msg.sender].totalBalance);
        mappedAddressBalance[msg.sender].totalBalance += msg.value;
        Payment memory payment = Payment(msg.value,block.timestamp);
        mappedAddressBalance[msg.sender].payment[mappedAddressBalance[msg.sender].numPayments] = payment;
        mappedAddressBalance[msg.sender].numPayments++;
        lockedUntil = block.timestamp + 30 seconds;
    }

    function withdrawMoneyOwnerOnly(uint _amount, address payable _to) public {
        require(_amount <= mappedAddressBalance[msg.sender].totalBalance,"Not enought liquidity");
        //inherited from Owned contract
        //require(owner == msg.sender, "you are not the smarth contract owner");
        require(paused == false, "smarth contract paused");
        //assert doesn't return transfer fumnds, but require does
        assert(mappedAddressBalance[msg.sender].totalBalance >= mappedAddressBalance[msg.sender].totalBalance - _amount);
        if(lockedUntil < block.timestamp){ 
            mappedAddressBalance[msg.sender].totalBalance -= _amount;
            _to.transfer(_amount);
        }
    }

    function selfDestruct(address payable _address) public {
        //inherited from Owned contract
        //require(owner == msg.sender, "you are not the smarth contract owner");

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

    function setUintUintBoolMapping(uint _index1, uint _index2, bool _value) public {
        uintUintBoolMapping[_index1][_index2] = _value;
    }

    function getUintUintBoolMapping(uint _index1, uint _index2) view public returns (bool) {
        return uintUintBoolMapping[_index1][_index2];
    }

    fallback() external payable {
        getBalanceSmarthContract();        
    }

    receive() external payable {
        receiveMoneyTracked();        
    }

    //pure funcions can not access STATE VARIABLES (kind of "class" variables)
    function convertWeiToEther(uint _weiAmount) public pure returns(uint ) {
        return _weiAmount / 1 ether;
    }
}


// ERROR HANDLING
contract ThrowError {
    function errFunction() public pure {
        require(false, "parse error");
    }
}

contract ErrorHandling {
    event ErrorLogging(string reason);
    function catchError() public {
        ThrowError err = new ThrowError();
        try err.errFunction() {
            //code if it works
        }catch Error(string memory reason){
            emit ErrorLogging(reason);
        }
    }
}
