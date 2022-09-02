const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
      ["DogSquirrelMan", "PoodleMoth", "Batboy", "Batman"],       // Names
      ["https://i.imgur.com/o7iAFMu.png", // Images
      "https://i.imgur.com/8EvG6cN.png", 
      "https://i.imgur.com/uh5YEz4.png",
      "https://i.imgur.com/IC4DdQC.png"
    ],
      
      [100, 200, 300, 175],                    // HP values
      [100, 50, 25, 125],                      // Attack damage values
      "The Joker",
      "https://i.imgur.com/hUU4ulH.png",
      850,
      50               
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #1");

    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #2");

    txn = await gameContract.mintCharacterNFT(3);
    await txn.wait();
    console.log("Minted NFT #1");

    txn = await gameContract.mintCharacterNFT(4);
    await txn.wait();
    console.log("Minted NFT #2");

    txn = await gameContract.attackBoss();
    await txn.wait();
    
    console.log("Done deploying and minting!");
}
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };

  runMain();