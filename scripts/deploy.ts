import { ethers } from "hardhat";

async function main() {
  const Bonvo = await ethers.getContractFactory("Bonvo");
  const bonvo = await Bonvo.deploy();
  await bonvo.deployed();

  console.log(`Bonvo was deployed to ${bonvo.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
