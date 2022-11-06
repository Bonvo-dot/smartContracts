// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IBonvo {
    struct Asset {
        address assetId;
        string title;
        address owner;
        uint price;
        string description;
        string[] images;
        int latitude;
        int longitude;
        uint rooms;
        uint size;
        uint8 assetCategory;
        string location;
        uint idCategory;
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