import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";
import "solidity-coverage";
import "hardhat-contract-sizer"
import { HardhatUserConfig } from "hardhat/types";
import { config } from "dotenv";
config();

/**
 * TASKS
 */
import "./tasks/deploy-test";

const hardhatConfig: HardhatUserConfig = {
  networks: {
    hardhat: {
      allowUnlimitedContractSize: false,
      gas: 12000000,
      blockGasLimit: 30_000_000,
    },
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${process.env.ALCHEMY_GOERLI_KEY}`,
      accounts: [process.env.ETH_GOERLI_PRIV_KEY ?? ''] 
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
    ],
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY ?? '',
      goerli: process.env.ETHERSCAN_API_KEY ?? '',
    }
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
};

export default hardhatConfig;
