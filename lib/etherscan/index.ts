import { normalize } from "path";

export namespace Etherscan {
  export enum Network {
    Mainnet = "mainnet",
    Goerli = "goerli",
    Rinkeby = "rinkeby",
    Sepolia = "sepolia",
    Ropsten = "ropsten",
    Kovan = "kovan",
  }
  
  export const networkByChainId: Record<number, Network> = {
    1: Network.Mainnet,
    3: Network.Ropsten,
    4: Network.Rinkeby,
    5: Network.Goerli,
    42: Network.Kovan,
    11155111: Network.Sepolia,
  };

  export enum LinkType {
    BaseUrl = "",
    Block = "block",
    Address = "address",
    Tx = "tx",
    Token = "token",
  }

  const etherscanUrls: Record<Network, string> = {
    [Network.Mainnet]: "https://etherscan.io",
    [Network.Goerli]: "https://goerli.etherscan.io",
    [Network.Rinkeby]: "https://rinkeby.etherscan.io",
    [Network.Sepolia]: "https://sepolia.etherscan.io",
    [Network.Ropsten]: "https://ropsten.etherscan.io",
    [Network.Kovan]: "https://kovan.etherscan.io",
  };

  export function getLink(
    type = LinkType.BaseUrl,
    network = Network.Mainnet,
    value = ""
  ): string {
    return new URL(
      normalize(`${etherscanUrls[network]}/${type}/${value}`)
    ).toString();
  }
}
