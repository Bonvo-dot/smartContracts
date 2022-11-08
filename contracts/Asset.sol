// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IBonvo.sol';
import './Categories.sol';
import './Token.sol';
import './Rewards.sol';
import './NftAsset.sol';
import './Utils.sol';

abstract contract Asset is IBonvo, Categories, TokenBonvo, Rewards {
    mapping (string => Asset[]) public assets;
    mapping (uint => Asset) private orderedAssets;
    NftAsset nft = new NftAsset();
    using Strings for uint256;
    address public owner;

    function createAsset(Asset memory _asset) external {
        string memory uris = "";
        for(uint i = 0; i < _asset.images.length; i++){
            uris = string(abi.encodePacked(uris, _asset.images[i]));
        }
        nft.mint(msg.sender, uris);
        saveInMapping(_asset);
        transferFrom(owner, msg.sender, CREATE_ASSET_REWARD);
    }

    function saveInMapping(Asset memory _asset) internal{
        uint size = assets[_asset.ISOCountry].length;
        Asset[] memory tempAssets = new Asset[](size+1);
        tempAssets[size] = _asset;
        assets[_asset.ISOCountry] = tempAssets;
    }

    function assetsNearMeNotCategory(int latitude, int longitude, string calldata ISOCountry) public view returns(Asset[] memory){
        return assetsNearMeCategory(latitude, longitude, ISOCountry, 0);
    }

    function assetsNearMeCategory(int latitude, int longitude, string calldata ISOCountry, uint categoyId) public view returns(Asset[] memory){
        Asset[] memory countryAssets = filterByCategory(assets[ISOCountry], categoyId);
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
