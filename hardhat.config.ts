import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  // networks: {
  //   mumbai: {
  //     url: process.env.TESTNET_RPC,
  //     accounts: [process.env.PRIVATE_KEY || "default"],
  //   },
  // },
  // etherscan: {
  //   apiKey: process.env.POLYGONSCAN_API_KEY,
  // },
  networks: {
    moonbeam: {
      url: process.env.TESTNET_RPC,
      chainId: 1287,
      accounts: [process.env.PRIVATE_KEY || "default"],
    },
  },
  etherscan: {
    // apiKey: process.env.POLYGONSCAN_API_KEY,
    apiKey: process.env.MOONBASESCAN_API_KEY,
  },
};

export default config;
