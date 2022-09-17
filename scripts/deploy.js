// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;
  const Token = await hre.ethers.getContractFactory("Token");
  const token = await Token.deploy("SS","squad",18);

  await token.deployed();
  const add=token.address;

  console.log(
    `deployed to ${token.address}`
  );

  const PREICO = await hre.ethers.getContractFactory("preico");
  const preico = await PREICO.deploy(add,
  '0x6e24689C13AeE0fabe6552f655607B71Cb425a44',50000,900000000
  
  );

  await preico.deployed();

  console.log(
    `deployed to ${preico.address}`
  );
  const ICO = await hre.ethers.getContractFactory("ICO");
  const ico = await ICO.deploy(add,
  '0x6e24689C13AeE0fabe6552f655607B71Cb425a44'
  
  );

  await ico.deployed();

  console.log(
    `deployed to ${ico.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
