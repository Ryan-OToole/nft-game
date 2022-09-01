const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
      ["SquirrelMan", "PoodleMoth", "Batboy", "Batman"],       // Names
      ["https://imgur.com/t/squirrel/4MJbBTY", // Images
      "https://imgur.com/gallery/8EvG6cN", 
      "https://imgur.com/gallery/uh5YEz4",
      "https://imgur.com/gallery/IC4DdQC"
    ],
      
      [100, 200, 300, 175],                    // HP values
      [100, 50, 25, 125],                      // Attack damage values
      "The Joker",
      "https://imgur.com/gallery/hUU4ulH",
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

    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();
    console.log("Minted NFT #3");

    txn = await gameContract.mintCharacterNFT(3);
    await txn.wait();
    console.log("Minted NFT #4");

    txn = await gameContract.attackBoss();
    await txn.wait();

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