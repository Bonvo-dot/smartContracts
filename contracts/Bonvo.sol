// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import './IBonvo.sol';
import './Categories.sol';
import './Token.sol';
import './Rewards.sol';
import './NftAsset.sol';
import './Asset.sol';

contract Bonvo is IBonvo, Categories, TokenBonvo, Rewards, Asset {
    mapping (address => User) public users;
    Rate[] public rates;
    Rent[] public rents;

    constructor() TokenBonvo(msg.sender){
        owner = msg.sender;
    }

    function createUser(address idUser, User memory _user) external {
        require(idUser != address(0), "Valid wallet address required");
        users[idUser] = _user;
    } 

    function addRate(uint8 _rate, string calldata _argue, uint _assetId, uint countryCode) public {
        require(_assetId != 0 && _rate != 0, "Not valid values");
        require(assets[countryCode][_assetId].assetId != 0, "Inexistent asset address");

        uint id = rates.length;
        Rate memory rate = Rate({
            idRate: id,
            rate: _rate,
            argue: _argue,
            rater: msg.sender,
            assetId: _assetId
        });
        rates.push(rate);

        transferFrom(owner, msg.sender, RATE_REWARD);
    }

    function addRent(uint _assetId, uint countryCode) public {
        require(_assetId != 0, "Null address");
        require(assets[countryCode][_assetId].assetId != 0, "Inexistent asset address");
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