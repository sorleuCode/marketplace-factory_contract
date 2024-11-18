// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "./MarketPlace.sol";
import {IMarketPlace} from "./IMarketPlace.sol";
import {ReUsables} from "./Library.sol";

contract MarketPlace_Factory {

    address owner;
    IMarketPlace markeplace;




    struct DeployedContractInfo {
        address deployer;
        address deployedContract;
    }

    mapping (address => DeployedContractInfo[]) allUserDeployedContracts;


    DeployedContractInfo[] allContracts;

    constructor (IMarketPlace _markeplace)  {
        markeplace = _markeplace;
        owner = msg.sender;
    }

     function deployMarketPlace () external  returns (address contractAddress_) {

        require(msg.sender != address(0),  "Zero not allowed");

        address _address = address(new MarketPlace());

        contractAddress_ = _address;

        DeployedContractInfo memory _deployedContract;

        _deployedContract.deployer = msg.sender;
        _deployedContract.deployedContract = _address;

         allUserDeployedContracts[msg.sender].push(_deployedContract);

         allContracts.push(_deployedContract);

    }

       function getAllContractsDeployed() external  view returns (DeployedContractInfo[] memory) {
        onlyOwner();
        return allContracts;
    }

    function getUserDeployedContracts () external  view returns (DeployedContractInfo[] memory) {
        return allUserDeployedContracts[msg.sender];
    }
    

    function getUserDeployedContractByIndex (uint8 _index) external  view returns(address deployer_, address deployedContract_) {
        require(_index < allUserDeployedContracts[msg.sender].length, "Out of bound");
        DeployedContractInfo memory _deployedContract = allUserDeployedContracts[msg.sender][_index];

        deployer_ = _deployedContract.deployer;
        deployedContract_ = _deployedContract.deployedContract;
    }

    function getLengthOfDeployedContract () external  view returns (uint256 length_) {
        length_ = allContracts.length;

    }

    function createListOrder (string memory _name, uint256 _price) external {
        require(msg.sender != address(0));
        markeplace.listOrder(msg.sender, _name, _price);
    }


    function createBuyOrder(uint8 _index) external {
        require(msg.sender != address(0));
        markeplace.buyOrder(_index, msg.sender);

    }

    function getAllTheListedAssets() external  view returns(ReUsables.Asset[] memory assets_) {
        require(msg.sender != address(0));

        assets_ = markeplace.getAllListedAssets(msg.sender);


    }


    function getUserTransactionRecords() external  view returns(ReUsables.Asset[] memory usereRecords_) {

        require(msg.sender != address(0));

        usereRecords_ = markeplace.getUserTransactionRecords(msg.sender);

    }





     function onlyOwner () private view {
        require(msg.sender == owner, "Only for the owner");
    }
   
}