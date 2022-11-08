// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import './IBonvo.sol';
import './Categories.sol';
import './Token.sol';
import './Rewards.sol';
import './NftAsset.sol';
import './Asset.sol';
import './Rates.sol';

contract Bonvo is IBonvo, Categories, TokenBonvo, Rewards, Asset, Rates {
    mapping (address => User) public users;
    Rent[] public rents;

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
        rents.push(rent);
        transferFrom(owner, msg.sender, RENT_REWARD);
    }

}