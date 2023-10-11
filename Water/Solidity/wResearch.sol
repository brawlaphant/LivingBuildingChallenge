// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WaterResearch {
    struct WaterSource {
        string name;
        uint256 capacity; // in gallons
        uint256 quality; // on a scale of 1 to 10
        bool isCertified;
        address researcher;
    }

    mapping(address => WaterSource) public waterSources;

    event WaterResearched(address indexed researcher, string name, uint256 capacity, uint256 quality);
    event WaterCertified(address indexed certifier, address indexed waterSource, string name);

    modifier isValidQuality(uint256 _quality) {
        require(_quality >= 1 && _quality <= 10, "Quality must be between 1 and 10");
        _;
    }

    modifier sourceExists(address _source) {
        require(waterSources[_source].researcher != address(0), "Water source not found");
        _;
    }

    modifier sourceNotCertified(address _source) {
        require(!waterSources[_source].isCertified, "Water source is already certified");
        _;
    }

    function researchWaterSource(string memory _name, uint256 _capacity, uint256 _quality)
        external
        isValidQuality(_quality)
    {
        require(_capacity > 0, "Capacity must be greater than 0");

        WaterSource storage source = waterSources[msg.sender];
        require(source.researcher == address(0), "You have already researched a water source");

        source.name = _name;
        source.capacity = _capacity;
        source.quality = _quality;
        source.isCertified = false;
        source.researcher = msg.sender;

        emit WaterResearched(msg.sender, _name, _capacity, _quality);
    }

    function certifyWaterSource(address _source)
        external
        sourceExists(_source)
        sourceNotCertified(_source)
    {
        WaterSource storage source = waterSources[_source];
        require(msg.sender != source.researcher, "You cannot certify your own research");

        // Simplified certification check (replace with actual criteria)
        if (source.capacity >= 1000 && source.quality >= 7) {
            source.isCertified = true;
            emit WaterCertified(msg.sender, _source, source.name);
        }
    }
}
