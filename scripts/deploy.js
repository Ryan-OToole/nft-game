const main = async () => {
  const gameContractToDeploy = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractToDeploy.deploy(
    ["DogSquirrelMan", "PoodleMoth", "Batboy", "Batman"],
    [
      "QmPoqQiXkZpPqSAMdWa3iZKjM6644RgqhLtE4hbCNH8n9P", 
      "QmWcrwiSNQXi58zmuUGxYW7DrTijceSptRYyJmxfriwymZ", 
      "QmbrE7fyZKdSrPeAuvQFnaAqZs2LgeSi7GUzh14vE9f9HR",
      "QmfWhQq4D5cGtFHdXnkgjJcgM5AuLcuxCvCkVb1L2kSSsC"
    ],
    [100, 200, 300, 175],             
    [100, 50, 25, 125],                   
    "The Joker",
    "Qmb7Mpq61ezSXHUUBjpiKL51u9BMdSxhMxKP4Xkw4spPxg",
    850,
    50               
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  const VRFv2Consumer = await hre.ethers.getContractFactory('VRFv2Consumer');
  const VRFv2ConsumerDeployed = await VRFv2Consumer.deploy(1822);
  await VRFv2ConsumerDeployed.deployed();
  console.log("Contract deployed to:", VRFv2ConsumerDeployed.address);
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

