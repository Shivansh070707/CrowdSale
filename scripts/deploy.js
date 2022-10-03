// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
// import console from "console"
//goerli
// token deployed to 0xEaA8Df0496B7B11229F6Ba98e0Ee24B2cb528ecC
// private sale deployed to 0x25Ce9bA5aE6147471987B107CDA18a2cB2B4273a
// distribute deployed to 0xFC347fd6D85AcCd900D2671ce1245018dCB26b75

// deployed to 0x690Fee4200bf0a6286FF15b464Fc10Af91A5983B
// deployed to 0x5Aa239FC81Ef17Dc25989C67324d8D55aA794Bb5
// deployed to 0x9e24E856EC665EbB4B11C5F2D301835F7f445751
const hre = require("hardhat");


async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;
  // const Token = await hre.ethers.getContractFactory("Token");
  // const token = await Token.deploy("SS","squad",18);

  // await token.deployed();
  // const add=token.address;

  // console.log(
  //   `token deployed to ${add}`
  // );
  

  const PREICO = await hre.ethers.getContractFactory("preico");
  const preico = await PREICO.deploy('0xf701Ac6E7D62504101855A24185b7451fd4a2fFF','0x6e24689C13AeE0fabe6552f655607B71Cb425a44');

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
  const distribute = await Distribute.deploy(10,'0x6e24689C13AeE0fabe6552f655607B71Cb425a44','0xf701Ac6E7D62504101855A24185b7451fd4a2fFF' );

  await distribute.deployed();

  console.log(
    `distribute deployed to ${distribute.address}`
  );
// token deployed to 0xf701Ac6E7D62504101855A24185b7451fd4a2fFF
//private sale deployed to 0xd87283772acd6433BD52E0FF4D18fa13Ad4E3f1c
//distribute deployed to 0x02572Cd32F43eB2c461ab74966c7654507F0ace2
}
async function verify(){
  let token="0xf701Ac6E7D62504101855A24185b7451fd4a2fFF";
  let pre="0x9e24E856EC665EbB4B11C5F2D301835F7f445751";
  let dis="0x02572Cd32F43eB2c461ab74966c7654507F0ace2";
  let wallet="0x6e24689C13AeE0fabe6552f655607B71Cb425a44"
  // await hre.run("verify:verify", {
  //   address: token,
  //   constructorArguments: [
  //     "SS",
  //     "squad",
  //     18
  
  //   ],
  // });  
  // await hre.run("verify:verify", {
  //   address: pre,
  //   constructorArguments: [
  //     token,
  //     wallet
  //   ]

  // });
  await hre.run("verify:verify", {
    address: dis,
    constructorArguments: [
      10,
      wallet,
      token
    ],
  });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
verify().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
