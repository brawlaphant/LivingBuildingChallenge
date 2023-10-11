// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PropertyResearch.sol";
import "./RealEstateAcquisition.sol";

contract Define {
    PropertyResearch public propertyResearchContract;
    RealEstateAcquisition public realEstateContract;

    constructor(address _propertyResearchContract, address _realEstateContract) {
        propertyResearchContract = PropertyResearch(_propertyResearchContract);
        realEstateContract = RealEstateAcquisition(_realEstateContract);
    }

    // Define a property and research it for LBC alignment
    function defineProperty(string memory _name, string memory _location, uint256 _price, string memory _researchLocation, uint256 _landArea, uint256 _buildingArea) public {
        // Create a new real estate property
        realEstateContract = new RealEstateAcquisition(_name, _location, _price);

        // List the property for sale
        realEstateContract.listPropertyForSale(_price);

        // Research the property for LBC alignment
        propertyResearchContract.researchProperty(_researchLocation, _landArea, _buildingArea);
    }

    // Check if the defined property aligns with LBC standards
    function checkLBCAlignment(address _propertyOwner) public view returns (bool) {
        return propertyResearchContract.checkLBCAlignment(_propertyOwner);
    }
}

