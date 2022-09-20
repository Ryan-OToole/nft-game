
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import "./libraries/Base64.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract MyEpicGame is ERC721, VRFConsumerBaseV2 {

    struct CharacterAttributes {
        address sender;
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHP;
        uint attackDamage;
        uint damageDone;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] allPlayersInGame;

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

    event CharacterNftMinted(address sender, uint tokenID, uint characterIndex, CharacterAttributes[] allPlayersInGame);
    event AttackComplete(address sender, uint newBossHP, uint newPlayerHP, uint damageDone, CharacterAttributes[] allPlayersInGame);
    event NftDeath(address sender, CharacterAttributes[] allPlayersInGame);

    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId;
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords =  2;
    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;
    uint256 randomNumber;

    constructor(        
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHP,
        uint[] memory characterAttackDamage,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage,
        uint64 subscriptionId
        ) ERC721("Darkwing Nights", "BATWING") VRFConsumerBaseV2(vrfCoordinator)
    {
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHP: bossHp,
            attackDamage: bossAttackDamage
        });
    
        for (uint i=0; i < characterNames.length; i++) {
            defaultCharacters.push(CharacterAttributes({
                sender: msg.sender,
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHP[i],
                maxHP: characterHP[i],
                attackDamage: characterAttackDamage[i],
                damageDone: 0
            }));
            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
        }
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
        _tokenIds.increment();
    }

    function mintCharacterNFT(uint _characterIndex) external {
        uint newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        nftHolderAttributes[newItemId] = CharacterAttributes({
            sender: msg.sender,
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHP: defaultCharacters[_characterIndex].maxHP,
            attackDamage: defaultCharacters[_characterIndex].attackDamage,
            damageDone: 0
        });
        allPlayersInGame.push(nftHolderAttributes[newItemId]);
        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        nftHolders[msg.sender] = newItemId;
        _tokenIds.increment();

        emit CharacterNftMinted(msg.sender, newItemId, _characterIndex, allPlayersInGame);
    }

    function tokenURI(uint _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];
        string memory stringHP = Strings.toString(charAttributes.hp);
        string memory stringMaxHP = Strings.toString(charAttributes.maxHP);
        string memory stringAttackDamage = Strings.toString(charAttributes.attackDamage);
        string memory stringDamageDone = Strings.toString(charAttributes.damageDone);

        string memory json = Base64.encode(
            abi.encodePacked(
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Darkwing Nights!", "image": "ipfs://',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',stringHP,', "max_value":',stringMaxHP,'}, { "trait_type": "Attack Damage", "value": ',
            stringAttackDamage,'}, { "trait_type": "Total Damage Dealt", "value": ',
            stringDamageDone,'} ]}'
            )
        );
        
        string memory output = string(abi.encodePacked("data:application/json;base64,", json));
        return output;
    }

    function attackBoss() public {
        // Get the state of the player's NFT.
        uint nftTokenIDPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIDPlayer];

        // Make sure the player has more than 0 HP.
        require(player.hp > 0, "Player has no HP cant play");
        // Make sure the boss has more than 0 HP.
        require(bigBoss.hp > 0, "Boss has no HP cant play");
        // Allow player to attack boss.
        if (bigBoss.hp < player.attackDamage) {
            player.damageDone += bigBoss.hp;
            bigBoss.hp = 0;
        }
        else {
            player.damageDone += player.attackDamage;
            bigBoss.hp -= player.attackDamage;
        }
        // Allow boss to attack player.
        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
        }
        else {
            player.hp -= bigBoss.attackDamage;
        }
        for (uint i=0; i < allPlayersInGame.length; i++) {
            if (allPlayersInGame[i].sender == msg.sender) {
                if (player.hp == 0) {
                    delete allPlayersInGame[i];
                    emit NftDeath(msg.sender, allPlayersInGame);
                } else {
                    allPlayersInGame[i] = player;
                }
            }
        }
        emit AttackComplete(msg.sender, bigBoss.hp, player.hp, player.damageDone, allPlayersInGame);
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

    function getAllPlayersInGame() public view returns (CharacterAttributes[] memory) {
        return allPlayersInGame;
    }

    function requestRandomWords() external onlyOwner {
        s_requestId = COORDINATOR.requestRandomWords(
        keyHash,
        s_subscriptionId,
        requestConfirmations,
        callbackGasLimit,
        numWords
        );
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        randomNumber = randomWords[0];
        s_randomWords = randomWords;
    }

  modifier onlyOwner() {
    require(msg.sender == s_owner);
    _;
  }
}