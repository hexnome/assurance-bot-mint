/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv");

dotenv.config();
module.exports = {
  defaultNetwork: "bsctest",
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  paths: {
    sources: "./contracts",
    artifacts: "./artifacts",
    deploy: "./scripts",
  },
  networks: {
    hardhat: {
    },
    bsctest: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      accounts: [process.env.PRIVATE_KEY, process.env.PRIVATE_KEY1, process.env.PRIVATE_KEY2]
    },
    bsc: {
      url: 'https://nodes.pancakeswap.info',
      accounts: [process.env.PRIVATE_KEY]
    },
    goerli: {
      url: "https://eth-goerli.public.blastapi.io",
      accounts: [process.env.PRIVATE_KEY]
    },
    bbfork: {
      url: 'https://rpc.buildbear.io/equivalent-han-solo-113f85af',
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.API_KEY,
  },
};
