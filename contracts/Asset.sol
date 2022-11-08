// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IBonvo.sol';
import './Utils.sol';

abstract contract Asset is IBonvo {
    mapping (string => Asset[]) public assetsByCountry;
    mapping (uint => Asset) public assetsByTokenId;

    function saveInMapping(Asset memory _asset) internal{
        uint size = assetsByCountry[_asset.ISOCountry].length;
        Asset[] memory tempAssets = new Asset[](size+1);
        tempAssets[size] = _asset;
        assetsByCountry[_asset.ISOCountry] = tempAssets;
    }

    function assetsNearMeNotCategory(int latitude, int longitude, string calldata ISOCountry) public view returns(Asset[] memory){
        return assetsNearMeCategory(latitude, longitude, ISOCountry, 0);
    }

    function assetsNearMeCategory(int latitude, int longitude, string calldata ISOCountry, uint categoyId) public view returns(Asset[] memory){
        Asset[] memory countryAssets = filterByCategory(assetsByCountry[ISOCountry], categoyId);
        bool sorted = false;
        while(!sorted) {
            sorted = true;
            for(uint i = 0; i < countryAssets.length ; i++){
                Asset memory a0 = countryAssets[i-1];
                uint d0 = Utils.diagDist(latitude, a0.latitude, longitude, a0.longitude);
                Asset memory a1 = countryAssets[i];
                uint d1 = Utils.diagDist(latitude, a1.latitude, longitude, a1.longitude);

                if(d1 < d0 ){
                    countryAssets[i] = a0;
                    countryAssets[i-1] = a1;
                    sorted = false;   
                }
            }
        }

        return countryAssets;
    }

    function filterByCategory(Asset[] memory iAssets, uint categoryId) pure internal returns(Asset[] memory){
        if(categoryId == 0){
            return iAssets;
        }
        uint size = iAssets.length;
        Asset[] memory tempAssets = new Asset[](size); 
        uint c = 0;
        for(uint i = 0; i < size; i++){
            if(iAssets[i].idCategory == categoryId){
                tempAssets[c] = iAssets[i];
                c++;
            }
        }
        return tempAssets;
    }
}
