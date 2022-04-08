//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract LowBrainCat is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    uint256 public constant MAX_SUPPLY = 1111;
    address public constant creatorAddress =
        0xde7D5C5b72b8Ae6706b67adBadE9fe4d21ED4064;

    string public baseTokenURI;

    constructor() ERC721("LowBrainCat", "LBC") {}

    function mint(string memory tokenURI) public payable onlyOwner {
        uint256 currentSupply = _totalSupply();
        require(currentSupply <= MAX_SUPPLY, "Reach limit");
        _mintAnElement(msg.sender, tokenURI);
    }

    function _totalSupply() internal view returns (uint256) {
        return _tokenIds.current();
    }

    function _mintAnElement(address _to, string memory tokenURI)
        private
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 tokenId = _totalSupply();
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }

    function withdrawAll() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0);
        _widthdraw(creatorAddress, address(this).balance);
    }

    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }
}
