// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import {ReUsables} from "./Library.sol";

interface IMarketPlace {
    function listOrder(address _caller, string memory _name, uint256 _price) external;
    function buyOrder(uint8 _index, address _caller) external ;
    function getAllListedAssets(address _caller) external  view returns(ReUsables.Asset[] memory);
    function getUserTransactionRecords(address _caller) external  view returns(ReUsables.Asset[] memory);


    
}