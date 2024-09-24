// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
}

contract TLToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 21000000 * 10 ** 18;
    address public usdtAddress;
    IUniswapV2Router public uniswapRouter;
    address public uniswapPair;

    constructor(address _usdtAddress, address _uniswapRouter) ERC20("TL Token", "TL") {
        usdtAddress = _usdtAddress;
        uniswapRouter = IUniswapV2Router(_uniswapRouter);

        // 创建交易对
        IUniswapV2Factory uniswapFactory = IUniswapV2Factory(uniswapRouter.factory());
        uniswapPair = uniswapFactory.createPair(address(this), usdtAddress);

        // 铸造代币
        _mint(msg.sender, MAX_SUPPLY);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 fee = amount * 3 / 100; // 3%手续费
        uint256 amountAfterFee = amount - fee;

        super._transfer(sender, recipient, amountAfterFee);
        
        // 将手续费直接回流到底池
        swapFeeToPool(fee);
    }

    function swapFeeToPool(uint256 feeAmount) private {
        // 授权Uniswap Router使用TL
        _approve(address(this), address(uniswapRouter), feeAmount);

        // 进行交换
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdtAddress;

        // 交换TL代币为USDT
        uniswapRouter.swapExactTokensForTokens(
            feeAmount,
            0, // 设置滑点
            path,
            address(this), // 将USDT发送到合约
            block.timestamp
        );

        // 获取合约中的USDT余额
        uint256 usdtAmount = IERC20(usdtAddress).balanceOf(address(this));
        
        // 授权Uniswap Router使用USDT
        _approve(address(this), address(uniswapRouter), usdtAmount);

        // 添加流动性
        uniswapRouter.addLiquidity(
            address(this),
            usdtAddress,
            feeAmount,
            usdtAmount,
            0,
            0,
            owner(), // 将流动性代币(LP Token)发送给合约所有者
            block.timestamp
        );
    }
}