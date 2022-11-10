// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IBonvo.sol';
import './Utils.sol';

abstract contract Assets is IBonvo {
    mapping (string => mapping (uint => Asset)) public assetsByCountry;
    mapping (string=>uint) public counterAssetsByCountry;
    mapping (uint => Asset) public assetsByTokenId;

    function saveInMapping(Asset memory _asset, uint tokenId) internal{
        _asset.tokenId = tokenId;
        uint size = counterAssetsByCountry[_asset.ISOCountry];
        assetsByCountry[_asset.ISOCountry][size] = _asset;
        counterAssetsByCountry[_asset.ISOCountry] = size+1;
        assetsByTokenId[tokenId] = _asset;
    }

    function assetsNearMeNotCategory(int latitude, int longitude, string calldata ISOCountry) public view  returns(Asset[] memory){
        return assetsNearMeCategory(latitude, longitude, ISOCountry, 0);
    }

    function assetsNearMeCategory(int latitude, int longitude, string calldata ISOCountry, uint idCategory) public view  returns(Asset[] memory){
        Asset[] memory countryAssets = filterByCategory(ISOCountry, idCategory);
        uint size = countryAssets.length;
        for(uint i = 0; i < size ; i++){
            for(uint j = 0; j < size-i-1 ; j++){
                Asset memory a0 = countryAssets[j];
                uint d0 = Utils.diagDist(latitude, a0.latitude, longitude, a0.longitude);

                Asset memory a1 = countryAssets[j+1];
                uint d1 = Utils.diagDist(latitude, a1.latitude, longitude, a1.longitude);

                if(d1 < d0 ){
                    countryAssets[j] = a1;
                    countryAssets[j+1] = a0;
                }
            }
        }
        return countryAssets;
    }

    function filterByCategory(string calldata ISOCountry, uint idCategory) internal view returns(Asset[] memory){
        uint size = counterAssetsByCountry[ISOCountry];
        Asset[] memory tempAssets = new Asset[](size); 
        uint c = 0;
        for(uint i = 0; i < size; i++){
            if(idCategory == 0){
                tempAssets[i] = assetsByCountry[ISOCountry][i];
            }else if(assetsByCountry[ISOCountry][i].idCategory == idCategory){
                tempAssets[c] = assetsByCountry[ISOCountry][i];
                c++;
            }
        }

        if(idCategory == 0){
            return tempAssets;
        }else{
            Asset[] memory outAssets = new Asset[](c);
            for(uint i = 0; i < c; i++){
                outAssets[i] = tempAssets[i];
            }
            return outAssets;
        }

    }
}
