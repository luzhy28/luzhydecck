// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  console.log("Start deployment...");

  // Get the contract to deploy
  const EndOfLifeCareCommunity = await hre.ethers.getContractFactory("EndOfLifeCareCommunity");  
  
  console.log("Estimating gas...");
  const deployment = await EndOfLifeCareCommunity.deploy();  
  
  // Wait for deployment to be mined
  await deployment.deployed();

  console.log("Contract deployed to:", deployment.address);
  console.log("Network:", hre.network.name);
  console.log("Transaction Hash:", deployment.deployTransaction.hash);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
