require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require('@nomiclabs/hardhat-waffle');
 require("dotenv").config({ path: ".env" });

 module.exports = {
   solidity: {
    compilers: [
      {
        version: "0.8.1",
        settings: {},
      },
      {
        version: "0.8.4",
        settings: {},
      },
      {
        version: "0.8.7",
        settings: {},
      },
    ],
  },
   networks: {
    goerli: {
      url: process.env.INFURA_API_GOERLI,
      accounts: [process.env.METAMASK_KEY_GOERLI],
      chainId: 5
     },
     rinkeby: {
       url: process.env.INFURA_API_RINKEBY,
       accounts: [process.env.METAMASK_KEY_RINKEBY],
       chainId: 4
     },
   },
 };

