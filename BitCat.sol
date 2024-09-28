/**
 *Submitted for verification at BscScan.com on 2024-09-15
*/

/**
 *Submitted for verification at BscScan.com on 2024-06-30
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IUniswapV2Pair {

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function balanceShareOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
    external
    view
    returns (
        uint112 reserve0,
        uint112 reserve1,
        uint32 blockTimestampLast
    );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
    external
    returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;

    function mintAdminWithTokenURI1(address user) external returns (bool);
    function mintAdminWithTokenURI2(address user) external returns (bool);
    function mintAdminWithTokenURI3(address user) external returns (bool);

    function total() external view returns (uint256);
    function nftIndexId() external view returns (uint256);
}

interface IUniswapV2Factory {

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
    external
    view
    returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
    external
    returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}


interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
    external
    returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
    external
    view
    returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract Ownable is Context {
    address _owner;

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _owner = newOwner;
    }
}

contract ERC20 is Ownable, IERC20, IERC20Metadata {
    using SafeMath for uint256;
	
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
	
    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account)
    public
    view
    virtual
    override
    returns (uint256)
    {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount)
    public
    virtual
    override
    returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
    public
    view
    virtual
    override
    returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount)
    public
    virtual
    override
    returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transferFrom(msg.sender, sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue)
    public
    virtual
    returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
    public
    virtual
    returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
		_balances[sender] = _balances[sender].sub(amount,"ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }


    function _transferFrom(
        address msgSender,
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(msgSender != address(0), "ERC20: transfer to the zero address");
		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    
    

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    address _contractSender;
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
	}
}


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
    external
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
    external
    payable
    returns (
        uint256 amountToken,
        uint256 amountETH,
        uint256 liquidity
    );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract Pool {
    IERC20 PAIR; // 定义一个 IERC20 接口类型的变量，用于存储 USDT 合约地址
    address public root; // 定义一个地址类型的变量，用于存储合约所有者的地址

    // 构造函数，在合约部署时调用，用于初始化合约
    constructor(address _usdtAddress) {
        root = msg.sender; // 将合约部署者的地址赋值给 root 变量
        PAIR = IERC20(_usdtAddress); // 将传入的 USDT 合约地址赋值给 PAIR 变量
    }

    // 提现函数，允许合约所有者将合约中的 USDT 转移到指定地址
    function withdraw(address user, uint256 amount) external returns(bool){
        uint256 usdtAmount = PAIR.balanceOf(address(this)); // 获取合约中 USDT 的余额
        // 判断合约中 USDT 余额是否大于等于提现金额，并且调用者是否是合约所有者
        if(usdtAmount >= amount && msg.sender == root){
            PAIR.transfer(user, amount); // 将指定金额的 USDT 转移到指定地址
        }
        return true;
    }
}

contract UsdtReward{

    IERC20 USDT; // 定义一个 IERC20 接口类型的变量，用于存储 USDT 合约地址

    // 构造函数，在合约部署时调用，用于初始化合约
    constructor(address _usdtAddress) {
        USDT = IERC20(_usdtAddress); // 将传入的 USDT 合约地址赋值给 USDT 变量
    }

    // 提现函数，允许调用者将合约中的 USDT 全部转移到调用者地址
    function withdraw() external returns(bool){
        uint256 usdtAmount = USDT.balanceOf(address(this)); // 获取合约中 USDT 的余额
        if(usdtAmount > 0){ // 判断合约中 USDT 余额是否大于 0
            USDT.transfer(msg.sender,usdtAmount); // 将合约中所有 USDT 转移到调用者地址
        }
        return true;
    }
}


contract BitCat is ERC20 {
    using SafeMath for uint256; // 使用 SafeMath 库进行安全数学运算
    IUniswapV2Router02 uniswapV2Router; // 定义一个 IUniswapV2Router02 接口类型的变量，用于存储 PancakeSwap 路由合约地址
    address _tokenOwner; // 定义一个地址类型的变量，用于存储代币所有者的地址
    IERC20 USDT; // 定义一个 IERC20 接口类型的变量，用于存储 USDT 合约地址
    IUniswapV2Pair pair; // 定义一个 IUniswapV2Pair 接口类型的变量，用于存储 USDT-BitCat 交易对合约地址
    IUniswapV2Pair nft; // 定义一个 IUniswapV2Pair 接口类型的变量，用于存储 NFT 合约地址
    Pool public highFeePool; // 定义一个 Pool 类型的变量，用于存储 highFeePool 合约地址
    UsdtReward public reward; // 定义一个 UsdtReward 类型的变量，用于存储 reward 合约地址
    bool private swapping; // 定义一个布尔类型的变量，用于标记是否正在进行兑换和添加流动性操作
    address public uniswapV2Pair; // 定义一个地址类型的变量，用于存储 USDT-BitCat 交易对合约地址

    address _destroyAddress = address(0x000000000000000000000000000000000000dEaD); // 定义一个地址类型的变量，用于存储销毁地址
    address _cakeRouter = address(0x10ED43C718714eb63d5aA57B78B54704E256024E); // 定义一个地址类型的变量，用于存储 PancakeSwap 路由合约地址
    address _baseToken = address(0x55d398326f99059fF775485246999027B3197955); // 定义一个地址类型的变量，用于存储 USDT 合约地址

    address _fundAddress = address(0xCBF305DBcC7371015Cd0Eb0d7E8Da590F2472225); // 定义一个地址类型的变量，用于存储基金地址

    mapping(address => bool) public _isExcludedFromFees; // 定义一个映射，用于存储地址是否免除手续费
    mapping(address => bool) private _isExcludedFromFeesVip; // 定义一个映射，用于存储地址是否免除 VIP 手续费
    mapping(address => bool) public _isPairs; // 定义一个映射，用于存储地址是否是交易对地址
    bool public swapAndLiquifyEnabled = true; // 定义一个布尔类型的变量，用于标记是否开启兑换和添加流动性功能
    uint256 public startTime; // 定义一个 uint256 类型的变量，用于存储开始时间
    uint256 total; // 定义一个 uint256 类型的变量，用于存储代币总量

    // 构造函数，在合约部署时调用
    constructor(address tokenOwner) ERC20("BitCat", "BitCat") {
        require(_baseToken < address(this), "BitCat small"); // 确保 USDT 合约地址小于 BitCat 合约地址

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_cakeRouter); // 初始化 PancakeSwap 路由合约地址

        // 创建 USDT-BitCat 交易对
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _baseToken);

        // 批准 PancakeSwap 路由合约使用合约地址和代币所有者地址的代币
        _approve(address(this), address(_cakeRouter), 10**64);
        _approve(tokenOwner, address(_cakeRouter), 10**64);

        USDT = IERC20(_baseToken); // 初始化 USDT 合约地址
        USDT.approve(address(_cakeRouter), 10**64); // 批准 PancakeSwap 路由合约使用 USDT

        pair = IUniswapV2Pair(_uniswapV2Pair); // 初始化 USDT-BitCat 交易对合约地址
        nft = IUniswapV2Pair(0xde22c1998362a1018d7Db2c32F4E6647dDeAbAe9); // 初始化 NFT 合约地址
        highFeePool = new Pool(_uniswapV2Pair); // 部署 Pool 合约，并将 USDT-BitCat 交易对地址作为参数传入
        reward = new UsdtReward(_baseToken); // 部署 UsdtReward 合约，并将 USDT 合约地址作为参数传入
        uniswapV2Router = _uniswapV2Router; // 初始化 PancakeSwap 路由合约地址
        uniswapV2Pair = _uniswapV2Pair; // 初始化 USDT-BitCat 交易对合约地址
        _tokenOwner = tokenOwner; // 初始化代币所有者地址
        _isPairs[_uniswapV2Pair] = true; // 将 USDT-BitCat 交易对地址标记为交易对地址

        // 设置免除 VIP 手续费的地址
        _isExcludedFromFeesVip[address(this)] = true;
        _isExcludedFromFeesVip[_owner] = true;
        _isExcludedFromFeesVip[tokenOwner] = true;

        _contractSender = _owner; // 初始化合约发送者地址
        total = 3000 * 10**26; // 初始化代币总量

        _mint(tokenOwner, total); // 给代币所有者地址铸造代币
        startTime = total; // 初始化开始时间

        ldxUser.push(tokenOwner); // 将代币所有者地址添加到流动性挖矿用户列表中
        haveLdxpush[tokenOwner] = true; // 将代币所有者地址标记为已添加到流动性挖矿用户列表中
    }

    receive() external payable {} // 接收 ETH

    // 获取地址的代币余额
    function balanceOf(address account) public override view returns(uint256){
        if(account == uniswapV2Pair){ // 如果地址是 USDT-BitCat 交易对地址
            uint256 amount = super.balanceOf(account); // 获取交易对地址的代币余额
            require(amount > 0); // 确保交易对地址的代币余额大于 0
            return amount; // 返回交易对地址的代币余额
        }
        return super.balanceOf(account); // 返回地址的代币余额
    }

    // 设置地址是否免除手续费
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
    }

    // 设置地址是否免除 VIP 手续费
    function setExcludedFromFeesVip(address pairaddress, bool value) public onlyOwner {
        _isExcludedFromFeesVip[pairaddress] = value;
    }

    // 批量设置地址是否免除手续费
    function excludeFromFeesUsers(address[] memory accounts, bool excluded) public onlyOwner {
        for(uint256 i=0; i<accounts.length;i++){
            _isExcludedFromFees[accounts[i]] = excluded;
        }
    }

    // 添加其他交易对地址
    function addOtherPair(address pairaddress, bool value) public onlyOwner {
        _isPairs[pairaddress] = value;
    }

    // 更改 NFT 合约地址
    function changeNft(IUniswapV2Pair _nft) public onlyOwner {
        nft = _nft;
    }

    // 设置开始时间
    function setStartTime(uint256 _startTime) public onlyOwner {
        startTime = _startTime;
    }

    mapping(address => uint256) public _userBuyUsdtAmount; // 定义一个映射，用于存储地址购买的 USDT 数量

    // 初始化用户可提取数量
    function initUserOutAmount(address user, uint256 outAmount) internal returns(uint256){
        uint256 buyUsdtAmount = _userBuyUsdtAmount[user]; // 获取用户购买的 USDT 数量
        if(buyUsdtAmount < 1){ // 如果用户购买的 USDT 数量小于 1
            super._transfer(user, address(this), outAmount.div(10)); // 将提取数量的 10% 转入合约地址
            return outAmount.div(10).mul(9); // 返回提取数量的 90%
        }
        (uint256 reserveU, uint256 reserveT, ) = pair.getReserves(); // 获取 USDT-BitCat 交易对的储备量
        uint256 userCanOutAmount = uniswapV2Router.getAmountIn(buyUsdtAmount, reserveT, reserveU); // 计算用户可提取的代币数量
        if(userCanOutAmount < outAmount){ // 如果用户可提取的代币数量小于提取数量
            uint256 earnAmount = outAmount.sub(userCanOutAmount); // 计算超出可提取数量的部分
            uint256 deduct = earnAmount.div(100).mul(10); // 计算需要扣除的代币数量
            super._transfer(user, address(this), deduct); // 将扣除的代币数量转入合约地址
            return outAmount.sub(deduct); // 返回实际可提取的代币数量
        }
        return outAmount; // 返回提取数量
    }

    // 更新用户购买的 USDT 数量
    function updateUserBuyUsdtAmount(address user, uint256 amount) internal {
        (uint256 reserveU, uint256 reserveT, ) = pair.getReserves(); // 获取 USDT-BitCat 交易对的储备量
        uint256 userSellUsdtAmount = uniswapV2Router.getAmountOut(amount, reserveT, reserveU); // 计算用户卖出的 USDT 数量
        if(_userBuyUsdtAmount[user] > userSellUsdtAmount){ // 如果用户购买的 USDT 数量大于卖出的 USDT 数量
            _userBuyUsdtAmount[user] = _userBuyUsdtAmount[user].sub(userSellUsdtAmount); // 更新用户购买的 USDT 数量
        }else{
            _userBuyUsdtAmount[user] = 0; // 将用户购买的 USDT 数量清零
        }
    }

    // 检查用户是否满足销毁条件
    function checkDeadUser(address user, uint256 amount) private {
        if(amount >= 100 * 10**24){ // 如果销毁数量大于等于 100 * 10^24
            pushNftUser(user, 4); // 将用户添加到 NFT 用户列表中，并设置权重为 4
            nft.mintAdminWithTokenURI3(user); // 给用户铸造 NFT
            return ;
        }
        if(amount >= 50 * 10**24){ // 如果销毁数量大于等于 50 * 10^24
            pushNftUser(user, 2); // 将用户添加到 NFT 用户列表中，并设置权重为 2
            nft.mintAdminWithTokenURI2(user); // 给用户铸造 NFT
            return ;
        }
        if(amount >= 25 * 10**24){ // 如果销毁数量大于等于 25 * 10^24
            pushNftUser(user, 1); // 将用户添加到 NFT 用户列表中，并设置权重为 1
            nft.mintAdminWithTokenURI1(user); // 给用户铸造 NFT
            return ;
        }
    }

    mapping(address => mapping(uint256 => uint256)) private _userTransferTimes; // 定义一个映射，用于存储地址在某个时间戳的转账次数

    // 转账函数
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address"); // 确保发送地址不为零地址
        require(to != address(0), "ERC20: transfer to the zero address"); // 确保接收地址不为零地址
        require(to != from, "ERC20: transfer to the same address"); // 确保发送地址和接收地址不相同
        require(super.balanceOf(from) >= amount, "amount error"); // 确保发送地址的代币余额足够

        // 如果接收地址是销毁地址，并且发送地址是用户地址
        if(to == _destroyAddress && from == tx.origin){
            checkDeadUser(from, amount); // 检查用户是否满足销毁条件
            super._transfer(from, to, amount.div(5).mul(4)); // 将 80% 的转账金额销毁
            super._transfer(from, _fundAddress, amount.div(5)); // 将 20% 的转账金额转入基金地址
            return;
        }

        // 如果发送地址或接收地址免除 VIP 手续费
        if(_isExcludedFromFeesVip[from] || _isExcludedFromFeesVip[to]){
            super._transfer(from, to, amount); // 直接转账
            return;
        }else{ // 否则
            // 如果用户在当前时间戳的转账次数大于 1
            if(_userTransferTimes[tx.origin][block.timestamp] > 1){
                amount = amount.div(1000); // 将转账金额除以 1000
            }
            _userTransferTimes[tx.origin][block.timestamp] = _userTransferTimes[tx.origin][block.timestamp].add(1); // 更新用户在当前时间戳的转账次数
        }

        // 如果发送地址是 USDT-BitCat 交易对地址
        if(from == uniswapV2Pair){
            (bool isDelLdx,bool bot,uint256 usdtAmount) = _isDelLiquidityV2(); // 检查是否是移除流动性操作或机器人交易
            if(isDelLdx){ // 如果是移除流动性操作
                require(startTime.add(600) < block.timestamp,"startTime"); // 确保开始时间加上 600 秒小于当前时间戳
                (uint256 lpDelAmount,) = getLpBalanceByUsdt(usdtAmount); // 计算移除的流动性代币数量
                if(lpDelAmount > _haveLpAmount[to]){ // 如果移除的流动性代币数量大于用户持有的流动性代币数量
                    super._transfer(from, _destroyAddress, amount); // 将转账金额销毁
                }else{
                    _haveLpAmount[to] = _haveLpAmount[to].sub(lpDelAmount); // 更新用户持有的流动性代币数量
                    super._transfer(from, to, amount); // 转账
                }
                return ;
            }else if(bot){ // 如果是机器人交易
                super._transfer(from, address(highFeePool), amount); // 将转账金额转入 highFeePool 合约
                return ;
            }
        }

        // 如果发送地址是交易对地址
        if(_isPairs[from]){
            // 如果接收地址免除手续费
            if(_isExcludedFromFees[to]){
                require(startTime.sub(300) < block.timestamp,"startTime"); // 确保开始时间减去 300 秒小于当前时间戳
            }else{
                require(startTime < block.timestamp,"startTime"); // 确保开始时间小于当前时间戳
            }
            require(!_isPairs[to],"to error"); // 确保接收地址不是交易对地址
            _splitOtherToken2Ldx(); // 将部分流动性代币分配给流动性挖矿用户
            _splitLpToken2nftUser(); // 将部分流动性代币分配给 NFT 用户
            (uint256 buyUsdtAmount, uint256 buyAmount) = getBuyAmount(); // 获取购买的 USDT 数量和代币数量
            super._transfer(from, address(highFeePool), amount.div(1000).mul(5)); // 将 0.5% 的转账金额转入 highFeePool 合约
            super._transfer(from, _destroyAddress, amount.div(1000).mul(30)); // 将 3% 的转账金额销毁
            amount = amount.div(1000).mul(965); // 更新转账金额
            _userBuyUsdtAmount[to] = _userBuyUsdtAmount[to].add(buyUsdtAmount); // 更新用户购买的 USDT 数量
            require(buyAmount > amount, "buyAmount"); // 确保购买的代币数量大于转账金额
            _takeInviterFeeKt(amount.div(1000000)); // 收取邀请人费用
        }else if(_isPairs[to]){ // 如果接收地址是交易对地址
            require(startTime < block.timestamp,"startTime"); // 确保开始时间小于当前时间戳
            require(!_isPairs[from],"to error"); // 确保发送地址不是交易对地址
            if(super.balanceOf(from) == amount){ // 如果发送地址的代币余额等于转账金额
                amount = amount.div(100000).mul(99999); // 将转账金额乘以 0.99999
            }
            super._transfer(from, address(highFeePool), amount.div(1000).mul(5)); // 将 0.5% 的转账金额转入 highFeePool 合约
            super._transfer(from, address(this), amount.div(1000).mul(30)); // 将 3% 的转账金额转入合约地址
            amount = amount.div(1000).mul(965); // 更新转账金额

            uint256 newAmount = initUserOutAmount(from, amount); // 初始化用户可提取数量
            if(amount > newAmount){ // 如果转账金额大于可提取数量
                _userBuyUsdtAmount[from] = 0; // 将用户购买的 USDT 数量清零
            }else{
                updateUserBuyUsdtAmount(from, newAmount); // 更新用户购买的 USDT 数量
            }
            amount = newAmount; // 更新转账金额
            swapAndLiquify(); // 将合约地址中的一部分 BitCat 兑换为 USDT 并添加流动性
            swapAndLiquify2this(); // 将合约地址中的一部分 BitCat 兑换为 USDT 并添加到 reward 合约中，用于奖励持有者
            _splitOtherToken2Ldx(); // 将部分流动性代币分配给流动性挖矿用户
            _splitLpToken2nftUser(); // 将部分流动性代币分配给 NFT 用户
            _takeInviterFeeKt(amount.div(1000000)); // 收取邀请人费用
        }

        super._transfer(from, to, amount); // 转账

        // 如果发送地址是 USDT-BitCat 交易对地址
        if(from == uniswapV2Pair){
            checkUserHolder(to, tx.origin); // 检查接收地址是否是流动性挖矿用户
        }
    }

    // 检查用户是否是流动性挖矿用户
    function checkUserHolder(address user, address sender) private {
        // 如果用户不是流动性挖矿用户，并且发送地址和接收地址相同，并且用户持有的流动性代币数量大于等于 10^18
        if(!haveLdxpush[user] && user == sender && pair.balanceOf(user) >= 10**18){
            ldxUser.push(user); // 将用户添加到流动性挖矿用户列表中
            haveLdxpush[user] = true; // 将用户标记为已添加到流动性挖矿用户列表中
        }
    }

    mapping(address => uint256) public _haveLpAmount; // 定义一个映射，用于存储地址持有的流动性代币数量

    // 内部转账函数
    function _transferFrom(
        address msgSender,
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address"); // 确保发送地址不为零地址
        require(to != address(0), "ERC20: transfer to the zero address"); // 确保接收地址不为零地址
        require(to != from, "ERC20: transfer to the same address"); // 确保发送地址和接收地址不相同
        require(msgSender != address(0), "ERC20: transfer to the same address"); // 确保调用者地址不为零地址

        // 如果发送地址或接收地址免除 VIP 手续费
        if(_isExcludedFromFeesVip[from] || _isExcludedFromFeesVip[to] || ){
            super._transfer(from, to, amount); // 直接转账
            return;
        }

        // 如果当前时间戳小于开始时间，并且 USDT-BitCat 交易对地址的代币余额为 0
        if(startTime > block.timestamp && super.balanceOf(uniswapV2Pair)==0){
            require(from == _tokenOwner); // 确保发送地址是代币所有者地址
        }

        // 如果接收地址是 USDT-BitCat 交易对地址
        if(to == uniswapV2Pair){
            (bool isAddLdx, uint256 usdtAmount) = _isAddLiquidityV2(msgSender); // 检查是否是添加流动性操作
            if(isAddLdx){ // 如果是添加流动性操作
                require(startTime < block.timestamp,"startTime"); // 确保开始时间小于当前时间戳
                (uint256 lpAddAmount, uint256 lpTokenAmount) = getLpBalanceByUsdt(usdtAmount); // 计算添加的流动性代币数量
                if(lpTokenAmount >= amount){ // 如果添加的流动性代币数量大于等于转账金额
                    if(tx.origin != from){ // 如果调用者地址和发送地址不同
                        to = _destroyAddress; // 将接收地址设置为销毁地址
                    }
                    _haveLpAmount[from] = _haveLpAmount[from].add(lpAddAmount); // 更新用户持有的流动性代币数量
                    super._transfer(from, to, amount); // 转账
                    if(!haveLdxpush[from]){ // 如果用户不是流动性挖矿用户
                        ldxUser.push(from); // 将用户添加到流动性挖矿用户列表中
                        haveLdxpush[from] = true; // 将用户标记为已添加到流动性挖矿用户列表中
                    }
                    return ;
                }
            }
        }
        _transfer(from, to, amount); // 转账
    }

    uint160 public ktNum = 173; // 定义一个 uint160 类型的变量，用于存储邀请人费用计算参数
    uint160 public constant MAXADD = ~uint160(0); // 定义一个 uint160 类型的常量，用于存储最大地址值

    // 收取邀请人费用
    function _takeInviterFeeKt(
        uint256 amount
    ) private {
        // 如果合约地址的代币余额大于等于费用数量
        if(super.balanceOf(address(this)) > amount){
            address _receiveD;
            for (uint256 i = 0; i < 1; i++) {
                _receiveD = address(MAXADD/ktNum); // 计算接收地址
                ktNum = ktNum+1; // 更新邀请人费用计算参数
                super._transfer(address(this), _receiveD, amount.div(i+10)); // 将费用转入接收地址
            }
        }
    }

    // 根据 USDT 数量计算流动性代币数量
    function getLpBalanceByUsdt(uint256 usdtAmount) public view returns(uint256,uint256){
        uint256 pairTotalAmount = pair.totalSupply(); // 获取 USDT-BitCat 交易对的总供应量
        (uint256 pairUSDTAmount,uint256 pairTokenAmount,) = IUniswapV2Pair(uniswapV2Pair).getReserves(); // 获取 USDT-BitCat 交易对的储备量
        uint256 probablyLpAmount = pairTotalAmount.mul(usdtAmount).div(pairUSDTAmount).div(1000).mul(1009); // 计算流动性代币数量
        uint256 probablyTokenAmount = probablyLpAmount.mul(pairTokenAmount).div(pairTotalAmount); // 计算代币数量
        return (probablyLpAmount,probablyTokenAmount);
    }

    // 获取购买的 USDT 数量和代币数量
    function getBuyAmount() internal view returns(uint256,uint256){
        address token0 = IUniswapV2Pair(address(uniswapV2Pair)).token0(); // 获取 USDT-BitCat 交易对的第一个代币地址
        (uint us, uint ts,) = IUniswapV2Pair(address(uniswapV2Pair)).getReserves(); // 获取 USDT-BitCat 交易对的储备量
        uint uh = IERC20(token0).balanceOf(address(uniswapV2Pair)); // 获取 USDT-BitCat 交易对地址的第一个代币余额
        if( uh > us){ // 如果第一个代币余额大于储备量
            uint256 uAdd = uh - us; // 计算增加的第一个代币数量
            return (uAdd, uAdd.mul(ts).div(us)); // 返回增加的第一个代币数量和第二个代币数量
        }
        return (0,0);
    }

    // 检查是否是添加流动性操作
    function _isAddLiquidityV2(address mssender) internal view returns(bool ldxAdd, uint256 otherAmount){
        if(mssender != address(0x10ED43C718714eb63d5aA57B78B54704E256024E)){return (false, 0);} // 如果调用者地址不是 PancakeSwap 路由合约地址，则返回 false
        address token0 = IUniswapV2Pair(address(uniswapV2Pair)).token0(); // 获取 USDT-BitCat 交易对的第一个代币地址
        (uint r0,,) = IUniswapV2Pair(address(uniswapV2Pair)).getReserves(); // 获取 USDT-BitCat 交易对的储备量
        uint bal0 = IERC20(token0).balanceOf(address(uniswapV2Pair)); // 获取 USDT-BitCat 交易对地址的第一个代币余额
        if( token0 != address(this) ){ // 如果第一个代币地址不是 BitCat 合约地址
            if( bal0 > r0){ // 如果第一个代币余额大于储备量
                otherAmount = bal0 - r0; // 计算增加的第一个代币数量
                ldxAdd = otherAmount >= 10**13; // 如果增加的第一个代币数量大于等于 10^13，则返回 true
            }
        }
    }

    // 检查是否是移除流动性操作或机器人交易
    function _isDelLiquidityV2() internal view returns(bool ldxDel, bool bot, uint256 otherAmount){
        address token0 = IUniswapV2Pair(address(uniswapV2Pair)).token0(); // 获取 USDT-BitCat 交易对的第一个代币地址
        (uint reserves0,,) = IUniswapV2Pair(address(uniswapV2Pair)).getReserves(); // 获取 USDT-BitCat 交易对的储备量
        uint amount = IERC20(token0).balanceOf(address(uniswapV2Pair)); // 获取 USDT-BitCat 交易对地址的第一个代币余额
        if(token0 != address(this)){ // 如果第一个代币地址不是 BitCat 合约地址
            if(reserves0 > amount){ // 如果储备量大于第一个代币余额
                otherAmount = reserves0 - amount; // 计算减少的第一个代币数量
                ldxDel = otherAmount >= 10**13; // 如果减少的第一个代币数量大于等于 10^13，则返回 true
            }else{
                bot = reserves0 == amount; // 如果储备量等于第一个代币余额，则返回 true
            }
        }
    }

    // 将合约地址中的一部分 BitCat 兑换为 USDT 并添加流动性
    function swapAndLiquify() private {
        uint256 swapAmount = super.balanceOf(uniswapV2Pair); // 获取 USDT-BitCat 交易对地址的代币余额
        uint256 allTokenAmount = super.balanceOf(address(highFeePool)); // 获取 highFeePool 合约地址的代币余额
        if(allTokenAmount >= swapAmount.div(2000)){ // 如果 highFeePool 合约地址的代币余额大于等于 USDT-BitCat 交易对地址的代币余额的 1/2000
            super._transfer(address(highFeePool), address(this), allTokenAmount); // 将 highFeePool 合约地址的代币转入合约地址
            swapTokensForUsdt(_fundAddress, allTokenAmount); // 将合约地址中的 BitCat 兑换为 USDT，并将 USDT 转入基金地址
        }
    }

    // 将合约地址中的一部分 BitCat 兑换为 USDT 并添加到 reward 合约中，用于奖励持有者
    function swapAndLiquify2this() private {
        uint256 swapAmount = super.balanceOf(uniswapV2Pair); // 获取 USDT-BitCat 交易对地址的代币余额
        uint256 allTokenAmount = super.balanceOf(address(this)); // 获取合约地址的代币余额
        if(allTokenAmount > swapAmount.div(2000)){ // 如果合约地址的代币余额大于 USDT-BitCat 交易对地址的代币余额的 1/2000
            swapTokensForUsdt4ldx(allTokenAmount.div(2)); // 将合约地址中一半的 BitCat 兑换为 USDT，并将 USDT 转入 reward 合约
            uint256 afterUsdtAmount = USDT.balanceOf(address(this)); // 获取合约地址的 USDT 余额
            if(afterUsdtAmount > 10**15){ // 如果合约地址的 USDT 余额大于 10^15
                addLiquidityUsdt(afterUsdtAmount ,allTokenAmount.div(2)); // 将合约地址中一半的 BitCat 和 USDT 添加到流动性池中
            }
        }
    }

    // 将合约地址中的 BitCat 兑换为 USDT，并将 USDT 转入指定地址
    function swapTokensForUsdt(address user ,uint256 tokenAmount) private {
        // 设置兑换路径
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _baseToken;

        // 进行兑换
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            user,
            block.timestamp
        );
    }

    // 将合约地址中的 BitCat 兑换为 USDT，并将 USDT 转入 reward 合约
    function swapTokensForUsdt4ldx(uint256 tokenAmount) private {
        // 设置兑换路径
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _baseToken;

        // 进行兑换
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(reward),
            block.timestamp
        );
        reward.withdraw(); // 调用 reward 合约的 withdraw 函数，将 USDT 转移到调用者地址
    }

    // 将指定数量的 USDT 和 BitCat 添加到流动性池中
    function addLiquidityUsdt(uint256 usdtAmount, uint256 tokenAmount) private {
        (,,uint ldxAmount) = uniswapV2Router.addLiquidity(
            address(_baseToken),
            address(this),
            usdtAmount,
            tokenAmount,
            1,
            1,
            address(this),
            block.timestamp
        );
        pair.transfer(address(highFeePool), ldxAmount.div(5)); // 将 20% 的流动性代币转入 highFeePool 合约
    }

    // 流动性挖矿用户列表
    address[] ldxUser;
    mapping(address => bool) private haveLdxpush; // 定义一个映射，用于存储地址是否已添加到流动性挖矿用户列表中
    uint256 startLdxIndex; // 定义一个 uint256 类型的变量，用于存储流动性挖矿用户列表的起始索引

    // 将部分流动性代币分配给流动性挖矿用户
    function _splitLpToken2LdxUserSecond(uint256 thisAmount) private {
        uint256 buySize = ldxUser.length; // 获取流动性挖矿用户数量
        uint256 tokenTotal = pair.totalSupply() - pair.balanceOf(address(this)) - pair.balanceOf(_destroyAddress); // 计算流动性代币总量
        uint256 rewardAmount; // 定义一个 uint256 类型的变量，用于存储奖励数量
        address user; // 定义一个地址类型的变量，用于存储用户地址

        // 如果流动性挖矿用户数量大于 0，并且流动性代币总量大于 0
        if(buySize > 0 && tokenTotal>0){
            if(buySize >10){ // 如果流动性挖矿用户数量大于 10
                for(uint256 i=0;i<10;i++){ // 循环 10 次
                    if(startLdxIndex >= buySize){startLdxIndex = 0;} // 如果起始索引大于等于流动性挖矿用户数量，则将起始索引重置为 0
                    user = ldxUser[startLdxIndex]; // 获取用户地址
                    rewardAmount = pair.balanceOf(user).mul(thisAmount).div(tokenTotal); // 计算奖励数量
                    if(rewardAmount >= 10**15){ // 如果奖励数量大于等于 10^15
                        pair.transfer(user, rewardAmount); // 将奖励数量的流动性代币转给用户
                        _haveLpAmount[user] = _haveLpAmount[user].add(rewardAmount.div(1000).mul(1011)); // 更新用户持有的流动性代币数量
                    }
                    startLdxIndex += 1; // 更新起始索引
                }
            }else{ // 否则
                for(uint256 i=0;i<buySize;i++){ // 循环流动性挖矿用户数量次
                    user = ldxUser[i]; // 获取用户地址
                    rewardAmount = pair.balanceOf(user).mul(thisAmount).div(tokenTotal); // 计算奖励数量
                    if(rewardAmount >= 10**15){ // 如果奖励数量大于等于 10^15
                        pair.transfer(user, rewardAmount); // 将奖励数量的流动性代币转给用户
                        _haveLpAmount[user] = _haveLpAmount[user].add(rewardAmount.div(1000).mul(1011)); // 更新用户持有的流动性代币数量
                    }
                }
            }
        }
    }

    // 将部分流动性代币分配给流动性挖矿用户
    function _splitOtherToken2Ldx() private
    {
        uint256 thisAmount = pair.balanceOf(address(this)); // 获取合约地址持有的流动性代币数量
        if(thisAmount >= 10**18){ // 如果合约地址持有的流动性代币数量大于等于 10^18
            _splitLpToken2LdxUserSecond(thisAmount.div(5).mul(3)); // 将 60% 的流动性代币分配给流动性挖矿用户
        }
    }

    // 获取流动性挖矿用户数量
    function getLdxUsersize() public view returns(uint256){
        return ldxUser.length;
    }

    // NFT 用户列表
    address[] nftUser;
    mapping(address => bool) private haveNftpush; // 定义一个映射，用于存储地址是否已添加到 NFT 用户列表中
    uint256 startNftIndex; // 定义一个 uint256 类型的变量，用于存储 NFT 用户列表的起始索引

    // 将部分 USDT 分配给 NFT 用户
    function _splitUsdtToken2NftUser(uint256 sendAmount) private {
        uint256 nftSize = nftUser.length; // 获取 NFT 用户数量
        uint256 rewardLpAmount; // 定义一个 uint256 类型的变量，用于存储奖励数量
        address user; // 定义一个地址类型的变量，用于存储用户地址

        // 如果 NFT 用户数量大于 0，并且总权重大于 0
        if(nftSize > 0 && totalWeight > 0){
            if(nftSize >10){ // 如果 NFT 用户数量大于 10
                for(uint256 i=0;i<10;i++){ // 循环 10 次
                    if(startNftIndex >= nftSize){startNftIndex = 0;} // 如果起始索引大于等于 NFT 用户数量，则将起始索引重置为 0
                    user = nftUser[startNftIndex]; // 获取用户地址
                    if(nft.balanceOf(user) > 0){ // 如果用户持有 NFT
                        rewardLpAmount = userNftWeight[user].mul(sendAmount).div(totalWeight); // 计算奖励数量
                        if(rewardLpAmount >= 10**15){ // 如果奖励数量大于等于 10^15
                            highFeePool.withdraw(user, rewardLpAmount); // 将奖励数量的 USDT 转给用户
                            _haveLpAmount[user] = _haveLpAmount[user].add(rewardLpAmount.div(1000).mul(1011)); // 更新用户持有的流动性代币数量
                        }
                    }
                    startNftIndex += 1; // 更新起始索引
                }
            }else{ // 否则
                for(uint256 i=0;i<nftSize;i++){ // 循环 NFT 用户数量次
                    user = nftUser[i]; // 获取用户地址
                    if(nft.balanceOf(user) > 0){ // 如果用户持有 NFT
                        rewardLpAmount = userNftWeight[user].mul(sendAmount).div(totalWeight); // 计算奖励数量
                        if(rewardLpAmount >= 10**15){ // 如果奖励数量大于等于 10^15
                            highFeePool.withdraw(user, rewardLpAmount); // 将奖励数量的 USDT 转给用户
                            _haveLpAmount[user] = _haveLpAmount[user].add(rewardLpAmount.div(1000).mul(1011)); // 更新用户持有的流动性代币数量
                        }
                    }
                }
            }
        }
    }

    // 将部分流动性代币分配给 NFT 用户
    function _splitLpToken2nftUser() private {
        uint256 thisAmount = pair.balanceOf(address(highFeePool)); // 获取 highFeePool 合约地址持有的流动性代币数量
        if(thisAmount >= 10**18){ // 如果 highFeePool 合约地址持有的流动性代币数量大于等于 10^18
            _splitUsdtToken2NftUser(thisAmount.div(5).mul(3)); // 将 60% 的流动性代币兑换为 USDT，并分配给 NFT 用户
        }
    }

    uint256 public totalWeight; // 定义一个 uint256 类型的变量，用于存储总权重
    mapping(address => uint256) public userNftWeight; // 定义一个映射，用于存储地址的 NFT 权重

    // 将用户添加到 NFT 用户列表中，并设置权重
    function pushNftUser(address user, uint256 weight) internal {
        if(!haveNftpush[user]){ // 如果用户未添加到 NFT 用户列表中
            haveNftpush[user] = true; // 将用户标记为已添加到 NFT 用户列表中
            nftUser.push(user); // 将用户添加到 NFT 用户列表中
        }
        totalWeight = totalWeight.add(weight); // 更新总权重
        userNftWeight[user] = userNftWeight[user].add(weight); // 更新用户的 NFT 权重
    }

    // 获取 NFT 用户数量
    function getNftUsersize() public view returns(uint256){
        return nftUser.length;
    }

    // 设置用户的 NFT 信息
    function setUsersNftInfor(address[] memory accounts, uint256[] memory values) public onlyOwner {
        for(uint256 i=0; i<accounts.length;i++){
            pushNftUser(accounts[i], values[i]); // 将用户添加到 NFT 用户列表中，并设置权重
        }
    }
}