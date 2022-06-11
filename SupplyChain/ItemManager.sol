//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./Item.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract ItemManager is Ownable {

    enum SupplyChainSteps{NoStock, Created, Paid, Delivered}

    struct S_Item{
        Item _item;
        //uint _priceInWei;
        ItemManager.SupplyChainSteps _step;
        string _identifier;
    }

    mapping(uint => S_Item) public items;
    uint index;

    event SupplyChainStep(uint _itemIndex, uint _step, address indexed _address);

    function createItem(string memory _identifier, uint _priceInWei) public onlyOwner {
        Item item = new Item(this, _priceInWei, index);
        items[index]._item = item;
        //items[index]._priceInWei = _priceInWei;
        items[index]._identifier = _identifier;
        items[index]._step = SupplyChainSteps.Created;
        emit SupplyChainStep(index,uint(items[index]._step), address(item)); //casted enum (values from 0, 1,..) to uint 
        index++;
    }

    function triggerPayment(uint _index) public payable {
        Item item = items[_index]._item;
        //PENDING TO CHECK INVOCATION
        //require(address(item) == msg.sender, "Only items are allowed to update themselves");
        require(item.priceInWei() == msg.value,"Not fully paid");
        require(items[_index]._step == SupplyChainSteps.Created, "item advanced in supplty chain");
        items[_index]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index,uint(items[_index]._step), address(item)); 
    }

    function triggerDelivery(uint _index) public onlyOwner {
        Item item = items[_index]._item;
        require(items[_index]._step == SupplyChainSteps.Paid, "item not paid");
        items[_index]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index, uint(items[_index]._step), address(item)); 
    }
}
