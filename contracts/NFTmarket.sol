
//smart contract for the marketplace.
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721.sol";
//prevents reentrancy attacks.
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; 


contract NFTmarket is ReentrancyGuard {

    using Counters  for Counters.Counter;
    Counters.Counter private _itemIds;    //total number Items ever created
    Counters.Counter private _ItemsSold; //total  number of Items ever sold.
    address payable owner; //owner of the smart contract

    uint256 listingPrice = 0.025 ether; // people have to pay listing fee to buy an nft on this marketplace.


    constructor (){

        owner = payable(msg.sender); //owner of smart contract to recieve commissions/royalties.
    }

    struct MarketItem{  //it looks like an array but we can't access it until we create a mapping.

        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller; //NFt seller.
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
     
     _itemIds.increment(); //add 1 to the total number of items ever created.
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
        
        //pay the Nft seller the  amount 
        idMarketItem[itemId].seller.transfer(msg.value);
        
        //transfer ownership of the nft from the contract itself to the buyer.
        IERC721(nftContract).TransferFrom(address(this),msg.sender,tokenId);

        //making the new buyer as the new owner of the nft .
        idMarketItem[itemId].owner = payable(msg.sender); //mark buyer as new owner 
        idMarketItem[itemId].sold = true; 
        _ItemsSold.increment(); //increment the total number of itemsold by 1 
        payable(owner).transfer(listingPrice);// paying the marketplace commission.

    }


    ///@notice total number of items unsold on our platform 

    function fetchMarketItems() public view returns (MarketItem[] memory){

        uint itemCount = _itemIds.current(); //total number of items ever created.

        //total number of items that are unsold = total items ever created - total items ever  sold 
        uint unsoldItemCount = _itemsIds.current() - _itemsold.current();
       
       uint currentIndex = 0;

       MarketItem[] memory items = new MarketItem[](unsoldItemCount);

       //loop through all items ever created 

       for(uint i = 0; i <itemCount;i++){
        //get only unsold item.
        //check if the item has not been sold 
        //by checking if the owner field is empty
        if(idMarketItem[i+1].owner == address(0)){

            //yes this item has never been sold 
            uint currentId = idMarketItem[i+1].itemId;
            MarketItem storage currentItem = idMarketItem[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;

        }
       }

       return items; //return array of all unsold items.
    }
}