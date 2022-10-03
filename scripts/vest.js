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
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });