const {expect}= require("chai");
const {ethers}= require("hardhat");
describe("Exchange",async function(){
    let owner;
    let data;
    let exc;
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

        const tokenadd= erc20.address;

        const PREICO= await ethers.getContractFactory("preico");
        const preico= await PREICO.deploy(tokenadd,owner.address)
        await preico.deployed()

        const preicoadd= preico.address;
        
        const ICO= await ethers.getContractFactory("ICO");
        const ico= await ICO.deploy(tokenadd,owner.address)
        await ico.deployed()

      
    })
    it("",async function(){
 
    })

    it("",async function(){

})
})