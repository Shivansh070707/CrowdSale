/*
private sale deployed to 0xFa5a0F57197E0ed5424E4bD31277f100e388A4Bc
distribute deployed to 0x39A5C4156e4282635C8e92e8Ab1F00472D5C062E
*/
const hre = require("hardhat");


async function main() {
  
  const owner='0x6e24689C13AeE0fabe6552f655607B71Cb425a44'
  token ='0x5B10cC2914bd546486De8db35a2133f12543Ab33'
  

  const PREICO = await hre.ethers.getContractFactory("preico");
  const preico = await PREICO.deploy(token,owner);

  await preico.deployed();

  console.log(
    `private sale deployed to ${preico.address}`
  );

  // const Distribute = await hre.ethers.getContractFactory("Distribute");
  // const distribute = await Distribute.deploy(owner,token );

  // await distribute.deployed();

  // console.log(
  //   `distribute deployed to ${distribute.address}`
  // );

}
async function verify(){
  const owner='0x6e24689C13AeE0fabe6552f655607B71Cb425a44'
  token ='0x5B10cC2914bd546486De8db35a2133f12543Ab33'
  pre='0xFa5a0F57197E0ed5424E4bD31277f100e388A4Bc'
  dis='0x39A5C4156e4282635C8e92e8Ab1F00472D5C062E'
 
  
  await hre.run("verify:verify", {
    address: pre,
    constructorArguments: [
      token,
      owner
    ]

  });
  // await hre.run("verify:verify", {
  //   address: dis,
  //   constructorArguments: [
  //  owner,token
  //   ],
  // });

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
