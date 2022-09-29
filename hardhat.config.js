//require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

/** @type import('hardhat/config').HardhatUserConfig */
const INFURA_API_KEY = "ab145ac4d90b4df2b5970a21a4b63da7";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const AVAX_PRIVATE_KEY = "83e2a2a92cf8b81f68dd13aa795b1be2cff51c2a444bdc63d84026736a821f60";

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.6.12",
      },
      {
        version: "0.8.14",
        settings: {},
      },
    ],
  },

  networks: {
  //   avalancheTest: {
  //   url: `https://avalanche-fuji.infura.io/v3/${INFURA_API_KEY}`,
  //   gasPrice: 225000000000,
  //   chainId: 43113,
  //   accounts: [AVAX_PRIVATE_KEY]
  // },
    goerli: {
      url:  `https://goerli.infura.io/v3/${INFURA_API_KEY}`,
      //gasPrice: 225000000000,
      accounts: [AVAX_PRIVATE_KEY]
    }
    
  
    },
    etherscan: {
      apiKey: {
        goerli: 'HZ8X2WD392APJACN5WE5XX3YV7SZCXEQU4'
    //avax TENTZEIRN4STUCUHB9R5NTGQ1R94E41PYI
      }
    }
  }
    // ropsten: {
    //   url: `https://avalanche-fuji.infura.io/v3/${INFURA_API_KEY}`,
    //   accounts: [ROPSTEN_PRIVATE_KEY]
    // }
  
 

  // fuji: {
  //   url: `https://avalanche-fuji.infura.io/v3/${INFURA_API_KEY}`,
  //   gasPrice: 225000000000,
  //   chainId: 43113,
  //   accounts: [ROPSTEN_PRIVATE_KEY]
  // },

