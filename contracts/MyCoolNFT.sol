// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "./libraries/Base64.sol";

contract MyCoolNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] NameWords = [
        "Ronaldo",
        "Messi",
        "Neymar",
        "Benzema",
        "Suarez",
        "DeBruyne",
        "Hazard",
        "Fernandes",
        "Kante",
        "HMson",
        "Courtois",
        "Aubameyang",
        "Parejo",
        "Felix"
    ];
    string[] AdjWords = [
        "Goat",
        "Diver",
        "Skillful",
        "Playful",
        "Serious",
        "Awesome",
        "Tank",
        "Beast",
        "Greatest",
        "Winner"
    ];
    string[] PositionWords = [
        "Striker",
        "Goalie",
        "Midfielder",
        "Winger",
        "CenterBack",
        "WingBack",
        "LeftBack",
        "RightBack",
        "DefMid",
        "AttackingMid",
        "FalseNine"
    ];

    // pass the name of our NFTs token and its symbol.
    constructor() ERC721("FootBallNFT", "Soccer") {
        console.log("This is my NFT contract. cool!");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % NameWords.length;
        return NameWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % AdjWords.length;
        return AdjWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % PositionWords.length;
        return PositionWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeCoolNFT() public {
        // Get the current tokenId, starts at 0.
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        // concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, first, second, third, "</text></svg>")
        );
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of FootBallNFT.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");
        // mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);
        _setTokenURI(
            newItemId,
            "ipfs://QmZKRQFRQFrjaz8Dx5SKSPyeVW31q7n7GTCBvx4yQPWJEo"
        );

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}
