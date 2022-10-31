import { ethers } from "hardhat";

async function main() {
  const Bonvo = await ethers.getContractFactory("Bonvo");
  const bonvo = await Bonvo.deploy();

  await bonvo.deployed();

  console.log(`Bonvo was deployed to ${bonvo.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
