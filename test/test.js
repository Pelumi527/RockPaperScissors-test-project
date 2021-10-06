const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RockpaperScissors", function () {
  let Player1, Player2, Token, token, rockscissor;
  
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    [Player1, Player2] = await ethers.getSigners();
    
    Token = await hre.ethers.getContractFactory("TestToken");
    token = await Token.deploy();

    await token.deployed()

    const RockPaperScissor = await ethers.getContractFactory("RockPaperScissors");
    rockscissor = await RockPaperScissor.deploy(token.address, "100", Player1.address, Player2.address );
    await rockscissor.deployed();

    await token.approve(rockscissor.address,ethers.utils.parseEther("100000000"));
    await token.approve(Player2.address, ethers.utils.parseEther("2000"))
    await token.transfer(Player2.address, ethers.utils.parseEther("2000"));
    await token.connect(Player2).approve(rockscissor.address,ethers.utils.parseEther("20000000"));
  });

  it("Must pay Stake Amount", async function () {
    await expect(
      rockscissor.stake("10")
    ).to.be.revertedWith("_amt deposited not up to the amount be staked")
  });

  it("Should play properly and give winnings to winner", async function () {
    await rockscissor.stake("100");
    await rockscissor.connect(Player2).stake("100");
    await rockscissor.player1Move("1");
    await rockscissor.connect(Player2).player2Move("2");
    await rockscissor.checkWinner();
    const bal2 = await token.connect(Player2).balanceOf(Player2.address)
  expect(bal2).to.equal("2000000000000000000100")
  });

  it("Must stake before playing", async function () {
    await expect(
      rockscissor.player1Move("1")
    ).to.be.revertedWith("You need to stake first")
  });

  it("cannot play twice", async function () {
    await rockscissor.stake("100");
    await rockscissor.player1Move("1")
    await expect(
      rockscissor.player1Move("1")
    ).to.be.revertedWith("already played")
  });
});
