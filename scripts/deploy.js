// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
//const { ethers, utils } = require("ethers");
const hre = require("hardhat");

let RockScissor,rockscissor;
async function main() {


  RockScissor = await ethers.getContractFactory("RockPaperScissorsFact");
  rockscissor = await RockScissor.deploy();

  await rockscissor.deployed();
  console.log("rockscissors deployed to:", rockscissor.address);
  
  
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
