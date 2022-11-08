// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import './Asset.sol';
import './IBonvo.sol';

abstract contract Rates is IBonvo{
    mapping(uint => Rate[]) public assetRates;
    mapping(address => Rate[]) public userRates;
    Rate[] public ratesArray;

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