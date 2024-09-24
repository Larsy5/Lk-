contract BitCat is ERC20 {
    using SafeMath for uint256; // 使用 SafeMath 进行安全的算术运算
    IUniswapV2Router02 uniswapV2Router; // Uniswap V2 路由接口
    address _tokenOwner; // 代币拥有者地址
    IERC20 USDT; // USDT 代币接口
    IUniswapV2Pair pair; // Uniswap 交易对
    IUniswapV2Pair nft; // NFT 交易对接口
    Pool public highFeePool; // 高费用池，用于奖励
    UsdtReward public reward; // USDT 奖励分配合约
    bool private swapping; // 交换状态标志
    address public uniswapV2Pair; // Uniswap 交易对地址

    address _destroyAddress = address(0x000000000000000000000000000000000000dEaD); // 销毁地址
    address _cakeRouter = address(0x10ED43C718714eb63d5aA57B78B54704E256024E); // PancakeSwap 路由地址
    address _baseToken = address(0x55d398326f99059fF775485246999027B3197955); // USDT 代币地址

    address _fundAddress = address(0xCBF305DBcC7371015Cd0Eb0d7E8Da590F2472225); // 基金地址

    mapping(address => bool) public _isExcludedFromFees; // 映射，检查地址是否免除费用
    mapping(address => bool) private _isExcludedFromFeesVip; // VIP 免除费用映射
    mapping(address => bool) public _isPairs; // 映射，识别交易对
    bool public swapAndLiquifyEnabled = true; // 启用/禁用交换和流动性
    uint256 public startTime; // 合约活动开始时间
    uint256 total; // 代币总供应量

    constructor(address tokenOwner) ERC20("BitCat", "BitCat") { // 构造函数，初始化合约
        require(_baseToken < address(this), "BitCat small"); // 确保基础代币地址有效
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_cakeRouter); // 实例化路由
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _baseToken); // 创建 Uniswap 交易对
        _approve(address(this), address(_cakeRouter), 10**64); // 授权路由使用代币
        _approve(tokenOwner, address(_cakeRouter), 10**64); // 授权代币拥有者使用代币
        USDT = IERC20(_baseToken); // 实例化 USDT 代币
        USDT.approve(address(_cakeRouter), 10**64); // 授权 USDT 给路由
        pair = IUniswapV2Pair(_uniswapV2Pair); // 设置交易对
        nft = IUniswapV2Pair(0xde22c1998362a1018d7Db2c32F4E6647dDeAbAe9); // 设置 NFT 交易对
        highFeePool = new Pool(_uniswapV2Pair); // 初始化高费用池
        reward = new UsdtReward(_baseToken); // 初始化奖励合约
        uniswapV2Router = _uniswapV2Router; // 设置路由
        uniswapV2Pair = _uniswapV2Pair; // 设置交易对地址
        _tokenOwner = tokenOwner; // 设置代币拥有者
        _isPairs[_uniswapV2Pair] = true; // 标记交易对为有效
        _isExcludedFromFeesVip[address(this)] = true; // 免除合约地址费用
        _isExcludedFromFeesVip[_owner] = true; // 免除拥有者费用
        _isExcludedFromFeesVip[tokenOwner] = true; // 免除代币拥有者费用

        _contractSender = _owner; // 设置合约发送者
        total = 3000 * 10**26; // 设置代币总供应量

        _mint(tokenOwner, total); // 给拥有者铸造代币
        startTime = total; // 初始化开始时间

        ldxUser.push(tokenOwner); // 将代币拥有者添加到用户列表
        haveLdxpush[tokenOwner] = true; // 标记拥有者拥有 LDX
    }

    receive() external payable { } // 接收 ETH 的函数

    function balanceOf(address account) public override view returns(uint256) { // 重写 balanceOf 函数
        if(account == uniswapV2Pair) { // 如果查询的是交易对地址
            uint256 amount = super.balanceOf(account); // 获取余额
            require(amount > 0); // 确保余额为正
            return amount; // 返回余额
        }
        return super.balanceOf(account); // 返回普通余额
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner { // 免除地址费用
        _isExcludedFromFees[account] = excluded; // 更新映射
    }

    function setExcludedFromFeesVip(address pairaddress, bool value) public onlyOwner { // 设置 VIP 免除费用
        _isExcludedFromFeesVip[pairaddress] = value; // 更新映射
    }

    function excludeFromFeesUsers(address[] memory accounts, bool excluded) public onlyOwner { // 免除多个地址费用
        for(uint256 i = 0; i < accounts.length; i++) { // 遍历地址
            _isExcludedFromFees[accounts[i]] = excluded; // 更新映射
        }
    }

    function addOtherPair(address pairaddress, bool value) public onlyOwner { // 添加其他交易对
        _isPairs[pairaddress] = value; // 更新映射
    }

    function changeNft(IUniswapV2Pair _nft) public onlyOwner { // 更改 NFT 交易对
        nft = _nft; // 更新 NFT 交易对
    }

    function setStartTime(uint256 _startTime) public onlyOwner { // 设置开始时间
        startTime = _startTime; // 更新开始时间
    }

    mapping(address => uint256) public _userBuyUsdtAmount; // 映射，跟踪用户购买的 USDT 数量
    function initUserOutAmount(address user, uint256 outAmount) internal returns(uint256) { // 初始化用户输出金额
        uint256 buyUsdtAmount = _userBuyUsdtAmount[user]; // 获取用户 USDT 数量
        if(buyUsdtAmount < 1) { // 如果没有购买 USDT
            super._transfer(user, address(this), outAmount.div(10)); // 转移 10% 到合约
            return outAmount.div(10).mul(9); // 返回 90% 的输出金额
        }
        (uint256 reserveU, uint256 reserveT, ) = pair.getReserves(); // 获取交易对的储备
        uint256 userCanOutAmount = uniswapV2Router.getAmountIn(buyUsdtAmount, reserveT, reserveU); // 计算用户可以提取的金额
        if(userCanOutAmount < outAmount) { // 如果用户无法提取请求的金额
            uint256 earnAmount = outAmount.sub(userCanOutAmount); // 计算超出部分
            uint256 deduct = earnAmount.div(100).mul(10); // 计算扣除金额
            super._transfer(user, address(this), deduct); // 转移扣除金额到合约
            return outAmount.sub(deduct); // 返回调整后的输出金额
        }
        return outAmount; // 返回原始输出金额
    }

    function updateUserBuyUsdtAmount(address user, uint256 amount) internal { // 更新用户购买的 USDT 数量
        (uint256 reserveU, uint256 reserveT, ) = pair.getReserves(); // 获取储备
        uint256 userSellUsdtAmount = uniswapV2Router.getAmountOut(amount, reserveT, reserveU); // 计算卖出代币后的 USDT
        if(_userBuyUsdtAmount[user] > userSellUsdtAmount) { // 如果用户购买的 USDT 大于卖出
            _userBuyUsdtAmount[user] = _userBuyUsdtAmount[user].sub(userSellUsdtAmount); // 扣除卖出金额
        } else {
            _userBuyUsdtAmount[user] = 0; // 重置用户 USDT 数量
        }
    }

    function checkDeadUser(address user, uint256 amount) private { // 检查用户是否符合 NFT 条件
        if(amount >= 100 * 10**24) { // 如果金额 >= 100
            pushNftUser(user, 4); // 推送用户至等级 4 NFT
            nft.mintAdminWithTokenURI3(user); // 为用户铸造 NFT
            return;
        }
        if(amount >= 50 * 10**24) { // 如果金额 >= 50
            pushNftUser(user, 3); // 推送用户至等级 3 NFT
            nft.mintAdminWithTokenURI2(user); // 为用户铸造 NFT
            return;
        }
        if(amount >= 20 * 10**24) { // 如果金额 >= 20
            pushNftUser(user, 2); // 推送用户至等级 2 NFT
            nft.mintAdminWithTokenURI1(user); // 为用户铸造 NFT
            return;
        }
        if(amount >= 10 * 10**24) { // 如果金额 >= 10
            pushNftUser(user, 1); // 推送用户至等级 1 NFT
            nft.mintAdminWithTokenURI0(user); // 为用户铸造 NFT
            return;
        }
    }

    function _transfer(address from, address to, uint256 amount) internal virtual override { // 重写 _transfer 函数
        if(from == uniswapV2Pair) { // 如果是从交易对转账
            _userBuyUsdtAmount[to] = _userBuyUsdtAmount[to].add(amount); // 更新用户的 USDT 数量
        }
        if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) { // 如果转账双方都未免除费用
            uint256 feeAmount = amount.div(100).mul(5); // 计算 5% 的费用
            super._transfer(from, address(this), feeAmount); // 将费用转账到合约
            amount = amount.sub(feeAmount); // 从转账金额中扣除费用
        }
        super._transfer(from, to, amount); // 执行标准转账
    }
}
