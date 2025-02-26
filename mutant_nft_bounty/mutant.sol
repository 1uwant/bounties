// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract MutantNFT is ERC721URIStorage, Ownable {
    IERC721 public nftA;
    IERC721 public nftB;
    uint256 public nextMutantId;

    event Mutated(address indexed owner, uint256 tokenIdA, uint256 tokenIdB, uint256 newTokenId);

    constructor(address _nftA, address _nftB) ERC721("MutantNFT", "MUTANT") {
        nftA = IERC721(_nftA);
        nftB = IERC721(_nftB);
    }

    function mutate(uint256 tokenIdA, uint256 tokenIdB, string memory newTokenURI) public {
        require(nftA.ownerOf(tokenIdA) == msg.sender, "Not owner of NFT_A");
        require(nftB.ownerOf(tokenIdB) == msg.sender, "Not owner of NFT_B");

        // Burn original NFTs
        nftA.transferFrom(msg.sender, address(0xdead), tokenIdA);
        nftB.transferFrom(msg.sender, address(0xdead), tokenIdB);

        // Mint new Mutant NFT
        uint256 mutantId = nextMutantId;
        _safeMint(msg.sender, mutantId);
        _setTokenURI(mutantId, newTokenURI);
        nextMutantId++;

        emit Mutated(msg.sender, tokenIdA, tokenIdB, mutantId);
    }
}
