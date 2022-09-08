import { task } from 'hardhat/config';
import { deployContract } from '../lib/utils/deploy-contract';

task('deployDummyRaffle', 'Deploy Dummy Raffle Contract')
.addParam('vrf', 'VRF Coordinator Address')
.addParam('subid', 'Subscription ID')
.addParam('keyhash', 'Key hash')
.addFlag('verify', 'verify contracts on etherscan')
.setAction(async (args, { ethers, run }) => {
    await run("compile");

    const signer = (await ethers.getSigners())[0];
    console.log(`Signer ${signer.address}`);

    const raffleArgs = [
      args.vrf,
      args.subid,
      args.keyhash
    ]

    const contract = await deployContract(
      "dummyRaffle",
      await ethers.getContractFactory("DummyRaffle"),
      signer,
      raffleArgs
    );

    if (args.verify) {
      console.log("Verifying source on etherscan");
      await contract.deployTransaction.wait(8);
      await run("verify:verify", {
        address: contract.address,
        contract: "contracts/DummyRaffle.sol:DummyRaffle",
        constructorArguments: raffleArgs,
      });
    }

    console.log(`Make sure to add the rng contract as a consumer on chainlink`);
  });

