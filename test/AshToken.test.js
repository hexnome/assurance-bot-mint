const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

// `describe` is a Mocha function that allows you to organize your tests.
// Having your tests organized makes debugging them easier. All Mocha
// functions are available in the global scope.
//
// `describe` receives the name of a section of your test suite, and a
// callback. The callback must define the tests of that section. This callback
// can't be an async function.
describe("AshToken contract", function () {
    const config = {
        name: "Ash Token",
        symbol: "ASH",
        decimals: 18,
        totalSupply: 100000000000000000000000n,
        daoFee: 800,
        marketingFee: 135,
        liquidityFee: 25,
        reflectionFee: 25,
        burnFee: 15,
        transferFee: 100,
        maxBuyFee: 100,
        maxSellFee: 100,
        initialLiquidity: 10000000000000000000000n,
        initialLiquidityBNB: 2000000000000000n,
        testTransferAmount: 50000000000000000000n,
        testFeeTransferAmount: 10000000000000000000n,
        daoAddress: "0xf3950787C0B81D3bF6C5A4f0c155A69A46fD924b",
        marketingAddress: "0xc056928cD87627E8B6eec4a613c0d1418E6e743D",
        routerAddress: "0xD99D1c33F9fC3444f8101754aBC46c52416550D1",
        wbnb: "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd"

    };

    let deployedToken;
    let tokenOwner;

    // We define a fixture to reuse the same setup in every test. We use
    // loadFixture to run this setup once, snapshot that state, and reset Hardhat
    // Network to that snapshot in every test.
    async function deployToken() {
        // Get the Signers here.
        const [owner, addr1, addr2] = await ethers.getSigners();

        // To deploy our contract, we just have to call ethers.deployContract and await
        // its waitForDeployment() method, which happens once its transaction has been
        // mined.
        const hardhatToken = await ethers.deployContract("AshToken", [config.daoAddress, config.marketingAddress]);
        
        await hardhatToken.waitForDeployment();
        console.log("=========Deployed Successfully=========")
        console.log("ASH Token Address: ", await hardhatToken.getAddress());
        console.log("Deployer Address: ", owner.address);

        // Fixtures can return anything you consider useful for your tests
        return { hardhatToken, owner, addr1, addr2 };
    }

    // You can nest describe calls to create subsections.
    describe("Deployment", function () {

        it("Should be deployed successfully", async function () {
            const { hardhatToken, owner } = await deployToken();
            deployedToken = hardhatToken;
            tokenOwner = owner;
        });
        // `it` is another Mocha function. This is the one you use to define each
        // of your tests. It receives the test name, and a callback function.
        //
        // If the callback function is async, Mocha will `await` it.
        it("Should set the right owner", async function () {

            // This test expects the owner variable stored in the contract to be
            // equal to our Signer's owner.
            expect(await deployedToken.owner()).to.equal(tokenOwner.address);
        });

        it("Should assign the total supply of tokens to the owner", async function () {
            const ownerBalance = await deployedToken.balanceOf(tokenOwner.address);
            expect(await deployedToken.totalSupply()).to.equal(ownerBalance);
        });

        it("Should set exact fee prices", async function () {
            // Check if the transfer Fee equals 10%
            expect(await deployedToken.transferTax()).to.equal(config.transferFee);

            // Check if DAO tax equals 80%
            expect(await deployedToken.daoFundTax()).to.equal(config.daoFee);

            // Check if Marketing tax equals 13.5%
            expect(await deployedToken.marketingTax()).to.equal(config.marketingFee);

            // Check if liquidity tax equals 2.5%
            expect(await deployedToken.liquidityTax()).to.equal(config.liquidityFee);

            // Check if reflection tax equals 2.5%
            expect(await deployedToken.reflectionsTax()).to.equal(config.reflectionFee);

            // Check if burning tax equals 1.5%
            expect(await deployedToken.burningTax()).to.equal(config.burnFee);

        });

    });

    // Test for the token distribution logic for non-fee and fee cases
    describe("Transactions", function () {
        it("Should add liquidity to Pancakeswap", async function () {
            // Add Liquidity to Pancakeswap before testing
            const tx = await deployedToken.approve(config.routerAddress, config.initialLiquidity);
            await tx.wait();

            // Create dexRouter here and use
            const router = await ethers.getContractAt(
                "IDexRouter",
                config.routerAddress
            );

            // Get blockTimestamp
            const timeStamp = (await ethers.provider.getBlock("latest")).timestamp;

            // Add liquidity with initialLiquidity Amount of ASH token and initialLiquidityBNB
            const liquidityTx = await router.addLiquidityETH(
                await deployedToken.getAddress(),
                config.initialLiquidity,
                0,
                0,
                tokenOwner.address,
                timeStamp+300,
                {
                    value: config.initialLiquidityBNB
                }
            );
            await liquidityTx.wait()
        });

        // Transfer ASH via non-fee addresses - excluded from Fees
        it("Should transfer tokens between accounts", async function () {
            // Get the Signers here.
            const [owner, addr1, addr2] = await ethers.getSigners();

            // Get the ASH balance of Sender/Receiver before transferring
            const beforeOwnerBal = await deployedToken.balanceOf(owner.address);
            const beforeBal = await deployedToken.balanceOf(addr2.address);

            // Transfer ASH tokens from Sender to Receiver
            const tx = await deployedToken.transfer(addr2.address, config.testTransferAmount);
            await tx.wait();

            // Get the ASH balance of Sender/Receiver after transferring
            const afterBal = await deployedToken.balanceOf(addr2.address);
            const afterOwnerBal = await deployedToken.balanceOf(owner.address);
                        
            // Check if all tokens are sent from Sender to Recevier
            expect(beforeOwnerBal - afterOwnerBal).to.equal(afterBal - beforeBal);
        });

        // Transfer ASH via fee addresss - non-excluded from Fees
        // Check all Fees - DAO Fee, Marketing Fee, Liquidity Fee and Reflection Logics
        it("Should Transfer tokens between non-excusion accounts", async function () {
            // Get the Signers here.
            const [owner, addr1, addr2] = await ethers.getSigners();

            // Get the ASH balance of Sender before transferring
            const beforeSenderBal = await deployedToken.balanceOf(addr2.address);
        
            // Transfer ASH tokens from Sender to Receiver
            const tx = await deployedToken.connect(addr2).transfer(addr1.address, config.testFeeTransferAmount);
            await tx.wait();

            // Get the ASH balance of Sender/Receiver/DAO/Marketer after transferring
            const afterSenderBal = await deployedToken.balanceOf(addr2.address);
            const afterReceiverBal = await deployedToken.balanceOf(addr1.address);
            const afterDaoBal = await deployedToken.balanceOf(config.daoAddress);
            const afterMarketingBal = await deployedToken.balanceOf(config.marketingAddress);

            const totalSupply = await deployedToken.totalSupply();

            // Check if the calcSenderBal is equal to real sender's Balance
            const calcSenderBal = (beforeSenderBal - config.testFeeTransferAmount)                                // Original Balance
                + (beforeSenderBal - config.testFeeTransferAmount)                                                // Original Balance                              
                * config.testFeeTransferAmount                                                                    // Transfer Amount          
                * BigInt(config.reflectionFee * config.transferFee) / (1000n * 1000n) / totalSupply;              // Reflection charge Amount       
            expect(afterSenderBal).to.equal(calcSenderBal);

            // Check if the calcReceiverBal is equal to real receiver's Balance
            const calcReceiverBal = config.testFeeTransferAmount * BigInt(1000 - config.transferFee) / 1000n       // Original Balance
                + config.testFeeTransferAmount * BigInt(1000 - config.transferFee) / 1000n                         // Original Balance                                                      
                * config.testFeeTransferAmount                                                                     // Transfer Amount                                      
                * BigInt(config.reflectionFee * config.transferFee) / (1000n * 1000n) / totalSupply;               // Reflection charge Amount                                      
            expect(afterReceiverBal).to.equal(calcReceiverBal);

            // Check if the calcDAOBal is equal to real DAO's Balance
            const calcDaoBal = config.testFeeTransferAmount * BigInt(config.daoFee * config.transferFee) / (1000n * 1000n)    // Original Balance          
                + config.testFeeTransferAmount * BigInt(config.daoFee * config.transferFee) / (1000n * 1000n)                 // Original Balance                    
                * config.testFeeTransferAmount                                                                                // Transfer Amount                                                    
                * BigInt(config.reflectionFee * config.transferFee) / (1000n * 1000n) / totalSupply;                          // Reflection charge Amount                                            
            expect(afterDaoBal).to.equal(calcDaoBal);

            // Check if the calcMarketingBal is equal to real Marketing's Balance
            const calcMarketingBal = config.testFeeTransferAmount * BigInt(config.marketingFee * config.transferFee) / (1000n * 1000n)   // Original Balance                   
                + config.testFeeTransferAmount * BigInt(config.marketingFee * config.transferFee) / (1000n * 1000n)                      // Original Balance                         
                * config.testFeeTransferAmount                                                                                           // Transfer Amount                         
                * BigInt(config.reflectionFee * config.transferFee) / (1000n * 1000n) / totalSupply;                                     // Reflection charge Amount                                                 
            expect(afterMarketingBal).to.equal(calcMarketingBal);
        
        });

        // Transfer ASH via non-fee addresses - excluded from Fees
        it("Should Claim Stuck tokens", async function () {
            const tokenAddress = await deployedToken.getAddress()

            // Get the ASH balance of tokenAddress before claiming
            const beforeBal = await deployedToken.balanceOf(tokenAddress);

            // Transfer ASH tokens from Sender to Receiver
            const tx = await deployedToken.claimStuckTokens(tokenAddress);
            await tx.wait();

            // Get the ASH balance of tokenAddress after claiming
            const afterBal = await deployedToken.balanceOf(tokenAddress);
            // Check if all tokens are sent from tokenContract to Owner
            expect(afterBal).to.equal(0n);
        });


    });
});