// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

interface IDexRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

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
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

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

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}

interface IDexFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

contract AshToken is ERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    uint256 public maxTax = 100;            // 10% maximum tax :                        10% = 100
    uint256 public buyTax;
    uint256 public sellTax;

    uint256 public transferTax = 100;       // 10% Distribution tax :                   10% = 100
    uint256 public daoFundTax = 800;        // 80% tax for DAO Fund :                   80% = 800
    uint256 public marketingTax = 135;      // 13.5% tax for Marketing/Operations :     13.5% = 135
    uint256 public liquidityTax = 25;       // 2.5% tax for Liquidity Pool :            2.5% = 25
    uint256 public reflectionsTax = 25;     // 2.5% tax for Reflections :               2.5% = 25
    uint256 public burningTax = 15;         // 1.5% burning :                           1.5% = 15

    uint256 public daoThrehold;
    uint256 public marketingThrehold;

    address public dexRouter;
    address public lpPair;
    address public DAO_ADDRESS;
    address public MARKETING_ADDRESS;

    uint256 private constant MAX = ~uint256(0);
    uint256 private constant _tTotal = 10 * 10**13 * 10**18;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => bool) public isExcludedFromFees;
    mapping (address => bool) public automatedMarketMakerPairs;

    bool private inSwapAndLiquify;

    event ExcludeFromFees(address indexed account, bool indexed value);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event SetDAOFundAddress(address indexed daoAddress);
    event SetMarketingAddress(address indexed marketingAddress);
    event SetBuySellTax(uint256 buyTax, uint256 sellTax);
    event SwapAndEvolve(uint256 ashSwapped, uint256 bnbReceived, uint256 ashIntoLiquidity);

    constructor(
        address _daoAddress,
        address _marketingAddress
    ) ERC20("Ash Token", "ASH") Ownable(msg.sender) {

        address wbnb;

        if (block.chainid == 56) {
            // bsc mainnet
            wbnb = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;          // WETH
            dexRouter = 0x13f4EA83D0bd40E75C8222255bc855a974568Dd4;     // PCS V2
            // dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;     // PCS V3
        } else if (block.chainid == 97) {
            // bsc testnet
            wbnb = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;          // WETH
            dexRouter = 0x9a489505a00cE272eAa5e07Dba6491314CaE3796;     // PCS V2
        } else if (block.chainid == 5) {
            wbnb = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;          // WETH
            dexRouter = 0x9a489505a00cE272eAa5e07Dba6491314CaE3796;     // PCS V2

        } else {
            revert("Chain not configured");
        }

        // Create Pair
        lpPair = IDexFactory(IDexRouter(dexRouter).factory()).createPair(
            address(this),
            wbnb
        );

        isExcludedFromFees[msg.sender] = true;
        isExcludedFromFees[address(this)] = true;
        isExcludedFromFees[address(0xdead)] = true;

        DAO_ADDRESS = _daoAddress; // Set the DAO Fund address
        MARKETING_ADDRESS = _marketingAddress; // Set the Marketing/Operations address

        _mint(msg.sender, 10000000000000 * (10 ** uint256(decimals())));
    }

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    receive() external payable {}

    function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate = _getRate();
        return rAmount.div(currentRate);
    }

    function _update(address sender, address recipient, uint256 amount) internal virtual override {
        require(amount > 0, "Transfer amount must be greater than zero");

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (isExcludedFromFees[sender] || isExcludedFromFees[recipient]) {
            takeFee = false;
        }

        uint256 feeAmount;

        if (automatedMarketMakerPairs[sender]) feeAmount = buyTax;
        else if (automatedMarketMakerPairs[recipient]) feeAmount = sellTax;
        else feeAmount = transferTax;

        if (inSwapAndLiquify) feeAmount = 0;
            
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(amount, feeAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
        _takeFees(sender, feeAmount);      
        _reflectFee(rFee, tFee);

        emit Transfer(sender, recipient, tTransferAmount);

    }

    function swapTokensForBnb(uint256 tokenAmount, address receiver) private lockTheSwap{
        // generate the uniswap pair path of token -> wbnb
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = IDexRouter(dexRouter).WETH();

        _approve(address(this), address(dexRouter), tokenAmount);

        IDexRouter(dexRouter).swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            receiver,
            block.timestamp
        );
        
    }

    function swapAndEvolve() public onlyOwner lockTheSwap {
        // split the contract balance into halves
        uint256 contractAshBalance = balanceOf(address(this));
        // require(contractAshBalance >= numOfAshToSwapAndEvolve, "ASH balance is not reach for S&E Threshold");

        uint256 half = contractAshBalance.div(2);
        uint256 otherHalf = contractAshBalance.sub(half);

        // capture the contract's current BNB balance.
        // this is so that we can capture exactly the amount of BNB that the
        // swap creates, and not make the liquidity event include any BNB that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;
        
        // swap ASH for BNB
        swapTokensForBnb(half, address(this));

        // how much BNB did we just swap into?
        uint256 newBalance = address(this).balance;
        uint256 swapeedBNB = newBalance.sub(initialBalance);

        // add liquidity to Pancakeswap
        addLiquidity(otherHalf, swapeedBNB);

        emit SwapAndEvolve(half, swapeedBNB, otherHalf);
    }

    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(dexRouter), tokenAmount);

        // add the liquidity
        IDexRouter(dexRouter).addLiquidityETH{ value: bnbAmount }(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    function _takeFees(
        address sender,
        uint256 feeAmount
    ) private {
        uint256 daoFee = feeAmount.mul(daoFundTax).div(1000);
        uint256 marketingFee = feeAmount.mul(marketingTax).div(1000);

        if (balanceOf(DAO_ADDRESS) + daoFee > daoThrehold) {
            _takeFee(sender, daoFee, address(this));
            swapTokensForBnb(daoFee, DAO_ADDRESS); 
        } else {
            _takeFee(sender, daoFee, DAO_ADDRESS);
        }

        if (balanceOf(MARKETING_ADDRESS) + marketingFee > marketingThrehold) {
            _takeFee(sender, marketingFee, address(this));
            swapTokensForBnb(marketingFee, MARKETING_ADDRESS); 
        } else {
            _takeFee(sender, marketingFee, MARKETING_ADDRESS);
        }

        _takeFee(sender, feeAmount.mul(liquidityTax).div(1000), address(this));
        _takeBurn(sender, feeAmount.mul(burningTax).div(1000));
    }

    function _takeFee(
        address sender,
        uint256 tAmount,
        address recipient
    ) private {
        if (recipient == address(0)) return;
        if (tAmount == 0) return;

        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount.mul(currentRate);
        _rOwned[recipient] = _rOwned[recipient].add(rAmount);

        emit Transfer(sender, recipient, tAmount);
    }

    function _takeBurn(address sender, uint256 _amount) private {
        if (_amount == 0) return;
        _tOwned[address(0xdead)] = _tOwned[address(0xdead)].add(_amount);
        uint256 _rAmount = _amount * _getRate();
        _rOwned[address(0xdead)] = _rOwned[address(0xdead)].add(_rAmount);
        
        emit Transfer(sender, address(0xdead), _amount);
    }
    
    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

     function _getValues(uint256 tAmount, uint256 feeAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, feeAmount);
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
    }

    function _getTValues(uint256 tAmount, uint256 feeAmount) private pure returns (uint256, uint256) {
        uint256 tFee = tAmount.mul(feeAmount).div(1000);
        uint256 tTransferAmount = tAmount.sub(tFee);
        return (tTransferAmount, tFee);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
       
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }



    function claimStuckTokens(address _token) external onlyOwner {
        IERC20 token = IERC20(_token);
        token.transfer(owner(), token.balanceOf(address(this)));
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        require(isExcludedFromFees[account] != excluded, "error: Account is already the value of 'excluded'");
        isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    function setAutomatedMarketMakerPair(
        address pair,
        bool value
    ) public onlyOwner {
        require(
            pair != lpPair || value,
            "The pair cannot be removed from automatedMarketMakerPairs"
        );
        automatedMarketMakerPairs[pair] = value;
     
        emit SetAutomatedMarketMakerPair(pair, value);
    }
    
    function setDAOFundAddress(address _address) external onlyOwner {
        require(
            _address != address(0),
            "DAO Fund Address should be non-zero address"
        );
        DAO_ADDRESS = _address;

        emit SetDAOFundAddress(_address);
    }

    function setMarketingAddress(address _address) external onlyOwner {
        require(
            _address != address(0),
            "Marketing Address should be non-zero address"
        );
        MARKETING_ADDRESS = _address;

        emit SetMarketingAddress(_address);
    }

    function setTax(uint256 _buyTax, uint256 _sellTax) external onlyOwner {
        require(_buyTax <= 10 || _sellTax <= 10, "Cannot exceed maximum tax of 10%");

        buyTax = _buyTax;
        sellTax = _sellTax;

        emit SetBuySellTax(_buyTax, _sellTax);
    }
}
