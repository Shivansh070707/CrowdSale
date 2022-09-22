const {expect}= require("chai");
const {ethers}= require("hardhat");
const BigNumber = require('bignumber.js');
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

        const PREICO= await ethers.getContractFactory("preico");
        preico= await PREICO.deploy(tokenadd,owner.address)
        await preico.deployed()


        const preicoadd= preico.address;
        console.log(`deployed to ${preicoadd}`);
        
        // const ICO= await ethers.getContractFactory("ICO");
        // const ico= await ICO.deploy(tokenadd,owner.address)
        // await ico.deployed()
        // console.log(`deployed to ${ico.address}`);

        const CS= await ethers.getContractFactory("Distribute");
        const cs= await CS.deploy(144,owner.address,erc20.address,preico.address)
        await cs.deployed()
        data=cs;
        console.log(`deployed to ${cs.address}`);

      
    })
    // it("will fetch private saletoken",async function(){
    //     await data.connect(owner).finalize();
    //     const bal= await new data1.balanceOf(preico.address);
    //     expect(bal).to.equal(9)
    // })

    it("gug",async function(){
        await data.connect(owner).finalize();
        const add3= await data.PublicTimelock();
        const bal= await data1.balanceOf(add3)
        expect(bal).to.equal(250)

})
})