require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
const INFURA_API_KEY = "ab145ac4d90b4df2b5970a21a4b63da7";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const ROPSTEN_PRIVATE_KEY = "83e2a2a92cf8b81f68dd13aa795b1be2cff51c2a444bdc63d84026736a821f60";

module.exports = {
  solidity: "0.6.12",
  networks: {
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [ROPSTEN_PRIVATE_KEY]
    }
  }
};
