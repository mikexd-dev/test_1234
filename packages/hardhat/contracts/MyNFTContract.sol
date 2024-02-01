// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFTContract is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct NFT {
        string name;
        string description;
        uint256 price;
    }

    mapping(uint256 => NFT) private _nfts;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function createNFT(string memory name, string memory description, uint256 price)
        public
        returns (uint256)
    {
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();

        _safeMint(msg.sender, newTokenId);

        _nfts[newTokenId] = NFT(name, description, price);

        return newTokenId;
    }

    function getNFT(uint256 tokenId)
        public
        view
        returns (
            string memory name,
            string memory description,
            uint256 price
        )
    {
        require(_exists(tokenId), "NFT does not exist");
        NFT memory nft = _nfts[tokenId];
        return (nft.name, nft.description, nft.price);
    }

    function purchaseNFT(uint256 tokenId) public payable {
        require(_exists(tokenId), "NFT does not exist");
        NFT memory nft = _nfts[tokenId];
        require(msg.value >= nft.price, "Insufficient payment");

        address payable owner = payable(ownerOf(tokenId));
        owner.transfer(msg.value);

        _transfer(owner, msg.sender, tokenId);
    }
}