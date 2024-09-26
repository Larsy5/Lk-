/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
// 申请etherscan的api key
const ETHERSCAN_API_KEY = "ZEE726QE19R7FNYAJ75YYMYM935A4Y54T8";

// 申请alchemy的api key
const ALCHEMY_API_KEY = "https://bsc-testnet.infura.io/v3/aebe320661154a789c1eab4c9e6ea0ba";

//将此私钥替换为测试账号私钥
//从Metamask导出您的私钥，打开Metamask和进入“帐户详细信息”>导出私钥
//注意:永远不要把真正的以太放入测试帐户
const GOERLI_PRIVATE_KEY = "c1de65b4c6f0b8620919638390e465da25bdeccbf2fcabc0153c4b9021d983d6";
module.exports = {
  solidity: "0.8.27",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  }
};
