const {expect}= require("chai");
const {ethers}= require("hardhat");
const { BigNumber } = require("@ethersproject/bignumber");
const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
describe("Exchange",async function(){
    let owner;
    let data;
    let data1;
    let exc;
    let preico;
    let add1;
    let add2;
    beforeEach(async function(){
        const signers = await ethers.getSigners();
        owner = signers[0];
        add1=signers[1];
        add2=signers[2];
        const ERC20= await ethers.getContractFactory("Token");
        const erc20= await ERC20.deploy("SN","squad",18)
        await erc20.deployed()
        data1=erc20;

        const tokenadd= erc20.address;
        console.log(`deployed to ${erc20.address}`);

        const VEST= await ethers.getContractFactory("Vesting");
        const vest= await VEST.deploy(tokenadd,owner.address)
        await vest.deployed()
        data=vest;


        const vestadd=vest.address;
        console.log(`deployed to ${vestadd}`);
        data1.mint(owner.address,900000000);
        data1.mint(vest.address,1000)
    })
    it('should add vest',async function(){
        let Start=await time.latest();
        let End=Start + 60;
        await data.addVesting(Start,End,100);
        const bal=await data.vestingAmount(1)
        expect(bal).to.equal(100)
    })
    it('should release tokens',async function(){
        let Start=await time.latest();
        let End=Start + 7;
        await data.addVesting(Start,End,100);
        setTimeout(()=>{
         data.release(1)
        },8000)
    })
    it('should fail to release tokens before time',async function(){
        let Start=await time.latest();
        let End=Start + 7;
        await data.addVesting(Start,End,100);
        await expect(data.release(1)).to.be.revertedWith("Cannot release before releaseTime")
    })

})
