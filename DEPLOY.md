# Deployment and Setup Documentation for EndOfLifeCareCommunity Contract

## Prerequisites
- Node.js (version >= 14.x)
- npm (Node Package Manager)
- Truffle (or Hardhat) installed globally  
- Access to Ethereum wallets (e.g., MetaMask)
- Infura or Alchemy account for accessing Ethereum networks

## Installation Steps
1. **Clone the Repository**  
   Run the following command to clone the repository:  
   ```bash  
   git clone https://github.com/luzhy28/luzhydecck.git  
   cd luzhydecck  
   ```  

2. **Install Dependencies**  
   Navigate to the project directory and install the required npm packages:  
   ```bash  
   npm install  
   ```  

## Contract Deployment Instructions
### Deploying to Ethereum Mainnet
1. **Setup .env file**  
   Create a `.env` file in the root directory and add the following variables:  
   ```bash  
   INFURA_API_KEY=<your_infura_api_key>  
   PRIVATE_KEY=<your_wallet_private_key>  
   ```  
2. **Deploy the Contract**  
   Run the following command to deploy:  
   ```bash  
   truffle migrate --network mainnet  
   ```  

### Deploying to Sepolia Testnet
1. **Set up .env file for Sepolia**  
   Use the same `.env` file but change to your Sepolia API key if needed.  
2. **Deploy the Contract**  
   Run:  
   ```bash  
   truffle migrate --network sepolia  
   ```  

### Deploying to Goerli Testnet
1. **Setup .env file for Goerli**  
   Again, ensure your `.env` has the correct API key for Goerli.
2. **Deploy the Contract**  
   Execute:  
   ```bash  
   truffle migrate --network goerli  
   ```  

## Basic Usage Examples
### Interacting with the Deployed Contract
1. Open a terminal and run the following to enter the Truffle console:  
   ```bash  
   truffle console --network mainnet  
   ```  

2. **Instantiate the Contract**  
   ```javascript
   let contract = await EndOfLifeCareCommunity.deployed();
   ```  

3. **Call a Function (Example: getStatus)**  
   ```javascript
   let status = await contract.getStatus();
   console.log(status);
   ```  

4. **Send a Transaction (Example: updateStatus)**  
   ```javascript
   await contract.updateStatus(newStatus);
   ```  

---  
This documentation aims to provide a clear and concise guide for deploying and using the EndOfLifeCareCommunity smart contract on different Ethereum networks.