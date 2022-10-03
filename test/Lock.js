// const {expect}= require("chai");
// const {ethers}= require("hardhat");
// const BigNumber = require('bignumber.js');
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


//         const preicoadd= preico.address;
//         console.log(`deployed to ${preicoadd}`);
        
//         // const ICO= await ethers.getContractFactory("ICO");
//         // const ico= await ICO.deploy(tokenadd,owner.address)
//         // await ico.deployed()
//         // console.log(`deployed to ${ico.address}`);

//         const CS= await ethers.getContractFactory("Distribute");
//         const cs= await CS.deploy(144,owner.address,erc20.address)
//         await cs.deployed()
//         data=cs;
//         console.log(`deployed to ${cs.address}`);
//         await data.connect(owner).finalize();
        

      
//     })
//     describe("Private Sale",async function(){
//         it("should fetch the tokens ",async function(){
//             let token= await data.PrivateToken();
//             data1.approve(preico.address,token);
//             let approval= await data1.allowance(owner.address,preico.address);
//             expect(approval).to.equal(token);
//         })
//         it("should buy tokens",async function(){
//             let token= await data.PrivateToken();
//             data1.approve(preico.address,token);
//             await preico.startSale();
//             const buy= await preico.connect(add2).buy({value:1440})
//             let bal = await data1.balanceOf(add2.address)
//             expect(bal).to.equal(207360)
//         })
//     })
//     // it("will fetch private saletoken",async function(){
//     //     await data.connect(owner).finalize();
//     //     const bal= await new data1.balanceOf(preico.address);
//     //     expect(bal).to.equal(9)
//     // })

// //     it("should lock tokens and release after sometime and retrive balance",async function(){
       
// //        const add3= await data.PublicTimelock();
// //        await data.release(add3,1);
// //        const bal= await new data1.balanceOf(owner.address);
// //        expect(bal).to.equal(250)

// // })
// })