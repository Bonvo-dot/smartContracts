// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IBonvo {
    struct Asset {
        address assetId;
        string title;
        string description;
        int latitude;
        int longitude;
        uint8 assetCategory;
    }

    struct AssetCategory {
        uint idCategory;
        string name;
    }

    struct User {
        address idUser;
        string firstName;
        string lastName;
        string isoCountry;
        int reputation;
    }
    struct Rent {
        uint idRent;
        address assetId;
        address renter;
    }

    struct Rate {
        uint idRate;
        uint8 rate;
        string argue;
        address rater;
        address asset;
    }

}