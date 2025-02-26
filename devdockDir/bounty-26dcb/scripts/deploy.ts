import { ethers } from "hardhat";

async function main() {
  // Deploy Robot NFT
  const RobotNFT = await ethers.getContractFactory("RobotNFT");
  const robotNFT = await RobotNFT.deploy();
  await robotNFT.waitForDeployment();
  console.log(`RobotNFT deployed to ${await robotNFT.getAddress()}`);

  // Deploy Alien NFT
  const AlienNFT = await ethers.getContractFactory("AlienNFT");
  const alienNFT = await AlienNFT.deploy();
  await alienNFT.waitForDeployment();
  console.log(`AlienNFT deployed to ${await alienNFT.getAddress()}`);

  // Deploy Mutant NFT
  const MutantNFT = await ethers.getContractFactory("MutantNFT");
  const mutantNFT = await MutantNFT.deploy(
    await robotNFT.getAddress(),
    await alienNFT.getAddress()
  );
  await mutantNFT.waitForDeployment();
  console.log(`MutantNFT deployed to ${await mutantNFT.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});