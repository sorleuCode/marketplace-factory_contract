import {
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { expect, should } from "chai";
  import { ethers } from "hardhat";
  import "@nomicfoundation/hardhat-toolbox";
  import "@nomicfoundation/hardhat-ethers";
  
  describe("Claim_Faucet_Factory", function () {

    async function deployContractsFixture() {
        const [deployer, user1, user2] = await ethers.getSigners();

        const assetPrice = 600


        const myAsset = {
            name: "Shoe",
            price: assetPrice,

        }

        const MarketPlace = await ethers.getContractFactory("MarketPlace");
        const marketPlace = await MarketPlace.connect(deployer).deploy()
        
        const  MarketPlaceFactory = await ethers.getContractFactory("MarketPlace_Factory");
        
        const marketPlaceFactory = await MarketPlaceFactory.connect(deployer).deploy(marketPlace)
    
        return { marketPlaceFactory, marketPlace, myAsset,  deployer, user1, user2};
      }


      describe('Deploy', () => {
        it("Should deploy claimaFaucetFactory correctly", async function () {
  
          const {marketPlaceFactory, marketPlace} =  await loadFixture(deployContractsFixture);
  
          expect( await marketPlaceFactory.getAddress()).to.be.properAddress;
          expect( await marketPlace.getAddress()).to.be.properAddress;
          
        });
  

      });

      describe('Functions', () => {
        it("should deploy MarketPlace contract correctly", async function () {
          
        
          const {marketPlaceFactory, marketPlace, deployer} = await loadFixture(deployContractsFixture);
          const deployedAddress =  await marketPlaceFactory.connect(deployer).deployMarketPlace();
  
           expect(deployedAddress).to.not.undefined;
            expect((await marketPlaceFactory.connect(deployer).getUserDeployedContracts()).length).to.be.greaterThan(0);
  
        });
  
        
        it("should be able to get a deployed contract deployed by a user", async function () {
  
          const {marketPlaceFactory, deployer} = await loadFixture(deployContractsFixture);
  
          await marketPlaceFactory.connect(deployer).deployMarketPlace();
  
          const [deployerAddr] = await marketPlaceFactory.connect(deployer).getUserDeployedContractByIndex(0);
  
          expect(deployerAddr).to.be.equal(deployer)
          
        }) 
  

        
        
        it("should get all the deployed contracts on this platform", async function () {
          const { marketPlaceFactory, user1, user2 } = await loadFixture(deployContractsFixture);
        
          await marketPlaceFactory.connect(user1).deployMarketPlace();
          await marketPlaceFactory.connect(user2).deployMarketPlace();
  
          const AllDeployedContracts = await marketPlaceFactory.getAllContractsDeployed();
  
          expect(AllDeployedContracts.length).to.be.equal(2)
  
          
          
        });
  
  
        it("should allow  user to  create listing order", async function () {
          const { marketPlaceFactory, marketPlace, deployer, myAsset, user1, user2} = await loadFixture(deployContractsFixture);
        
          await marketPlaceFactory.connect(user1).deployMarketPlace();

          await expect(marketPlaceFactory.connect(user2).createListOrder(myAsset.name, myAsset.price)).to.emit(marketPlace,"AssetListed").withArgs(myAsset.name, myAsset.price);
  
          
          
        });
        it("should allow  user to  create buy order", async function () {
          const { marketPlaceFactory, marketPlace, deployer, myAsset, user1, user2} = await loadFixture(deployContractsFixture);
          
        
          await expect( marketPlaceFactory.connect(user1).createListOrder(myAsset.name, myAsset.price)).to.emit(marketPlace,"AssetListed").withArgs(myAsset.name, myAsset.price);

          await expect(marketPlaceFactory.connect(user2).createBuyOrder(0)).to.emit(marketPlace,"AssetISNoMoreAvailable").withArgs(myAsset.name, myAsset.price, user2.address);
  
          
          
        });
        
        it("should get user tx records", async function () {
          const { marketPlaceFactory, marketPlace, deployer, myAsset, user1, user2} = await loadFixture(deployContractsFixture);
          
        
          await expect( marketPlaceFactory.connect(user1).createListOrder(myAsset.name, myAsset.price)).to.emit(marketPlace,"AssetListed").withArgs(myAsset.name, myAsset.price);
          await expect( marketPlaceFactory.connect(user2).createListOrder(myAsset.name, myAsset.price)).to.emit(marketPlace,"AssetListed").withArgs(myAsset.name, myAsset.price);

          await expect(marketPlaceFactory.connect(user2).createBuyOrder(0)).to.emit(marketPlace,"AssetISNoMoreAvailable").withArgs(myAsset.name, myAsset.price, user2.address);


          expect((await marketPlaceFactory.connect(user2).getUserTransactionRecords()).length).to.equal(2);
  
          
          
        });
        
        
      })
    

  });
  