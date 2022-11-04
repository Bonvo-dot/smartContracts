// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import './IBonvo.sol';
import './Categories.sol';
import './Token.sol';
import './Rewards.sol';

contract Bonvo is IBonvo, Categories, TokenBonvo, Rewards {
    mapping (address => Asset) public assets;
    mapping (address => User) public users;
    Rate[] public rates;
    Rent[] public rents;
    address public owner;

    constructor() TokenBonvo(msg.sender){
        owner = msg.sender;
    }
    
    function createAsset(address _assetId, Asset memory _asset) external {
        require(_assetId != address(0), "Valid asset address required");
        assets[_assetId] = _asset;
        transferFrom(owner, msg.sender, CREATE_ASSET_REWARD);
    }

    function createUser(address idUser, User memory _user) external {
        require(idUser != address(0), "Valid wallet address required");
        users[idUser] = _user;
    } 

    function addRate(uint8 _rate, string calldata _argue, address _assetId) public {
        require(_assetId != address(0) && _rate != 0, "Not valid values");
        require(assets[_assetId].assetId != address(0), "Inexistent asset address");

        uint id = rates.length;
        Rate memory rate = Rate({
            idRate: id,
            rate: _rate,
            argue: _argue,
            rater: msg.sender,
            asset: _assetId
        });
        rates.push(rate);

        transferFrom(owner, msg.sender, RATE_REWARD);
    }

    function addRent(address _assetId) public {
        require(_assetId != address(0), "Null address");
        require(assets[_assetId].assetId != address(0), "Inexistent asset address");
        uint id = rents.length;
        Rent memory rent = Rent({
            idRent: id,
            assetId: _assetId,
            renter: msg.sender
        });
        rents.push(rent);
        transferFrom(owner, msg.sender, RENT_REWARD);
    }

}