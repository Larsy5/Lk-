// 我们可以通过 npx hardhat run <script> 来运行想要的脚本
// 这里你可以使用 npx hardhat run deploy.js 来运行
const hre = require("hardhat");

async function main() {
  const Contract = await hre.ethers.getContractFactory("BitCat");
  const tokenOwnerAddress = "0x9bC8Ef2851a0e7248F6b603C212F280A5F341242"; // 确保这是一个有效的地址
//   try {
//     const token = await Contract.deploy(tokenOwnerAddress);
//     await token.deployed();
//     console.log("成功部署合约:", token.address);
// } catch (error) {
//     console.error("部署合约时发生错误:", error);
// }

  const token = await Contract.deploy(tokenOwnerAddress); // 只传递一个参数

  await token.waitForDeployment();
      // 监听事件
  console.log("成功部署合约:", token.target);
}

// 运行脚本
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
