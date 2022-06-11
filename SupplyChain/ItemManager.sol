//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract ItemManager{

    enum SupplyChainSteps{Created, Paid,Delivered}

    struct S_Item{
        uint _priceInWei;
        ItemManager.SupplyChainSteps _step;
        string _identifier;
    }

    mapping(uint => S_Item) public items;
    uint index;

    event SupplyChainStep(uint _itemIndex, uint _step);

    function createItem(string memory _identifier, uint _priceInWei) public {
        items[index]._priceInWei = _priceInWei;
        items[index]._identifier = _identifier;
        items[index]._step = SupplyChainSteps.Created;
        emit SupplyChainStep(index,uint(items[index]._step)); //casted enum (values from 0, 1,..) to uint 
        index++;
    }

    function triggerPyment(uint _index) public payable {
        require(items[index]._priceInWei <= msg.value,"Not fully paid");
        require(items[index]._step == SupplyChainSteps.Created, "item advanced in supplty chain");
        items[_index]._step == SupplyChainSteps.Paid;
        emit SupplyChainStep(_index,uint(items[_index]._step)); 
    }

    function triggerDelivery(uint _index) public {
        require(items[index]._step == SupplyChainSteps.Paid, "item not paid");
        items[_index]._step == SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index,uint(items[_index]._step)); 
    }
}
