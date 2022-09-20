const main = async () => {
  const gameContractToDeploy = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractToDeploy.deploy(
    ["DogSquirrelMan"],
    ["QmPoqQiXkZpPqSAMdWa3iZKjM6644RgqhLtE4hbCNH8n9P"],
    [100],             
    [100],                   
    "The Joker",
    "Qmb7Mpq61ezSXHUUBjpiKL51u9BMdSxhMxKP4Xkw4spPxg",
    850,
    50               
  );
  await gameContract.deployed();
  console.log("Contract deployed to game:", gameContract.address);
  let characters = await gameContract.getAllDefaultCharacters();
  console.log('characters', characters)

  // const VRFv2Consumer = await hre.ethers.getContractFactory('VRFv2Consumer');
  // const VRFv2ConsumerDeployed = await VRFv2Consumer.deploy(1822);
  // await VRFv2ConsumerDeployed.deployed();
  // console.log("Contract deployed to vrf:", VRFv2ConsumerDeployed.address);
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

