//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721.sol";
//prevents reentrancy attacks.
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; 


contract NFTmarket is ReentrancyGuard {

    using Counters  for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _ItemsSold; //total number of items sold 
    address payable owner; //owner of the smart contract

    uint256 listingPrice = 0.025 ether; // people have to pay listing fee to buy an nft on this marketplace.


    constructor (){

        owner = payable(msg.sender);
    }

    struct MarketItem{

        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
}