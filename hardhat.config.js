//require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");

/** @type import('hardhat/config').HardhatUserConfig */
const INFURA_API_KEY = "54c9d0915d4f4beda78f184e994da9c4";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const ROPSTEN_PRIVATE_KEY = "83e2a2a92cf8b81f68dd13aa795b1be2cff51c2a444bdc63d84026736a821f60";

module.exports = {
  solidity: "0.6.12",
  networks: {
    avalancheTest: {
      url:  `https://avalanche-fuji.infura.io/v3/${INFURA_API_KEY}`,
      gasPrice: 225000000000,
      chainId: 43113,
      accounts: [ROPSTEN_PRIVATE_KEY]
    }
  
    }
    // ropsten: {
    //   url: `https://avalanche-fuji.infura.io/v3/${INFURA_API_KEY}`,
    //   accounts: [ROPSTEN_PRIVATE_KEY]
    // }
  }
 

  // fuji: {
  //   url: `https://avalanche-fuji.infura.io/v3/${INFURA_API_KEY}`,
  //   gasPrice: 225000000000,
  //   chainId: 43113,
  //   accounts: [ROPSTEN_PRIVATE_KEY]
  // },

