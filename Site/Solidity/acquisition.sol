// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateAcquisition {
    address public owner;
    string public propertyName;
    string public propertyLocation;
    uint256 public acquisitionPrice;
    bool public isForSale;
    bool public isAcquired;
    address public buyer;
    uint256 public purchasePrice;

    event PropertyListed(address indexed owner, string propertyName, string propertyLocation, uint256 acquisitionPrice);
    event PropertyAcquired(address indexed newOwner, string propertyName, string propertyLocation, uint256 purchasePrice);

    constructor(string memory _name, string memory _location, uint256 _price) {
        owner = msg.sender;
        propertyName = _name;
        propertyLocation = _location;
        acquisitionPrice = _price;
        isForSale = false;
        isAcquired = false;
        buyer = address(0);
        purchasePrice = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier propertyNotAcquired() {
        require(!isAcquired, "Property has already been acquired");
        _;
    }

    modifier propertyNotListed() {
        require(!isForSale, "Property is already listed for sale");
        _;
    }

    function listPropertyForSale(uint256 _price) public onlyOwner propertyNotAcquired propertyNotListed {
        isForSale = true;
        acquisitionPrice = _price;
        emit PropertyListed(owner, propertyName, propertyLocation, acquisitionPrice);
    }

    function removePropertyFromMarket() public onlyOwner propertyNotAcquired {
        isForSale = false;
    }

    function acquireProperty() public payable propertyNotAcquired {
        require(isForSale, "Property is not listed for sale");
        require(msg.value >= acquisitionPrice, "Insufficient funds to acquire the property");
        
        buyer = msg.sender;
        purchasePrice = msg.value;
        isAcquired = true;
        
        emit PropertyAcquired(buyer, propertyName, propertyLocation, purchasePrice);
    }

    function getPropertyDetails() public view returns (string memory, string memory, uint256, bool, bool, address, uint256) {
        return (propertyName, propertyLocation, acquisitionPrice, isForSale, isAcquired, buyer, purchasePrice);
    }
}

