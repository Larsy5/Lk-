/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
// 申请etherscan的api key
const ETHERSCAN_API_KEY = "ZEE726QE19R7FNYAJ75YYMYM935A4Y54T8";

// 申请alchemy的api key
const ALCHEMY_API_KEY = "https://bsc-testnet.infura.io/v3/aebe320661154a789c1eab4c9e6ea0ba";

//将此私钥替换为测试账号私钥
//从Metamask导出您的私钥，打开Metamask和进入“帐户详细信息”>导出私钥
//注意:永远不要把真正的以太放入测试帐户
const bsc_testnet_PRIVATE_KEY = "c1de65b4c6f0b8620919638390e465da25bdeccbf2fcabc0153c4b9021d983d6";
module.exports = {
  solidity: "0.8.27",
  networks: {
    bsc_testnet: {
      // url: 'https://bsc-testnet.infura.io/v3/aebe320661154a789c1eab4c9e6ea0ba',
      // url: `https://bsc-testnet-rpc.publicnode.com`,
      url: 'https://tiniest-fabled-valley.bsc-testnet.quiknode.pro/e2e51c7a22c2f8d3109d37e29d0e02bb4c707e0c',
      // url: 'https://data-seed-prebsc-2-s1.binance.org:8545',
      // url:'https://data-seed-prebsc-1-s2.binance.org:8545',
      // url:'https://data-seed-prebsc-2-s2.binance.org:8545',
      accounts: [bsc_testnet_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  }
};
