// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
// import console from "console"

// deployed to 0x690Fee4200bf0a6286FF15b464Fc10Af91A5983B
// deployed to 0x5Aa239FC81Ef17Dc25989C67324d8D55aA794Bb5
// deployed to 0x9e24E856EC665EbB4B11C5F2D301835F7f445751
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
    `token deployed to ${add}`
  );
  

  const PREICO = await hre.ethers.getContractFactory("preico");
  const preico = await PREICO.deploy(add,'0x6e24689C13AeE0fabe6552f655607B71Cb425a44');

  await preico.deployed();

  console.log(
    `private sale deployed to ${preico.address}`
  );

  // const ICO = await hre.ethers.getContractFactory("ICO");
  // const ico = await ICO.deploy(add,
  // '0x6e24689C13AeE0fabe6552f655607B71Cb425a44'
  
  // );

  // await ico.deployed();

  // console.log(
  //   `deployed to ${ico.address}`
  // );
  const Distribute = await hre.ethers.getContractFactory("Distribute");
  const distribute = await Distribute.deploy(10,'0x6e24689C13AeE0fabe6552f655607B71Cb425a44',add  );

  await distribute.deployed();

  console.log(
    `distribute deployed to ${distribute.address}`
  );

}
async function verify(){
  // await hre.run("verify:verify", {
  //   address: '0x690Fee4200bf0a6286FF15b464Fc10Af91A5983B',
  //   constructorArguments: [
  //     "SS",
  //     "squad",
  //     18
  
  //   ],
  // });  
  // await hre.run("verify:verify", {
  //   address: '0x5Aa239FC81Ef17Dc25989C67324d8D55aA794Bb5',
  //   constructorArguments: [
  //     '0x690Fee4200bf0a6286FF15b464Fc10Af91A5983B',
  //     '0x6e24689C13AeE0fabe6552f655607B71Cb425a44'
  //   ],
  // // });
  // await hre.run("verify:verify", {
  //   address: '0x9e24E856EC665EbB4B11C5F2D301835F7f445751',
  //   constructorArguments: [
  //     144,
  //     '0x07CEd93F06d289fac997BA876755011F0420A05E',
  //     '0x690Fee4200bf0a6286FF15b464Fc10Af91A5983B'
  //   ],
  // });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
