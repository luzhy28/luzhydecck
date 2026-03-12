require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');

// This is a sample Hardhat task. To learn how to create your own go to https://hardhat.org/guides/create-task.html

task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: {
    version: "0.8.20",
  },
  networks: {
    sepolia: {
      url: 'https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID', // Replace with your Infura project ID
      accounts: ['0xYOUR_PRIVATE_KEY'], // Replace with your wallet private key
    },
    mainnet: {
      url: 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID', // Replace with your Infura project ID
      accounts: ['0xYOUR_PRIVATE_KEY'], // Replace with your wallet private key
    },
  },
  etherscan: {
    apiKey: 'YOUR_ETHERSCAN_API_KEY', // Replace with your Etherscan API Key
  },
};