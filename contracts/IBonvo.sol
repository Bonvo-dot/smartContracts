// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IBonvo {
    struct StaticDataAsset {
        string title;
        string description;
        string location;
        uint rooms;
        uint size;
    }
    struct Asset {
        uint tokenId;
        uint timestamp;
        address owner;
        uint price;
        string[] images;
        string latitude;
        string longitude;
        uint8 idCategory;
        string ISOCountry;
        StaticDataAsset staticData;
    }

    struct AssetCategory {
        uint idCategory;
        string name;
        string description;
    }

    struct User {
        address idUser;
        string firstName;
        string lastName;  
        string isoCountry;
        int reputation;
        string image;
    }
    
    struct Rent {
        uint idRent;
        uint assetId;
        address renter;
    }

    struct Rate {
        uint idRate;
        uint8 rate;
        string argue;
        address rater;
        uint assetId;
    }

}