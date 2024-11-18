// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract MarketPlace {
    
    address public owner;
    address public buyer;

    enum Status {
        None,
        Created,
        Pending,
        Soldout
    }

    struct Asset {
        string name;
        uint256 price;
        Status status;
    }

    Asset[] public assets;
    mapping(uint256 => bool) public isNoMoreAvailable;
    mapping(address => Asset[]) public userTxRecords;

    event AssetListed(string indexed name, uint256 price);
    event AssetISNoMoreAvailable(string indexed name, uint256 price, address buyer);

    constructor() {
        owner = msg.sender;
    }

    function listOrder(address _caller, string memory _name, uint256 _price) external {
        require(msg.sender != address(0), "Zero address is not allowed");

        Asset memory newAsset;
        newAsset.name = _name;
        newAsset.price = _price;
        newAsset.status = Status.Created;

        userTxRecords[_caller].push(newAsset);
        assets.push(newAsset);
        emit AssetListed(_name, _price);

  }

    function buyOrder(uint8 _index, address _caller) external {
        require(_caller != address(0), "Zero address is not allowed");
        require(_index < assets.length, "Out of bound!");
        require(!isNoMoreAvailable[_index], "Asset already sold");

        
        assets[_index].status = Status.Soldout;
        userTxRecords[_caller].push( assets[_index]);
        isNoMoreAvailable[_index] = true;
        buyer = _caller;

        emit AssetISNoMoreAvailable(assets[_index].name, assets[_index].price, _caller);
    }


    function getAllListedAssets(address _caller) external  view returns(Asset[] memory) {
        onlyOwner(_caller);
        return assets;
    }

    function getUserTransactionRecords(address _caller) external  view returns(Asset[] memory) {
        require(msg.sender != address(0));
        return userTxRecords[_caller];
    }

    function onlyOwner (address _caller) private view {
        require(_caller == owner, "Only for the owner");
    }
}