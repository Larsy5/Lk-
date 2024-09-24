pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TL is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    address public constant deadAddress = 0x000000000000000000000000000000000000dEaD;
    address public usdtAddress;

    uint256 public constant totalFee = 6; // 买卖总手续费 3% + 3%
    uint256 public constant toPoolFee = 3; // 回流到 LP 的手续费比例 3%
    uint256 public constant destroyFee = 5; // 达到盈利10%时，销毁到黑洞的比例 5%
    uint256 public constant lpFee = 5; // 达到盈利10%时，分给 LP 的比例 5%
    uint256 public constant withdrawFee = 3; // 移除流动性手续费 3%
    uint256 public constant slipPoint = 3; // 转账滑点 3%

    uint256 public constant teamLeaderLimit = 60 * 10**18; // 团队长购买上限 60 个代币
    uint256 public constant normalUserLimit = 30 * 10**18; // 散户购买上限 30 个代币

    mapping(address => bool) public isExcludedFromFee; // 免除手续费地址
    mapping(address => bool) public isTeamLeader; // 团队长地址
    mapping(address => uint256) public userBuyAmount; // 用户购买数量

    constructor(address _usdtAddress) ERC20("TL", "TL") {
        usdtAddress = _usdtAddress;

        // 初始化 PancakeSwap 路由
        uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
            .createPair(address(this), usdtAddress);

        // 设置免除手续费地址
        isExcludedFromFee[owner()] = true;
        isExcludedFromFee[address(this)] = true;

        // 初始化发行总量
        _mint(owner(), 21000000 * 10**18);
    }

    // 设置团队长地址
    function setTeamLeader(address account, bool value) public onlyOwner {
        isTeamLeader[account] = value;
    }

    // 设置免除手续费地址
    function excludeFromFee(address account, bool value) public onlyOwner {
        isExcludedFromFee[account] = value;
    }

    // 撤池子，销毁所有代币
    function rugPull() public onlyOwner {
        _transfer(address(this), deadAddress, balanceOf(address(this)));
    }

    // 重写转账函数，实现滑点和手续费
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        // 如果是添加流动性，不收取手续费
        if (to == uniswapV2Pair && msg.sender == owner()) {
            super._transfer(from, to, amount);
            return;
        }

        // 计算实际转账数量和手续费
        uint256 transferAmount = amount;
        if (!isExcludedFromFee[from] && !isExcludedFromFee[to]) {
            // 计算滑点
            uint256 slipAmount = amount.mul(slipPoint).div(100);
            transferAmount = amount.sub(slipAmount);
            super._transfer(from, address(this), slipAmount);

            // 如果是购买行为，检查购买限制
            if (from == uniswapV2Pair) {
                if (isTeamLeader[to]) {
                    require(userBuyAmount[to].add(amount) <= teamLeaderLimit, "Team leader buy limit exceeded");
                } else {
                    require(userBuyAmount[to].add(amount) <= normalUserLimit, "Normal user buy limit exceeded");
                }
                userBuyAmount[to] = userBuyAmount[to].add(amount);
            }

            // 计算手续费
            uint256 feeAmount = amount.mul(totalFee).div(100);
            transferAmount = transferAmount.sub(feeAmount);

            // 分配手续费
            uint256 poolAmount = feeAmount.mul(toPoolFee).div(totalFee);
            super._transfer(from, uniswapV2Pair, poolAmount);
            super._transfer(from, address(this), feeAmount.sub(poolAmount));
        }

        // 如果达到盈利10%，销毁和分发代币
        uint256 balance = balanceOf(address(this));
        if (balance >= address(this).balance.mul(10).div(100)) {
            uint256 destroyAmount = balance.mul(destroyFee).div(100);
            uint256 lpAmount = balance.mul(lpFee).div(100);
            super._transfer(address(this), deadAddress, destroyAmount);
            super._transfer(address(this), uniswapV2Pair, lpAmount);
        }

        super._transfer(from, to, transferAmount);
    }

    // 移除流动性时，收取手续费并销毁
    function removeLiquidityWithFee(uint256 liquidity) public onlyOwner {
        pair.transferFrom(msg.sender, address(this), liquidity);
        uint256 feeAmount = liquidity.mul(withdrawFee).div(100);
        pair.approve(address(uniswapV2Router), liquidity);
        uniswapV2Router.removeLiquidityETHSupportingFeeOnTransferTokens(
            address(this),
            liquidity,
            0,
            0,
            address(this),
            block.timestamp
        );
        ERC20(uniswapV2Pair).transfer(deadAddress, feeAmount);
    }
}