// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


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
    uint256 public maxTax = 100;            // 10% maximum tax :                        10% = 100
    uint256 public buyTax;
    uint256 public sellTax;

    uint256 public transferTax = 10;        // 10% Distribution tax :                   10% = 10
    uint256 public daoFundTax = 80;         // 80% tax for DAO Fund :                   80% = 80
    uint256 public marketingTax = 135;      // 13.5% tax for Marketing/Operations :     13.5% = 135
    uint256 public liquidityTax = 25;       // 2.5% tax for Liquidity Pool :            2.5% = 25
    uint256 public reflectionsTax = 25;     // 2.5% tax for Reflections :               2.5% = 25
    uint256 public burningTax = 15;         // 1.5% burning :                           1.5% = 15

    address public lpPair;
    address public DAO_ADDRESS;
    address public MARKETING_ADDRESS;

    mapping(address => bool) public isExcludedFromFees;
    mapping(address => bool) public automatedMarketMakerPairs;

    event ExcludeFromFees(address indexed account, bool indexed value);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event SetDAOFundAddress(address indexed daoAddress);
    event SetMarketingAddress(address indexed marketingAddress);
    event SetBuySellTax(uint256 buyTax, uint256 sellTax);

    constructor(
        address _daoAddress,
        address _marketingAddress
    ) ERC20("Ash Token", "ASH") 
    Ownable(msg.sender) {

        address wbnb;
        address dexRouter;

        if (block.chainid == 56) {
            // bsc mainnet
            wbnb = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;          // WETH
            dexRouter = 0x13f4EA83D0bd40E75C8222255bc855a974568Dd4;     // PCS V2
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

    function _update(address sender, address recipient, uint256 amount) internal virtual override {
        // Transfer Tax Calculating Part


        super._update(sender, recipient, amount);
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
