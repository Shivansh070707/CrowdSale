// const {expect}= require("chai");
// const {ethers}= require("hardhat");
// const { BigNumber } = require("@ethersproject/bignumber");
// describe("Exchange",async function(){
//     let owner;
//     let data;
//     let data1;
//     let exc;
//     let preico;
//     let add1;
//     let add2;
//     beforeEach(async function(){
//         const signers = await ethers.getSigners();
//         owner = signers[0];
//         add1=signers[1];
//         add2=signers[2];
//         const ERC20= await ethers.getContractFactory("Token");
//         const erc20= await ERC20.deploy("SN","squad",18)
//         await erc20.deployed()
//         data1=erc20;

//         const tokenadd= erc20.address;
//         console.log(`deployed to ${erc20.address}`);

//         const PREICO= await ethers.getContractFactory("preico");
//         preico= await PREICO.deploy(tokenadd,owner.address)
//         await preico.deployed()
//         data=preico;


//         const preicoadd= preico.address;
//         console.log(`deployed to ${preicoadd}`);
//         data1.mint(owner.address,900000000);
//         data1.connect(owner).approve(preicoadd,900000000)
//     })
//     it("should fetch owner bal",async function(){
//         let bal= await data1.balanceOf(owner.address)
//         expect(bal).to.equal(900000000)
//     })
//     it("should retrive eth price correctly",async function(){
//         let eth = await data.currentPriceEth()
//         expect(eth).to.equal(130845152133);
//     })
//     it("should retrive token price correctly",async function(){
//         let token = await data.tokenPrice()
//         expect(token).to.equal(7642621707402130);
//     })
//     it("should return false in sale active",async function(){
//         expect(await data.isSaleActive()).to.equal(false);
//     })
//     it("should revert when not start sale",async function(){
//        await expect(data.buy(1,{value:7642621707402130})).to.revertedWith('Sale not active')
//     })
//     it("should start sale correctly",async function(){
//         await data.startSale();
//         expect(await data.isSaleActive()).to.equal(true);
//     })
//     it("should buy one token",async function(){
//         await data.startSale();
//        // const val=BigNumber.from(ethers.utils.formatEther('7642621707402130'))
//         await data.connect(add1).buy(1,{value:7642621707402130})
//         let bal=await data1.balanceOf(add1.address)
//         expect(bal).to.equal(1);
//     })
//     it('should fetch eth bal of address',async function(){
//         await data.startSale();
//         await data.connect(add1).buy(1,{value:7642621707402130})
//       let bal= await data.weiRaised();
//       expect(bal).to.equal(7642621707402130)
//     })
//     it('should claim balance',async function(){
//         let bal= (await (ethers.provider.getBalance(owner.address))).toString()
//         await data.startSale();
//         await data.connect(add1).buy(1,{value:7642621707402130})
//         await data.claimWei()
//         let newbal= await ethers.provider.getBalance(owner.address)
//         let Bal=Number(newbal)-Number(bal)
//         expect(Bal).to.lessThanOrEqual(7642621707402130)

//     })
// })
