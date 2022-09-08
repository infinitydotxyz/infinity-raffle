import { Contract, ContractFactory, Signer } from "ethers";
import { Etherscan } from "../etherscan";

export async function deployContract(
  name: string,
  factory: ContractFactory,
  signer: Signer,
  args: Array<any> = []
): Promise<Contract> {
  let signerNetwork = await signer.provider?.getNetwork();
  let chainId = signerNetwork?.chainId;
  const network = Etherscan.networkByChainId[chainId || 1];
  const contract = await factory.connect(signer).deploy(...args);

  console.log(`Deploying contract ${name} to ${contract.address} in tx: ${contract.deployTransaction.hash} Network: ${network}`);
  console.log(Etherscan.getLink(Etherscan.LinkType.Tx, network, contract.deployTransaction.hash));
  
  return contract.deployed();
}
