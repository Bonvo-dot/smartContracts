// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IBonvo.sol';
import './Utils.sol';

abstract contract Asset is IBonvo {
    mapping (string => mapping (uint => Asset)) public assetsByCountry;
    mapping (string=>uint) public counterAssetsByCountry;
    mapping (uint => Asset) public assetsByTokenId;

    function saveInMapping(Asset memory _asset) internal{
        uint size = counterAssetsByCountry[_asset.ISOCountry];
        assetsByCountry[_asset.ISOCountry][size+1] = _asset;
        counterAssetsByCountry[_asset.ISOCountry] = size+1;
    }

    function assetsNearMeNotCategory(int latitude, int longitude, string calldata ISOCountry) public view returns(Asset[] memory){
        return assetsNearMeCategory(latitude, longitude, ISOCountry, 0);
    }

    function assetsNearMeCategory(int latitude, int longitude, string calldata ISOCountry, uint categoyId) public view returns(Asset[] memory){
        Asset[] memory countryAssets = filterByCategory(ISOCountry, categoyId);
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

    function filterByCategory(string calldata ISOCountry, uint categoryId) view internal returns(Asset[] memory){
        uint size = counterAssetsByCountry[ISOCountry];
        Asset[] memory tempAssets = new Asset[](size); 
        uint c = 0;
        for(uint i = 0; i < size; i++){
            if(categoryId == 0){
                tempAssets[i] = assetsByCountry[ISOCountry][i];
            }else{
                if(assetsByCountry[ISOCountry][i].idCategory == categoryId){
                    tempAssets[c] = assetsByCountry[ISOCountry][i];
                    c++;
                }
            }

        }
        return tempAssets;
    }
}
