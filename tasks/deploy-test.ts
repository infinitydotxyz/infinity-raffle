import { task } from "hardhat/config.js";
import { deployContract } from '../lib/utils/deploy-contract';

task("deployTest", "Deploy Test Contract")
  .addFlag("verify", "verify contracts on etherscan")
  .setAction(async (args, { ethers, run }) => {
    await run("compile");

    const signer = (await ethers.getSigners())[0];
    console.log(`Signer ${signer.address}`);

    const testContract = await deployContract(
      "Test",
      await ethers.getContractFactory("Test"),
      signer
    );

    if (args.verify) {
      console.log("Verifying source on etherscan");
      await testContract.deployTransaction.wait(8);
      await run("verify:verify", {
        address: testContract.address,
        contract: "contracts/Test.sol:Test",
      });
    }
  });
