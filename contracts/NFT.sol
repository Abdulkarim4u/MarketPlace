//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; //storing files
import "@openzeppelin/contracts/utils/Counters.sol";



contract NFT is ERC721URIStorage{
         //auto-increment field for each token //storage.

         using Counters for Counters.Counter;
         Counters.Counter private _tokenIds;

         address contractAddress;

         constructor(address marketplaceAddress)ERC721("SIKANU METAVERS tokens", "SMT"){

             contractAddress = marketplaceAddress; // within memory

         }

         ///@notice create  a new token 
         ///@param tokenURI : token URI 
         function createToken(string memory tokenURI)  public returns(uint){
            //set a new token id for the token to be minted.
             _tokenIds.increment(); //increament token id 0 , 1, 2 , 3, 4, ....
             uint256 newItemId = _tokenIds.current();

             _mint(msg.sender, newItemId) //mint the token 
             _setTokenURI(newItemId, tokenURI); // generate URI
             SetApprovalForAll(contractAddress,true);// grant transaction permission to marketplace.

             // return token ID
             return newItemId;

         }


}