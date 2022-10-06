/*
token deployed to 0x5B10cC2914bd546486De8db35a2133f12543Ab33
foundersTimeLock deployed to 0x895aadbe123Fc95C95010cDCB5431aD9F09Baa70
AdvisorTimeLock deployed to 0x694DAb2e697e3ed65143347D73483B970c64433e
MarketingTimeLock deployed to 0x788eafA52d6CC7Aab5dE55398A5f7B5778b99C7D
PublicTimeLock deployed to 0x2381C4F2026C4D7C12EE5090658E7aFB9bA5f6A8
EcoSystemTimeTimeLock deployed to 0xF72663305dF976bA8c1b44Ceab69B7946d1B696B
*/
const hre = require("hardhat");
async function main() {
    const owner='0x6e24689C13AeE0fabe6552f655607B71Cb425a44'
    const add1='0xb824465A26846eF8f7E6Ce3a2AEEc2F359690218'
    const add2='0x784aD26F3dff4B164979F36724d8E0297dc2581e'
   const Token = await hre.ethers.getContractFactory("Token");
   const token = await Token.deploy("SS","squad",18);
   await token.deployed();
    const add=token.address;

  console.log(
    `token deployed to ${add}`
  );
  const Vest = await hre.ethers.getContractFactory("Vesting")
  const foundersTimelock= await Vest.deploy(add,add1)
  await foundersTimelock.deployed()
  console.log(`foundersTimeLock deployed to ${foundersTimelock.address}`);

  const AdvisorTimelock= await Vest.deploy(add,add2)
  await AdvisorTimelock.deployed()
  console.log(`AdvisorTimeLock deployed to ${AdvisorTimelock.address}`);

  const MarketingTimelock= await Vest.deploy(add,add2)
  await MarketingTimelock.deployed()
  console.log(`MarketingTimeLock deployed to ${MarketingTimelock.address}`);

  const PublicTimelock= await Vest.deploy(add,owner)
  await PublicTimelock.deployed()
  console.log(`PublicTimeLock deployed to ${PublicTimelock.address}`);
  
  const EcoSystemTimelock= await Vest.deploy(add,add1)
  await EcoSystemTimelock.deployed()
  console.log(`EcoSystemTimeTimeLock deployed to ${EcoSystemTimelock.address}`);



}
async function verify(){
    const owner='0x6e24689C13AeE0fabe6552f655607B71Cb425a44'
    const add1='0xb824465A26846eF8f7E6Ce3a2AEEc2F359690218'
    const add2='0x784aD26F3dff4B164979F36724d8E0297dc2581e'
token ='0x25Ce9bA5aE6147471987B107CDA18a2cB2B4273a'
foundersTimeLock ='0xFC347fd6D85AcCd900D2671ce1245018dCB26b75'
AdvisorTimeLock ='0x62b461408c3C36032f592668285DDaaa29F72324'
MarketingTimeLock ='0x2709D28A0D5E422360DdB32eD7BBfd5C6a31FEd9'
PublicTimeLock ='0x2aE1679128E73Af1E20ED3D574eA2e578F1580cc'
EcoSystemTimeLock ='0x19C3CAfdFF6dBe7d75FDf82FF2E601126311f680'
/*
goerli
token ='0x5B10cC2914bd546486De8db35a2133f12543Ab33'
foundersTimeLock ='0x895aadbe123Fc95C95010cDCB5431aD9F09Baa70'
AdvisorTimeLock ='0x694DAb2e697e3ed65143347D73483B970c64433e'
MarketingTimeLock ='0x788eafA52d6CC7Aab5dE55398A5f7B5778b99C7D'
PublicTimeLock ='0x2381C4F2026C4D7C12EE5090658E7aFB9bA5f6A8'
EcoSystemTimeLock ='0xF72663305dF976bA8c1b44Ceab69B7946d1B696B'
*/




await hre.run("verify:verify", {
    address: token,
    constructorArguments: [
      "SS","squad",18
    ],
  });
  await hre.run("verify:verify", {
    address: foundersTimeLock,
    constructorArguments: [
      token,add1
    ],
  });
  await hre.run("verify:verify", {
    address: AdvisorTimeLock,
    constructorArguments: [
      token,add2
    ],
  });
  await hre.run("verify:verify", {
    address: MarketingTimeLock,
    constructorArguments: [
      token,add2
 ],
  });
  await hre.run("verify:verify", {
    address: PublicTimeLock,
    constructorArguments: [
      token,owner
    ],
  });
  await hre.run("verify:verify", {
    address: EcoSystemTimeLock,
    constructorArguments: [
      token,add1
    ],
  });

}
verify().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });