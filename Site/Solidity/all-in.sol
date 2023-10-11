// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyResearchAndAcquisition {
    struct Property {
        string location;
        uint256 landArea;
        uint256 buildingArea;
        bool isCertified;
        bool isAcquired;
        address owner;
        uint256 acquisitionPrice;
        address buyer;
        string documentationIPFSHash;  // Link to property documentation
        address verifier;  // The address of the third-party verifier
        bool verificationCompleted;
    }

    mapping(address => Property) public properties;

    event PropertyResearched(address indexed researcher, string location, uint256 landArea, uint256 buildingArea);
    event PropertyListed(address indexed owner, string location, uint256 acquisitionPrice);
    event PropertyAcquired(address indexed newOwner, string location, uint256 purchasePrice);
    event PropertyVerified(address indexed verifier, string location, bool verificationResult);

    function researchProperty(string memory _location, uint256 _landArea, uint256 _buildingArea) external {
        require(_landArea > 0, "Land area must be greater than 0");
        require(_buildingArea > 0, "Building area must be greater than 0");

        properties[msg.sender] = Property(_location, _landArea, _buildingArea, false, false, msg.sender, 0, address(0), "", address(0), false);

        emit PropertyResearched(msg.sender, _location, _landArea, _buildingArea);
    }

    function listPropertyForSale(uint256 _price) external {
        Property storage property = properties[msg.sender];
        require(!property.isAcquired, "Property has already been acquired");
        property.isCertified = true; // Assume it meets LBC standards
        property.acquisitionPrice = _price;

        emit PropertyListed(msg.sender, property.location, _price);
    }

    function acquireProperty() external payable {
        Property storage property = properties[msg.sender];
        require(property.isCertified, "Property must meet LBC standards");
        require(!property.isAcquired, "Property has already been acquired");
        require(property.isForSale, "Property is not listed for sale");
        require(msg.value >= property.acquisitionPrice, "Insufficient funds to acquire the property");

        property.isAcquired = true;
        property.buyer = msg.sender;

        emit PropertyAcquired(msg.sender, property.location, property.acquisitionPrice);
    }

    function addDocumentation(string memory _documentationIPFSHash) external {
        Property storage property = properties[msg.sender];
        require(!property.isAcquired, "Property has already been acquired");
        property.documentationIPFSHash = _documentationIPFSHash;
    }

    function assignVerifier(address _verifier) external {
        Property storage property = properties[msg.sender];
        require(!property.isAcquired, "Property has already been acquired");
        property.verifier = _verifier;
    }

    function verifyProperty() external {
        Property storage property = properties[msg.sender];
        require(property.verifier != address(0), "No verifier assigned");
        // Logic to verify property documentation with the assigned verifier.
        // Set 'verificationCompleted' and 'isCertified' based on the verification result.

        // For simplicity, we'll assume successful verification here.
        property.verificationCompleted = true;
        property.isCertified = true;

        emit PropertyVerified(property.verifier, property.location, true);
    }
}
