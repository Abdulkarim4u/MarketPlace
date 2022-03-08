const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarket", function () {
  it("Should create and execute market sales", async function () {
    const Market = await ethers.getContractFactory("NFTMarket");
    const market = await Market.deploy();
    await market.deployed();  //deploy the NFTMarket contract 
    //we can access the marketaddress
    const marketAddress = market.address


    const NFT = await ethers.getContractFactory("NFT");
    const nft = await Market.deploy();
    await nft.deployed(); //deploy the NFT contract.
    const nftContractAddress = nft.address;

    //create a listing price 
    let listingPrice = await market.getListingPrice();

    listingPrice = listingPrice.toString();
    
    //set an auction price 
    const auctionPrice = ethers.utils.parseUnits('100',"ether")
    
    //create 2 test tokens.
    await nft.createToken("https://www.mytokenlocation.com");
    await nft.createToken("https://www.mytokenlocation2.com");

    //create 2 test nfts 
    await market.createMarketItem(nftContractAddress,1,auctionPrice,{value:listingPrice});

    await market.createMarketItem(nftContractAddress,2,auctionPrice,{value:listingPrice});


    

    
  });
});
