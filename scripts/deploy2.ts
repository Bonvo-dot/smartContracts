import { ethers } from "hardhat";

async function main() {
  const TokenBonvo = await ethers.getContractFactory("TokenBonvo");
  const tokenBonvo = await TokenBonvo.deploy(
    "0x835c5e2a8cfd2aec89f55b99d05c75de5f00debb"
  );

  await tokenBonvo.deployed();
  console.log(`Bonvo was deployed to ${tokenBonvo.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
