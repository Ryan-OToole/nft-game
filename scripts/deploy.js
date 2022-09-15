const main = async () => {
  const gameContractToDeploy = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractToDeploy.deploy(
    ["DogSquirrelMan", "PoodleMoth", "Batboy", "Batman"],       // Names
    ["QmPoqQiXkZpPqSAMdWa3iZKjM6644RgqhLtE4hbCNH8n9P", // Images
    "QmWcrwiSNQXi58zmuUGxYW7DrTijceSptRYyJmxfriwymZ", 
    "QmbrE7fyZKdSrPeAuvQFnaAqZs2LgeSi7GUzh14vE9f9HR",
    "QmfWhQq4D5cGtFHdXnkgjJcgM5AuLcuxCvCkVb1L2kSSsC"
  ],
    
    [100, 200, 300, 175],                    // HP values
    [100, 50, 25, 125],                      // Attack damage values
    "The Joker",
    "Qmb7Mpq61ezSXHUUBjpiKL51u9BMdSxhMxKP4Xkw4spPxg",
    850,
    50               
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);




  // const rng = await hre.ethers.getContractFactory('RandomNumberGenerator');
  // const rngDeployed = await rng.deploy();
  // await rng.deployed();
  // console.log("Contract deployed to:", rng.address);
  // const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGameFactory');
  // const gameContractFactoryInstance = await gameContractFactory.deploy(
  //   ["DogSquirrelMan", "PoodleMoth", "Batboy", "Batman"],       // Names
  //   ["QmPoqQiXkZpPqSAMdWa3iZKjM6644RgqhLtE4hbCNH8n9P", // Images
  //   "QmWcrwiSNQXi58zmuUGxYW7DrTijceSptRYyJmxfriwymZ", 
  //   "QmbrE7fyZKdSrPeAuvQFnaAqZs2LgeSi7GUzh14vE9f9HR",
  //   "QmfWhQq4D5cGtFHdXnkgjJcgM5AuLcuxCvCkVb1L2kSSsC"
  // ],
    
  //   [100, 200, 300, 175],                    // HP values
  //   [100, 50, 25, 125],                      // Attack damage values
  //   "The Joker",
  //   "Qmb7Mpq61ezSXHUUBjpiKL51u9BMdSxhMxKP4Xkw4spPxg",
  //   850,
  //   50               
  // );
  // await gameContractFactoryInstance.deployed();
  // console.log("gameContractFactoryInstance deployed to:", gameContractFactoryInstance.address);
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

