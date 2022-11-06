// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IBonvo.sol';
import './Categories.sol';
import './Token.sol';
import './Rewards.sol';
import './NftAsset.sol';

abstract contract Asset is IBonvo, Categories, TokenBonvo, Rewards {
    mapping (uint => Asset) public assets;
    mapping (uint => Asset) private orderedAssets;
    NftAsset nft = new NftAsset();
    using Strings for uint256;
    address public owner;

    function createAsset(Asset memory _asset) external {
        string memory uris = "";
        for(uint i = 0; i < _asset.images.length; i++){
            uris = string(abi.encodePacked(uris, _asset.images[i]));
        }
        uint tokenId = nft.mint(msg.sender, uris);
        assets[tokenId] = _asset;
        transferFrom(owner, msg.sender, CREATE_ASSET_REWARD);
    }

    function assetsNearMe(int latitude, int longitude) public view returns(Asset[] memory){
        uint lastId = nft.getLastTokenId();
        Asset[] memory ordered = new Asset[](lastId);
        int distance = 0;

        for(uint i = 0; i < lastId; i++){
            Asset memory tempAsset = assets[i]; 
            distance = (tempAsset.latitude - latitude) +  (tempAsset.longitude - longitude);
            ordered[i] = tempAsset;
        }
        return ordered;
    }
}