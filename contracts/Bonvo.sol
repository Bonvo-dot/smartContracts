// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import './IBonvo.sol';
import './Categories.sol';
import './Token.sol';
import './Rewards.sol';
import './NftAsset.sol';
import './Assets.sol';
import './Rates.sol';
import './Rents.sol';

contract Bonvo is IBonvo, Categories, TokenBonvo, Rewards, Assets, Rates, Rents {
    using Strings for uint256;
    address public owner;
    mapping (address => User) public users;
    NftAsset nft = new NftAsset();
    Rewards public r = new Rewards();

    constructor() TokenBonvo(msg.sender){
        owner = msg.sender;
    }

    function createUser(address idUser, User memory _user) external {
        require(idUser != address(0), "Valid wallet address required");
        users[idUser] = _user;
    } 

    function addRent(uint _assetId) public {
        require(_assetId != 0, "Null address");
        require(assetsByTokenId[_assetId].latitude != 0, "Inexistent asset address");
        uint id = rents.length;
        Rent memory rent = Rent({
            idRent: id,
            assetId: _assetId,
            renter: msg.sender
        });
        saveRent(rent);
        transferFrom(owner, msg.sender, RENT_REWARD);
    }

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
        saveUserRate(rate, msg.sender);
        transferFrom(owner, msg.sender, r.RATE_REWARD());
    }

    function createAsset(Asset memory _asset) external {
        string memory uris = "";
        for(uint i = 0; i < _asset.images.length; i++){
            uris = string(abi.encodePacked(uris, _asset.images[i]));
        }
        uint tokenId = nft.mint(msg.sender, uris);
        saveInMapping(_asset, tokenId);
        transferFrom(owner, msg.sender, r.CREATE_ASSET_REWARD());
    }

}