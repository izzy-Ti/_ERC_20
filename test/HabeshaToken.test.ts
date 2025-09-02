import { expect } from "chai";
import { ethers } from "hardhat";

describe("HabeshaToken", function () {
  let token: any;
  let owner: any;
  let addr1: any;
  let addr2: any;

  const cap = ethers.parseUnits("100000000", 18);
  const initialOwnerSupply = ethers.parseUnits("70000000", 18);
  const initialReward = ethers.parseUnits("50", 18);

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    const HabeshaToken = await ethers.getContractFactory("HabeshaToken");
    token = await HabeshaToken.deploy(
      ethers.parseUnits("100000000", 0),
      ethers.parseUnits("50", 0)
    );

    await token.waitForDeployment();
  });

  it("Should set the right owner", async function () {
    expect(await token.owner()).to.equal(owner.address);
  });

  it("Should mint 70 million tokens to the owner", async function () {
    const balance = await token.balanceOf(owner.address);
    expect(balance).to.equal(initialOwnerSupply);
  });

  it("Should set the correct block reward", async function () {
    const reward = await token.blockReward();
    expect(reward).to.equal(initialReward);
  });

  it("Should allow only the owner to set block reward", async function () {
    const newReward = ethers.parseUnits("100", 0);

    await expect(
      token.connect(addr1).setBlockReward(newReward)
    ).to.be.revertedWith("Sorry you must be an owner to access this one");

    await token.setBlockReward(newReward);
    const updatedReward = await token.blockReward();
    expect(updatedReward).to.equal(ethers.parseUnits("100", 18));
  });

  it("Should not allow total supply to exceed cap", async function () {
    const mintAmount = cap - initialOwnerSupply + ethers.parseUnits("1", 18);

    await expect(
      token.connect(owner)._mint(owner.address, mintAmount)
    ).to.be.revertedWith("ERC20Capped: cap exceeded");
  });
});
