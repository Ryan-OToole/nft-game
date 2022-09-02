// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import "./libraries/Base64.sol";

contract MyEpicGame is ERC721 {

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHP;
        uint attackDamage;
    }

      // The tokenId is the NFTs unique identifier, it's just a number that goes
      // 0, 1, 2, 3, etc.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] defaultCharacters;

    mapping(uint => CharacterAttributes) public nftHolderAttributes;

    struct BigBoss {
        string name;
        string imageURI;
        uint hp;
        uint maxHP;
        uint attackDamage;
    }

    BigBoss public bigBoss;

    mapping(address => uint) public nftHolders;

    event CharacterNftMinted(address sender, uint tokenID, uint characterIndex);
    event AttackComplete(address sender, uint newBossHP, uint newPlayerHP);

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHP,
        uint[] memory characterAttackDamage,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    )     ERC721("Animales", "ANIMAL")
    {
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHP: bossHp,
            attackDamage: bossAttackDamage
        });

        console.log("Done initializing boss %s w/ HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);

        for (uint i=0; i < characterNames.length; i++) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHP[i],
                maxHP: characterHP[i],
                attackDamage: characterAttackDamage[i]
            }));
            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
        }
        _tokenIds.increment();
    }

    function mintCharacterNFT(uint _characterIndex) external {
        uint newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHP: defaultCharacters[_characterIndex].maxHP,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();

        emit CharacterNftMinted(msg.sender, newItemId, _characterIndex);
    }

    function tokenURI(uint _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];
        string memory stringHP = Strings.toString(charAttributes.hp);
        string memory stringMaxHP = Strings.toString(charAttributes.maxHP);
        string memory stringAttackDamage = Strings.toString(charAttributes.attackDamage);


        string memory json = Base64.encode(
            abi.encodePacked(
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',stringHP,', "max_value":',stringMaxHP,'}, { "trait_type": "Attack Damage", "value": ',
            stringAttackDamage,'} ]}'
            )
        );
        
        string memory output = string(abi.encodePacked("data:application/json;base64,", json));
        return output;
    }

    function attackBoss() public {
        // Get the state of the player's NFT.
        uint nftTokenIDPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIDPlayer];
        console.log("\nPlayer w/ character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
        console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);
        // Make sure the player has more than 0 HP.
        require(player.hp > 0, "Player has no HP cant play");
        // Make sure the boss has more than 0 HP.
        require(bigBoss.hp > 0, "Boss has no HP cant play");
        // Allow player to attack boss.
        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
        }
        else {
            bigBoss.hp -= player.attackDamage;
        }
        // Allow boss to attack player.
        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        }
        else {
            player.hp -= bigBoss.attackDamage;
        }
        // Console for ease.
        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s\n", player.hp);
        emit AttackComplete(msg.sender, bigBoss.hp, player.hp);
    }

    function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
        uint256 userNftTokenID = nftHolders[msg.sender];
        if (userNftTokenID > 0) {
            return nftHolderAttributes[userNftTokenID];
        }
        else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }
 }
