
//smart contract for the marketplace.
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

        owner = payable(msg.sender); //owner of smart contract to recieve commissions/royalties.
    }

    struct MarketItem{  //it looks like an array but we can't access it until we create a mapping.

        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
    // a way to access marketItem values 
    mapping(uint256 => MarketItem) private idMarketItem; //whenever we call idMarketItem;, it should go to to MarketItem and search index.
    
     //log message (when Item is sold)
    //event is a way to log messages is like console.log , a way to communicate with the client application that something has happened on the blockchain.
    event MarketItemCreated(

        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address payable seller,
        address payable owner,
        uint256 price,
        bool sold
        
    );
    ///@notice function to get listing price 
    function getListingPrice() public view returns (uint256){

        return listingPrice;
    }


    ///@notice function to create market item 
    function createMarketItem(address nftContract, uint256 tokenId, uint256 price )public payable nonReentrant{
     require (price>0,"price must be above zero");
     require(msg.value == listingPrice, "Price must be equal to listing price"); //if msg.value != listingPrice then return error "price must ..."
     
     _itemIds.increment();
     uint256 itemId = _itemIds.current();

     idMarketItem[itemId] = MarketItem(
         itemId,
         nftContract,
         tokenId,
         payable(msg.sender),
         payable(adddress(0)),
         price,
         false
     );


     //transfer ownership of the nft to the contract itself 

     IERC721(nftContract).TransferFrom(msg.sender,address (this), tokenId);

     //log this transaction.
     emit MarketItemCreated(
         itemId, 
         nftContract, 
         tokenId, 
         msg.sender, 
         address(0), 
         price,
         false

         );

    }


    //notice function to create a sale 

    function createMarketSale(address nftContract,uint256 itemId)public payable nonReentrant{

        uint price = idMarketItem[itemid].price;
        uint tokenId = idMarketItem[itemId].tokenId;

        require(msg.value==price,"Please submit the asking price in order to complete purchase");
    }
}