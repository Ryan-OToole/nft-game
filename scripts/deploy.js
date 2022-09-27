const main = async () => {
  const gameContractToDeploy = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractToDeploy.deploy(
    ["DogSquirrelMan", "PoodleMoth", "Batboy", "Batman"],
    ["QmPoqQiXkZpPqSAMdWa3iZKjM6644RgqhLtE4hbCNH8n9P", 
      "QmWcrwiSNQXi58zmuUGxYW7DrTijceSptRYyJmxfriwymZ", 
      "QmbrE7fyZKdSrPeAuvQFnaAqZs2LgeSi7GUzh14vE9f9HR",
      "QmfWhQq4D5cGtFHdXnkgjJcgM5AuLcuxCvCkVb1L2kSSsC"],
    [100, 200, 300, 175],             
    [100, 50, 50, 125],                   
    "The Joker",
    "Qmb7Mpq61ezSXHUUBjpiKL51u9BMdSxhMxKP4Xkw4spPxg",
    600,
    50,
    '1823'
  );
  await gameContract.deployed();
  console.log("Contract deployed to game:", gameContract.address);
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

