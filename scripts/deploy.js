const hre= require("hardhat");

async function main() {
  const DataStorage = await hre.ethers.getContractFactory("DataStorage");
  const dataStorage = await DataStorage.deploy();
  await dataStorage.deployed();
  console.log("Contract deployed to:", dataStorage.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});