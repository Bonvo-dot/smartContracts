// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/access/AccessControl.sol';
import './IBonvo.sol';

contract Categories is AccessControl, IBonvo {
    bytes32 public constant ADMIN_CATEGORIES = keccak256("ADMIN_CATEGORIES");
    AssetCategory[] public categories;

    constructor(){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_CATEGORIES, msg.sender);
    }

    function getCategories() public view returns (string memory){
        string memory cat = "{";
        for(uint i = 0;i < categories.length; i++){
            string memory element = string(abi.encodePacked("{id:", categories[i].idCategory, ", category:", categories[i].name, "}"));
            if(i != categories.length - 1){
                element = string(abi.encodePacked(element, ","));
            }
            cat = string(abi.encodePacked(cat, element));
        }
        return string(abi.encodePacked(cat, "}"));
    }

    function setAdminCategoriesRole(address newAdminCategories) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(ADMIN_CATEGORIES, newAdminCategories);
    }

    function removeAdminCategoriesRole(address adminCategories) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(hasRole(ADMIN_CATEGORIES, adminCategories), "Addres is not categories admin");
        revokeRole(ADMIN_CATEGORIES, adminCategories);
    }

    function addCategory(string calldata _name,string calldata _description ) public onlyRole(ADMIN_CATEGORIES) {
        require(bytes(_name).length > 0, "Not valid name");
        uint id = categories.length;
        AssetCategory memory assetCategory = AssetCategory({
            idCategory: id,
            name: _name,
            description: _description
        });
        categories.push(assetCategory);
    }

    function removeCategory(uint idCategory) public onlyRole(ADMIN_CATEGORIES) {
        require(categories[idCategory].idCategory > 0, "Inexistent category");
        delete(categories[idCategory]);
    }

    function patchCategory(uint idCategory, string memory _name) public onlyRole(ADMIN_CATEGORIES) {
        require(categories[idCategory].idCategory > 0, "Inexistent category");
        require(bytes(_name).length > 0, "Not valid name for cateogory");
        categories[idCategory].name = _name;
    }
}