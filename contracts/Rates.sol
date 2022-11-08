// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import './Asset.sol';
import './IBonvo.sol';

abstract contract Rates is IBonvo, Asset{
    mapping(uint => Rate[]) public assetRates;
    mapping(address => Rate[]) public userRates;
    Rate[] public ratesArray;

    function addRate(uint8 _rate, string calldata _argue, uint _assetId) public {
        require(_assetId != 0 && _rate != 0, "Not valid values");
        require(assetsByTokenId[_assetId].latitude != 0, "Inexistent asset");

        uint id = ratesArray.length;
        Rate memory rate = Rate({
            idRate: id,
            rate: _rate,
            argue: _argue,
            rater: msg.sender,
            assetId: _assetId
        });
        ratesArray.push(rate);

        saveAssetRate(rate, _assetId);
        saveUserRate(rate);
        transferFrom(owner, msg.sender, RATE_REWARD);
    }

    function saveAssetRate(Rate memory rate, uint _assetId) internal {
        Rate[] memory tempRates = assetRates[_assetId];
        uint tempSize = tempRates.length;
        Rate[] memory ratesForAsset = new Rate[](tempSize+1);
        ratesForAsset[tempSize] = rate;
        assetRates[_assetId] = ratesForAsset;
    }
    
    function saveUserRate(Rate memory rate) internal {
        Rate[] memory tempRates = userRates[msg.sender];
        uint tempSize = tempRates.length;
        Rate[] memory ratesForUser = new Rate[](tempSize+1);
        ratesForUser[tempSize] = rate;
        userRates[msg.sender] = ratesForUser;    
    }
}